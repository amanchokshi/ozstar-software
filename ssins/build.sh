#!/bin/bash

set -eu

PACKAGE=ssins
VERSION=1.4.6
REPO=https://github.com/mwilensky768/SSINS.git
ROOT=/fred/oz048/achokshi/software

PREFIX="${ROOT}/${PACKAGE}"
echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Clone Repo
[ -r git-repo ] && rm -rf git-repo
git clone ${REPO} ${PREFIX}/git-repo
cd "${PREFIX}/git-repo"
git checkout ${VERSION}
git submodule update --init --recursive

# Build Dir
cd ${PREFIX}
[ -r ${VERSION} ] && rm -rf ${VERSION}
mkdir -p ${VERSION} && cd ${VERSION}

module purge
module load python-scientific/3.10.4-foss-2022a

python -m venv --system-site-packages .
source bin/activate

pip install ${PREFIX}/git-repo

deactivate
