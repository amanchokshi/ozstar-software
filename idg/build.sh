#!/bin/bash

set -eu

PACKAGE=idg
# VERSION=1.2.0
VERSION=master
REPO=https://git.astron.nl/RD/idg.git
ROOT=/fred/oz048/achokshi/software

PREFIX="${ROOT}/${PACKAGE}"
echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Clone Repo
[ -r git-repo ] && rm -rf git-repo
git clone ${REPO} ${PREFIX}/git-repo
cd "${PREFIX}/git-repo"
# git checkout ${VERSION}
git submodule update --init --recursive

# Build with a clean slate of modules.
ml purge
source ../idg.env

set -x

[ -r build ] && rm -rf build
mkdir -p build
cd build

cmake .. \
        -DCMAKE_INSTALL_PREFIX="${PREFIX}/${VERSION}" \
        -DBUILD_WITH_MPI=ON -DBUILD_WITH_PYTHON=ON -DBUILD_LIB_CUDA=ON -DBUILD_LIB_CPU=ON -DBUILD_WITH_DEMOS=ON

make -j12 verbose=1
[ -r "${PREFIX}/${VERSION}" ] && rm -rf "${PREFIX}/${VERSION}"
make install
