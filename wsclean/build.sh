#!/bin/bash

set -eu

PACKAGE=wsclean
# VERSION=3.4
VERSION=master
REPO=https://gitlab.com/aroffringa/wsclean.git
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
git submodule update --init --recursive

# Build with a clean slate of modules.
ml purge
# source ../wsclean-3.3-idg-1.2.0-everybeam-0.4.0.env
# source ../wsclean-3.4-idg-1.2.0-everybeam-0.5.8.env
source ../wsclean-master-idg-master-everybeam-master.env

set -x

[ -r build ] && rm -rf build
mkdir -p build
cd build

[ -r "${PREFIX}/${VERSION}" ] && rm -rf "${PREFIX}/${VERSION}"

cmake .. -DCMAKE_INSTALL_PREFIX="${PREFIX}/${VERSION}"
make -j12 verbose=1
make install
