#!/bin/bash   

set -eu                                                                                                                        

ROOT=/fred/oz048/achokshi/software
PACKAGE=cfitsio          
VERSION=3.49

PREFIX="${ROOT}/${PACKAGE}"
cd "${PREFIX}"
[ ! -r "${PACKAGE}-${VERSION}".tar.gz ] && wget https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/"${PACKAGE}-${VERSION}".tar.gz
[ ! -r "${PACKAGE}-${VERSION}" ] && tar -xzf "${PACKAGE}-${VERSION}".tar.gz

echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Build with a clean slate of modules.
ml purge

set -x

cd "${PREFIX}/${PACKAGE}-${VERSION}"
CFLAGS="-O3 -march=native" ./configure --prefix="${PREFIX}/${VERSION}" --enable-reentrant --enable-ssse3 --enable-sse2
make clean
make -j
make install
