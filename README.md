# CVSP Lab · Project Pages

Hub page for the Computer Vision & Signal Processing Lab @ PNU project pages, served at **[paper.pnu-cvsp.com](https://paper.pnu-cvsp.com)**.

The landing page (`index.html`) renders a curated list held in **[`projects.json`](./projects.json)** — that file is the single place to edit. Most projects live in their **own repository** with GitHub Pages enabled and, because this org-pages site has the custom domain `paper.pnu-cvsp.com`, are served under `paper.pnu-cvsp.com/<repo>/`; a project page hosted elsewhere (a personal GitHub Pages site, for instance) can be listed just as well.

## Page Lists
| Page | Title | Published @ | Paper | Repository |
|:----:|:------|:-----------:|:-----:|:-----------|
| [RestoreKV](https://paper.pnu-cvsp.com/RestoreKV/) | Recovering Full-Cache Behavior under Aggressive Query-Agnostic KV Cache Eviction | `Preprint` | [arXiv](https://arxiv.org/abs/2608.01247) | [cvsp-lab/RestoreKV](https://github.com/cvsp-lab/RestoreKV) |
| [3DZip](https://paper.pnu-cvsp.com/3DZip/) | Spatial-Aware Feature Diversity-Guided Token Compression for 3D Question Answering | `ECCV 2026` | [arXiv](https://arxiv.org/abs/2608.01185) | [cvsp-lab/3DZip](https://github.com/cvsp-lab/3DZip) |
| [LivingWorld](https://paper.pnu-cvsp.com/LivingWorld/) | Interactive 4D World Generation with Environmental Dynamics | `ECCV 2026` | [arXiv](https://arxiv.org/abs/2604.01641) | [cvsp-lab/LivingWorld](https://github.com/cvsp-lab/LivingWorld) |
| [TRiGS](https://wwwjjn.github.io/TRiGS-project_page/) | Temporal Rigid-Body Motion for Scalable 4D Gaussian Splatting | `ECCV 2026` | [arXiv](https://arxiv.org/abs/2604.00538) | — (no public repo) |
| [SFPruner](https://paper.pnu-cvsp.com/SFPruner/) | Structured Redundancy Modeling for Efficient Visual Token Pruning in High-Resolution MLLMs | `ECCV 2026` | [arXiv](https://arxiv.org/abs/2607.23046) | [cvsp-lab/SFPruner](https://github.com/cvsp-lab/SFPruner) |
| [PADS-TAL](https://pads-tal.github.io/PADS-TAL.io/) | Padding-Annealed Diffusion Sampling in Text-Aware Latent Space for Text-to-Music Generation | `ICML 2026` | — | [PADS-TAL/PADS-TAL](https://github.com/PADS-TAL/PADS-TAL) |
| — (code only) | MoDE: On the Design of Mixture-of-Experts for Dynamic Gaussian Splatting | `TPAMI 2026` | [arXiv](https://arxiv.org/abs/2607.08250) | [cvsp-lab/MoE-GS-studio](https://github.com/cvsp-lab/MoE-GS-studio) |
| [MoE-GS](https://paper.pnu-cvsp.com/MoE-GS/) | Mixture of Experts for Dynamic Gaussian Splatting | `ICLR 2026` | [arXiv](https://arxiv.org/abs/2510.19210) | [cvsp-lab/MoE-GS](https://github.com/cvsp-lab/MoE-GS) |
| [AgilePruner](https://paper.pnu-cvsp.com/AgilePruner/) | An Empirical Study of Attention and Diversity for Adaptive Visual Token Pruning in LVLMs | `ICLR 2026` | [arXiv](https://arxiv.org/abs/2603.01236) | [cvsp-lab/AgilePruner](https://github.com/cvsp-lab/AgilePruner) |
| [FocusMatters](https://paper.pnu-cvsp.com/FocusMatters/) | Phase-Aware Suppression for Hallucination in Vision-Language Models | `Preprint` | [arXiv](https://arxiv.org/abs/2604.03556) | [cvsp-lab/FocusMatters](https://github.com/cvsp-lab/FocusMatters) |
| [3D-MOM](https://paper.pnu-cvsp.com/ICLR2025_3D-MOM/) | Optimizing 4D Gaussians for Dynamic Scene Video from Single Landscape Images | `ICLR 2025` | [arXiv](https://arxiv.org/abs/2504.05458) | [cvsp-lab/ICLR2025_3D-MOM](https://github.com/cvsp-lab/ICLR2025_3D-MOM) |
| [Motion-to-Attention](https://currycurry915.github.io/Motion-to-Attention/) | Enhancing Attention Maps to Improve Performance of Text-Guided Video Editing | `ACM TOMM` | [PDF](https://currycurry915.github.io/Motion-to-Attention/static/pdfs/IEEE_TCSVT_Attention.pdf) | [cvsp-lab/ACMTOMM_M2A](https://github.com/cvsp-lab/ACMTOMM_M2A) |
| [Stable-cGAN](https://paper.pnu-cvsp.com/Stable-cGAN/) | Enhancing Stability in Training Conditional GANs via Selective Data Matching | `Preprint` | [IEEE](https://ieeexplore.ieee.org/document/10623662) | [cvsp-lab/Stable-cGAN](https://github.com/cvsp-lab/Stable-cGAN) |

To add a project to the hub, append an entry to `projects` in [`projects.json`](./projects.json) (and, optionally, a row to the table above). No build step — the page fetches the file at load time.

## `projects.json` field reference

```json
{
  "site": { "pageBase": "https://paper.pnu-cvsp.com", "org": "https://github.com/cvsp-lab" },
  "projects": [
    { "id": "MyProject", "venue": "CVPR 2026", "title": "My Beautiful Project Title" }
  ]
}
```

Cards render in file order (most recent first), each showing up to three links in the order **Paper → Project Page → Code**. Per entry:

| Field | Required | Meaning |
|:--|:--:|:--|
| `id` | ✅ | Slug shown on the card, and the default for the page/code links below. Usually the repo name. |
| `venue` | ✅ | Badge text (`ECCV 2026`, `Preprint`, `Under Review`, …). |
| `title` | ✅ | Card headline. |
| `paper` | | arXiv / IEEE / ACM / PDF URL. Omit → no *Paper* link. There is no default. |
| `url` | | Project page. Omit → `<pageBase>/<id>/`. A string points anywhere (e.g. a personal Pages site). `false` → no *Project Page* link. |
| `repo` | | Code. Omit → `<org>/<id>`. `"owner/name"` points at a repo outside the org. `false` → no *Code* link. |
| `muted` | | `true` greys out the badge — used for unpublished / under-review work. |

`site.pageBase` and `site.org` are optional; drop them to fall back to the values above.

Examples:

```jsonc
// Code only — repo has no project page, and the code lives in another repo
{ "id": "MoDE", "venue": "TPAMI 2026", "title": "…",
  "paper": "https://arxiv.org/abs/2607.08250", "url": false, "repo": "MoE-GS-studio" }

// Project page hosted on a personal account, no public code
{ "id": "TRiGS", "venue": "ECCV 2026", "title": "…",
  "paper": "https://arxiv.org/abs/2604.00538",
  "url": "https://wwwjjn.github.io/TRiGS-project_page/", "repo": false }

// Both links outside the cvsp-lab org, paper not yet public
{ "id": "PADS-TAL", "venue": "ICML 2026", "title": "…",
  "url": "https://pads-tal.github.io/PADS-TAL.io/", "repo": "PADS-TAL/PADS-TAL" }
```

## Quick Guide for adding a project page
Each project page lives in its **own repository** under the `cvsp-lab` org.

1. Create/push your project-page repo (e.g. `cvsp-lab/MyProject`), with `index.html` at the root of the source branch.

2. Enable GitHub Pages on that repo: **Settings → Pages → Build from a branch**, pick your source branch (e.g. `main` or `project_page`) and folder (`/` or `/docs`). It will be served at `https://paper.pnu-cvsp.com/MyProject/`.

3. Add it to the hub: append an entry to `projects` in [`projects.json`](./projects.json) (and, optionally, a row to the table above):
```json
{ "id": "MyProject", "venue": "CVPR 2026", "title": "My Beautiful Project Title" }
```
See the field reference above for pages hosted outside the org, code-only repos, and repos under another owner.
