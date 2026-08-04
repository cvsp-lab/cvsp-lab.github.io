#!/usr/bin/env bash
# Diff the live cvsp-lab org against what the hub currently advertises.
#
# Sources of truth:
#   org      — scripts/org-state.sh (gh repo list + per-repo Pages API)
#   hub      — the PROJECTS array in index.html
#   readme   — the "Page Lists" table in README.md
#
# Reports four kinds of drift and exits 1 if any is found, 0 if in sync.
# It never edits anything — deciding what to do with each finding is the
# skill's job, because several of them need a human call (venue, title, order).
#
# Usage: scripts/hub-diff.sh
set -uo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$(git -C "$SKILL_DIR" rev-parse --show-toplevel)"
INDEX="$ROOT/index.html"
README="$ROOT/README.md"

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

"$SKILL_DIR/scripts/org-state.sh" > "$tmp/org.tsv" || { echo "gh query failed" >&2; exit 2; }

# Ignore list: first field of each non-comment line.
grep -vE '^\s*(#|$)' "$SKILL_DIR/ignore.txt" | awk '{print $1}' | sort -f > "$tmp/ignore"

# Candidates: public, non-fork, not ignored.
awk -F'\t' '$2=="public" && $3=="-" {print $1"\tpages="$4"\t"$6}' "$tmp/org.tsv" | sort -f > "$tmp/candidates"
cut -f1 "$tmp/candidates" | comm -23 - "$tmp/ignore" > "$tmp/org_repos"

# Hub entries: repo name + how the entry claims to be hosted.
#   nopage   — declares page:false (code-only card)
#   external — declares its own url: (page lives outside paper.pnu-cvsp.com)
#   page     — default, served at https://paper.pnu-cvsp.com/<repo>/
grep -oE '\{ *repo: *"[^"]+".*$' "$INDEX" \
  | sed -E 's/.*repo: *"([^"]+)".*/\1\t&/' \
  | awk -F'\t' '{
      if ($2 ~ /page: *false/)   pf = "nopage";
      else if ($2 ~ /url: *"/)   pf = "external";
      else                       pf = "page";
      print $1"\t"pf }' \
  | sort -f > "$tmp/hub.tsv"
cut -f1 "$tmp/hub.tsv" > "$tmp/hub_repos"

# README table rows, keyed on the repository link.
grep -oE 'github\.com/cvsp-lab/[A-Za-z0-9._-]+' "$README" \
  | sed 's|.*/||' | sort -fu > "$tmp/readme_repos"

drift=0
section() { printf '\n== %s ==\n' "$1"; }

section "MISSING from the hub (public repo, not in index.html)"
if comm -23 "$tmp/org_repos" "$tmp/hub_repos" | grep -q .; then
  drift=1
  while read -r r; do
    printf '  %-20s %s\n' "$r" "$(awk -F'\t' -v r="$r" '$1==r{print $2"  "$3}' "$tmp/candidates")"
  done < <(comm -23 "$tmp/org_repos" "$tmp/hub_repos")
else
  echo "  (none)"
fi

section "STALE in the hub (in index.html, no matching public repo)"
if comm -13 "$tmp/org_repos" "$tmp/hub_repos" | grep -q .; then
  drift=1
  # Distinguish the three ways an entry can go stale — they need different fixes.
  while read -r r; do
    read -r vis fork < <(awk -F'\t' -v r="$r" '$1==r{print $2" "$3}' "$tmp/org.tsv")
    if   [ "$vis" = "PRIVATE" ]; then
      printf '  %-20s repo is now PRIVATE — remove the entry, its links 404 for visitors\n' "$r"
    elif [ "$fork" = "fork" ]; then
      printf '  %-20s repo is a fork — hub entries should point at repos the org owns\n' "$r"
    elif [ "$vis" = "public" ]; then
      printf '  %-20s public but listed in ignore.txt — drop it from the hub or un-ignore it\n' "$r"
    else
      printf '  %-20s no such repo in the org — renamed or deleted; confirm before removing\n' "$r"
    fi
  done < <(comm -13 "$tmp/org_repos" "$tmp/hub_repos")
else
  echo "  (none)"
fi

section "PAGES flag mismatch (page:false vs. live Pages API)"
mismatch=0
while IFS=$'\t' read -r repo flag; do
  live=$(awk -F'\t' -v r="$repo" '$1==r{print $4}' "$tmp/org.tsv")
  [ -z "$live" ] && continue                       # already reported as STALE
  case "$flag" in
    external) echo "  $repo — external url:, Pages on the repo is $( [ "$live" = "-" ] && echo disabled || echo "$live" ) (informational)" ;;
    page)     [ "$live" = "-" ] && { echo "  $repo — hub links a Project Page, but Pages is disabled on the repo"; mismatch=1; } ;;
    nopage)   [ "$live" != "-" ] && { echo "  $repo — hub says page:false, but Pages is live at $live"; mismatch=1; } ;;
  esac
done < "$tmp/hub.tsv"
if [ "$mismatch" = 1 ]; then drift=1; else echo "  (no actionable mismatch)"; fi

section "README out of sync with index.html"
if ! diff -q <(sort -f "$tmp/hub_repos") "$tmp/readme_repos" >/dev/null; then
  drift=1
  comm -23 <(sort -f "$tmp/hub_repos") "$tmp/readme_repos" | sed 's/^/  only in index.html: /'
  comm -13 <(sort -f "$tmp/hub_repos") "$tmp/readme_repos" | sed 's/^/  only in README.md:  /'
else
  echo "  (none)"
fi

echo
[ "$drift" = 0 ] && echo "hub is in sync with the org." || echo "drift found — see sections above."
exit "$drift"
