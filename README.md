# Integrated Repository for Project Pages
## Page Lists
|Page                                            | Title                                                                        | Published @ |  source                      |
|:----------------------------------------------:|:-----------------------------------------------------------------------------|-------------|------------------------------|
|[3DMOM](https://cvsp-lab.github.io/ICLR_3D_MOM/)| Optimizing 4D Gaussians for Dynamic Scene Video from Single Landscape Images | `ICLR2025`  |  [directory](./ICLR_3D_MOM)  |

## Quick Guide for page uploads
1. run below commands to make your working branch
```bash
MY_PROJECT_NAME="example-project-name"
git clone https://github.com/cvsp-lab/cvsp-lab.github.io.git
git checkout -b $MY_PROJECT_NAME
```
2. build your project page at working directory
```bash
mkdir "my-project-name"
cd "my-project-name"
```

3. push to `master` to deploy your project page
```bash
git add .
git commit -m "Completed My Beautiful Project Page"
git push origin $MY_PROJECT_NAME
```
