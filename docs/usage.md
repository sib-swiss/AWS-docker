# How to use the containers

In this chapter there is some general information for people (e.g. teachers/course participants) who are using the hosted containers after they have been started up. 

## General information

- During the course the containers are hosted on an AWS EC2 instance.
- Each student gets assigned one container of each available type (i.e. Rstudio, jupyter ..)
- Computational resources are limited per container. By default this is 16G RAM and 4 CPU. This can be increased if needed. The limits are hard, meaning that if they get exceeded (especially RAM), the container will crash and automatically restarted (everything in working memory will be lost). 
- Each container will get a unique port assigned, so a link to an individual container will look like `http://1.23.45.678:10034`. 
- In the container, you can find the following shared directories:
    - `/data`: read only, and shared between all running containers. This directory is used to have a single place to store data
    - `/group_work`: read and write enabled for all participants, and shared between all containers. This can be used to share data/scripts between students. This directory can be backed up. 
    - `~/project` or `~/workdir`: read and write enabled, and only shared between containers assigned to the same participant. This directory can be backed up and shared as a tarball at the end of the course. 
- All directories other than the shared directories only exist within the container. 

## Jupyter containers

- Interaction with the container is either via the terminal, jupyter notebook or python console. 
- Software of individual sessions (e.g. projects) will be in a conda environment. Check which environments are available with `conda env list`. You can use these environments in two ways:
    - Using the terminal, e.g. `conda activate env_name`
    - By switching the kernel of jupyter notebooks (e.g. by using **Kernel** > **Change Kernel..** )

## Rstudio containers

- All R packages will be installed in the system library. 
- Conda environments are installed with the `reticulate` conda installation. Check which environments are available with `conda env list` on the terminal.
- You can use the conda environments in two ways:
    - Using the terminal, e.g. `conda activate env_name`
    - In `R` (with `reticulate`): `reticulate::use_condaenv("env_name")`. 
