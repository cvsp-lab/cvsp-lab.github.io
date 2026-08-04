---
name: update-repo-list
description: Sync the CVSP Lab project hub (index.html PROJECTS array + README.md table) with the live cvsp-lab GitHub org. Use when a new lab project/paper repo should appear on paper.pnu-cvsp.com, when a project page was just enabled or moved, when a venue/title changed (e.g. accepted at a conference), or when asked to check whether the hub is still up to date with the org.
---

# Update the project hub's repo list

This repo (`cvsp-lab/cvsp-lab.github.io`) is the org-pages site for **paper.pnu-cvsp.com**. It contains no project content — only a hub listing every project page. Each project lives in its own repo under the `cvsp-lab` org with GitHub Pages enabled, and is served at `https://paper.pnu-cvsp.com/<repo>/`.

The list is duplicated in **two** places that must never diverge:

| File | Where | Purpose |
|:--|:--|:--|
| `index.html` | `PROJECTS` array in the inline `<script>` | Renders the cards on the live site |
| `README.md` | "Page Lists" table | What people see on GitHub |

## The hard rule: public repos only

The hub is a public website. **Only public, org-owned repos may appear in it** — never a private repo, never a fork.

- A private repo's card would advertise a name, paper title and venue that nobody outside the lab can open. Both its *Code* and *Project Page* links 404 for every visitor, and the card itself leaks the existence and title of unpublished work.
- A fork's card sends people to someone else's repository under the lab's name.

`hub-diff.sh` enforces this in both directions: private and forked repos are never proposed as MISSING, and an entry whose repo has since been flipped private or is a fork is reported under STALE with that exact reason. Private repos in this org are real and current — `MoE-GS_private`, `MoE-GS-studio_private`, `coding-test` — so this is not a hypothetical.

If a paper is still under embargo, wait for the repo to be made public. Do **not** pre-add the entry with `page: false` as a placeholder; that still publishes the title.

## Workflow

### 1. Diff the hub against the org

```bash
.claude/skills/update-repo-list/scripts/hub-diff.sh
```

Exit 0 = in sync, 1 = drift, 2 = the `gh` query failed. It reports four categories:

- **MISSING** — a public non-fork repo that isn't in `index.html` (with its Pages URL and description).
- **STALE** — an `index.html` entry with no matching public repo, annotated with *why*: now private (remove it immediately — the links are dead and the title is exposed), a fork, ignored by `ignore.txt`, or absent from the org entirely (renamed or deleted — confirm with the user before removing).
- **PAGES flag mismatch** — the entry's `page:`/`url:` shape contradicts the live Pages API. Entries with an explicit `url:` are listed as informational, not as drift.
- **README out of sync** — the two lists don't cover the same repos.

`scripts/org-state.sh` prints the raw org table if you need it directly (repo, visibility, fork, Pages URL, source `branch:path`, description). Pages status comes from `gh api repos/<org>/<repo>/pages` — the repo's `homepageUrl` field is hand-typed and often stale or empty even when a page exists, so never trust it.

### 2. Triage each MISSING repo — do not auto-add

Not every repo belongs on the hub. Before proposing an addition, judge from the description and Pages status:

- **Add it** when it's a paper release or project page (has a venue, a paper title, or a live page under `paper.pnu-cvsp.com`).
- **Ignore it permanently** when it's infrastructure, coursework, a scratch/test copy, tooling, or a superseded duplicate — append it to `ignore.txt` with a one-line reason so it stops surfacing on every run.
- **Ask the user** when it's genuinely ambiguous (a bare repo with no description and no page). Don't guess a venue or invent a title.

Forks and private repos never reach this step (see the hard rule above); `ignore.txt` handles the rest. Don't add them to `ignore.txt` either — visibility can change, and an ignore entry would suppress the repo forever once it goes public.

### 3. Edit `index.html`

Append the entry to the `PROJECTS` array. The array is ordered **most recent first** — newest preprint at the top, oldest publication at the bottom. Keep the existing column alignment of the object literals.

```js
{ repo: "MyProject", venue: "CVPR 2026", title: "MyProject: My Beautiful Project Title" },
```

Field rules:

- `repo` — exact repo name, case-sensitive. It's both the card's monospace label and the URL segment.
- `venue` — `ICLR 2026`, `TPAMI 2026`, `ACM TOMM`, `Preprint`, `Under Review`. Take it from the `[VENUE]` prefix in the repo description when present.
- `title` — full paper title. Existing entries use `ShortName: Full Title` when the paper has a method name.
- `url` — **omit by default**; it falls back to `https://paper.pnu-cvsp.com/<repo>/`. Set it only when the page is hosted elsewhere (e.g. `ACMTOMM_M2A` points at a personal GitHub Pages site).
- `page: false` — set when the repo has **no** page at all. The card then shows only the *Code* link instead of a dead *Project Page* link.
- `muted: true` — renders the venue badge in grey. Used for non-final states like `Under Review`.

### 4. Edit `README.md`

Add a matching row to the "Page Lists" table, in the **same order** as the array. Note the table's conventions differ from the array:

- The link text is the **short project name** (`3D-MOM`), not the repo name (`ICLR2025_3D-MOM`).
- The Title column drops the method-name prefix — `index.html` has `"MoE-GS: Mixture of Experts for…"`, the table has just `Mixture of Experts for…`.
- A code-only project uses `— (code only)` in the Page column and keeps the full `Name: Title` in the Title column.
- Venue goes in backticks; the Repository column is a `[cvsp-lab/repo](url)` link.

### 5. Verify

```bash
.claude/skills/update-repo-list/scripts/hub-diff.sh   # must now exit 0
```

Then confirm the page still renders — the `PROJECTS` array is parsed by the browser, so a stray comma or unescaped quote silently blanks the whole grid:

```bash
node --check <(sed -n '/const PROJECTS/,/^    \];/p' index.html)
```

If a new project page 404s at `paper.pnu-cvsp.com/<repo>/`, Pages is enabled but the build hasn't finished, or the source branch/folder is wrong — check the `branch:path` column from `org-state.sh` against where that repo's `index.html` actually sits.

### 6. Commit

Only when the user asks. This repo publishes on push to `master`, so a commit here is a live-site deploy. Keep the message in the existing style — imperative, naming the projects touched (`Add RestoreKV, MoDE and Motion-to-Attention to the project hub`).

## Enabling Pages on a project repo

When a repo should be on the hub but has no page yet, the project's own maintainer enables it: **Settings → Pages → Build from a branch**, pick the branch (`main`, `project_page`, …) and folder (`/` or `/docs`) that contains its `index.html`. Both layouts are already in use across the org. Until that's done, either wait or add the entry with `page: false`.
