#!/bin/bash

set -eu

PACKAGE=everybeam
# VERSION=0.5.8
VERSION="mwa_python_wrapper"
# VERSION=master
REPO=https://git.astron.nl/RD/EveryBeam.git
ROOT=/fred/oz048/achokshi/software

PREFIX="${ROOT}/${PACKAGE}"
echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Clone Repo
[ -r git-repo ] && rm -rf git-repo
git clone ${REPO} ${PREFIX}/git-repo
cd "${PREFIX}/git-repo"
# git checkout v${VERSION}
git checkout ${VERSION}
git submodule update --init --recursive

# Build with a clean slate of modules.
ml purge 
source ../everybeam.env

set -x

[ -r build ] && rm -rf build
mkdir -p build
cd build

[ -r "${PREFIX}/${VERSION}" ] && rm -rf "${PREFIX}/${VERSION}"

cmake -DCMAKE_INSTALL_PREFIX="${PREFIX}/${VERSION}" -DBUILD_WITH_PYTHON=ON ..
make -j12 verbose=1
make install
