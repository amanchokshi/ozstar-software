#!/bin/bash

set -eu

PACKAGE=woden
VERSION=v2.0.0
REPO=https://github.com/JLBLine/WODEN.git
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

# Build with a clean slate of modules.
module purge
module load foss/2022a
module load cmake/3.24.3
module load hdf5/1.12.2
module load python-scientific/3.10.4-foss-2022a

module use /fred/oz048/achokshi/software/modulefiles
module load hyperbeam/v0.6.0.AC

set -x

# [ -r build ] && rm -rf build
# mkdir -p build
# cd build

[ -r ${PREFIX}/${VERSION} ] && rm -rf ${PREFIX}/${VERSION}
mkdir -p ${PREFIX}/${VERSION} && cd ${PREFIX}/${VERSION}

cmake ${PREFIX}/git-repo -DCUDA_ARCH=8.0
make -j12 verbose=1

# Install python stuff
python -m venv --system-site-packages .
source bin/activate

pip install -r ${PREFIX}/git-repo/requirements.txt
pip install ${PREFIX}/git-repo

deactivate
