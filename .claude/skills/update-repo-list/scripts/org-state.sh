#!/usr/bin/env bash
# Dump the current state of the cvsp-lab org as a table:
#   <repo> <TAB> <public|PRIVATE> <TAB> <fork|-> <TAB> <pages url or "-"> <TAB> <branch:path or "-"> <TAB> <description>
#
# Pages status comes from the per-repo Pages API (404 = Pages disabled), which
# is the only reliable signal — the repo's homepageUrl field is hand-typed and
# frequently stale or empty even when a page exists.
#
# Usage: scripts/org-state.sh [org]
set -uo pipefail

ORG="${1:-cvsp-lab}"

gh repo list "$ORG" --limit 200 \
  --json name,description,isPrivate,isFork \
  --jq '.[] | [.name, (if .isPrivate then "PRIVATE" else "public" end), (if .isFork then "fork" else "-" end), .description] | @tsv' \
| sort -f \
| while IFS=$'\t' read -r name vis fork desc; do
    # gh prints the 404 body to stdout, so gate on the exit status, not on output.
    if pages=$(gh api "repos/$ORG/$name/pages" \
                 --jq '[.html_url, (.source.branch + ":" + .source.path)] | @tsv' 2>/dev/null) \
       && [ -n "$pages" ]; then
      :
    else
      pages=$'-\t-'
    fi
    printf '%s\t%s\t%s\t%s\t%s\n' "$name" "$vis" "$fork" "$pages" "$desc"
  done
