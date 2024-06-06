#!/bin/bash

set -eu

# Use our own custom ROOT.
ROOT=/fred/oz048/achokshi/software/

PACKAGE=libconfig
cd "${ROOT}/${PACKAGE}/git-repo"
if ! git branch | grep "\\*" | grep "detached"; then
    VERSION=$(git branch | grep "\\*" | cut -d" " -f2-)
elif git describe --tags &> /dev/null; then
    VERSION=$(git describe --tags)
else
    VERSION=$(git branch | grep "\\*" | grep "detached" | rev | cut -d" " -f1 | rev | sed "s|)||")
fi
# If you want to override the version, do it here.
#VERSION=chj

PREFIX="${ROOT}/${PACKAGE}"
echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Build with a clean slate of modules.
ml purge
ml gcc/12.2.0 openmpi/4.1.4 cmake/3.24.3 cfitsio/4.2.0 hdf5/1.14.0 cuda/12.0.0 automake/1.16.5

set -x

autoreconf
./configure --prefix="${PREFIX}"
[ -r build ] && rm -rf build
mkdir -p build
cd build

cmake .. \
        -DCMAKE_INSTALL_PREFIX="${PREFIX}/${VERSION}"
make -j12 verbose=1
[ -r "${PREFIX}/${VERSION}" ] && rm -rf "${PREFIX}/${VERSION}"
make install

# Provide the libraries in a "lib" directory (like the rest of the world...)
cd "${PREFIX}/${VERSION}"
ln -s lib64 lib
