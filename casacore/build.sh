#!/bin/bash

set -eu

PACKAGE=casacore
VERSION=3.5.0
# VERSION=master
REPO=https://github.com/casacore/casacore.git
DATA=ftp://ftp.astron.nl/outgoing/Measures/WSRT_Measures.ztar
ROOT=/fred/oz048/achokshi/software

PREFIX="${ROOT}/${PACKAGE}"
echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Get casa data
[ -r data ] && rm -rf data
mkdir data
cd data
wget $DATA
tar -xvf WSRT_Measures.ztar
cd ..

# Clone Repo
[ -r git-repo ] && rm -rf git-repo
git clone ${REPO} ${PREFIX}/git-repo
cd "${PREFIX}/git-repo"
git checkout v${VERSION}
git submodule update --init --recursive

# Build with a clean slate of modules.
ml purge 
# ml foss/2022a \
#         binutils/2.38 \
#         cmake/3.24.3 \
#         flex/2.6.4 \
#         bison/3.8.2 \
#         cfitsio/4.2.0 \
#         wcslib/7.11 \
#         hdf5/1.13.1 \
#         python/3.10.4 \
#         boost/1.79.0 \
#         scipy-bundle/2022.05 \
#         ncurses/6.3 \
#         gsl/2.7
source ../casacore-3.5.0-foss-2022a.env

set -x

[ -r build ] && rm -rf build
mkdir -p build
cd build

[ -r "${PREFIX}/${VERSION}" ] && rm -rf "${PREFIX}/${VERSION}"

cmake .. \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}/${VERSION}" \
    -DBUILD_PYTHON3=ON -DBUILD_PYTHON=OFF -Wno-dev -DDATA_DIR=${PREFIX}/data \
    -DUSE_OPENMP=ON -DUSE_HDF5=ON -DUSE_MPI=ON

make -j12 verbose=1
make install
