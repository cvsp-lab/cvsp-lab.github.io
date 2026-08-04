# CVSP Lab · Project Pages

Hub page for the Computer Vision & Signal Processing Lab @ PNU project pages, served at **[paper.pnu-cvsp.com](https://paper.pnu-cvsp.com)**.

The landing page (`index.html`) is a static, curated list. Each project lives in its **own repository** with GitHub Pages enabled, and — because this org-pages site has the custom domain `paper.pnu-cvsp.com` — is served under `paper.pnu-cvsp.com/<repo>/`.

## Page Lists
| Page | Title | Published @ | Repository |
|:----:|:------|:-----------:|:-----------|
| [RestoreKV](https://paper.pnu-cvsp.com/RestoreKV/) | Recovering Full-Cache Behavior under Aggressive Query-Agnostic KV Cache Eviction | `Preprint` | [cvsp-lab/RestoreKV](https://github.com/cvsp-lab/RestoreKV) |
| [3DZip](https://paper.pnu-cvsp.com/3DZip/) | Spatial-Aware Feature Diversity-Guided Token Compression for 3D Question Answering | `ECCV 2026` | [cvsp-lab/3DZip](https://github.com/cvsp-lab/3DZip) |
| [LivingWorld](https://paper.pnu-cvsp.com/LivingWorld/) | Interactive 4D World Generation with Environmental Dynamics | `ECCV 2026` | [cvsp-lab/LivingWorld](https://github.com/cvsp-lab/LivingWorld) |
| [SFPruner](https://paper.pnu-cvsp.com/SFPruner/) | Structured Redundancy Modeling for Efficient Visual Token Pruning in High-Resolution MLLMs | `ECCV 2026` | [cvsp-lab/SFPruner](https://github.com/cvsp-lab/SFPruner) |
| — (code only) | MoDE: On the Design of Mixture-of-Experts for Dynamic Gaussian Splatting | `TPAMI 2026` | [cvsp-lab/MoDE](https://github.com/cvsp-lab/MoDE) |
| [MoE-GS](https://paper.pnu-cvsp.com/MoE-GS/) | Mixture of Experts for Dynamic Gaussian Splatting | `ICLR 2026` | [cvsp-lab/MoE-GS](https://github.com/cvsp-lab/MoE-GS) |
| [AgilePruner](https://paper.pnu-cvsp.com/AgilePruner/) | An Empirical Study of Attention and Diversity for Adaptive Visual Token Pruning in LVLMs | `ICLR 2026` | [cvsp-lab/AgilePruner](https://github.com/cvsp-lab/AgilePruner) |
| [FocusMatters](https://paper.pnu-cvsp.com/FocusMatters/) | Phase-Aware Suppression for Hallucination in Vision-Language Models | `Preprint` | [cvsp-lab/FocusMatters](https://github.com/cvsp-lab/FocusMatters) |
| [3D-MOM](https://paper.pnu-cvsp.com/ICLR2025_3D-MOM/) | Optimizing 4D Gaussians for Dynamic Scene Video from Single Landscape Images | `ICLR 2025` | [cvsp-lab/ICLR2025_3D-MOM](https://github.com/cvsp-lab/ICLR2025_3D-MOM) |
| [Motion-to-Attention](https://currycurry915.github.io/Motion-to-Attention/) | Enhancing Attention Maps to Improve Performance of Text-Guided Video Editing | `ACM TOMM` | [cvsp-lab/ACMTOMM_M2A](https://github.com/cvsp-lab/ACMTOMM_M2A) |
| [Stable-cGAN](https://paper.pnu-cvsp.com/Stable-cGAN/) | Enhancing Stability in Training Conditional GANs via Selective Data Matching | `Preprint` | [cvsp-lab/Stable-cGAN](https://github.com/cvsp-lab/Stable-cGAN) |
| [3D-MRM](https://paper.pnu-cvsp.com/3D_MRM_page/) | 3D-MRM | `Under Review` | [cvsp-lab/3D_MRM_page](https://github.com/cvsp-lab/3D_MRM_page) |

To add a project to the hub, add an entry to the `PROJECTS` array in [`index.html`](./index.html) after enabling Pages on its repository.

## Quick Guide for adding a project page
Each project page lives in its **own repository** under the `cvsp-lab` org.

1. Create/push your project-page repo (e.g. `cvsp-lab/MyProject`), with `index.html` at the root of the source branch.

2. Enable GitHub Pages on that repo: **Settings → Pages → Build from a branch**, pick your source branch (e.g. `main` or `project_page`) and folder (`/` or `/docs`). It will be served at `https://paper.pnu-cvsp.com/MyProject/`.

3. Add it to the hub: append an entry to the `PROJECTS` array in [`index.html`](./index.html) (and, optionally, a row to the table above):
```js
{ repo: "MyProject", venue: "CVPR 2026", title: "My Beautiful Project Title" },
```
`url` defaults to `https://paper.pnu-cvsp.com/<repo>/`; set it explicitly only if the page lives elsewhere (e.g. a personal GitHub Pages site).

For a repository that has **no** project page, add `page: false` — the card then shows only the *Code* link instead of a dead *Project Page* link:
```js
{ repo: "MyProject", venue: "TPAMI 2026", title: "My Beautiful Project Title", page: false },
```
