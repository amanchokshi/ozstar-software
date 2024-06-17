#!/bin/bash

set -eu

PACKAGE=ds9
VERSION=v8.5
SOURCE=https://github.com/SAOImageDS9/SAOImageDS9/archive/refs/tags/${VERSION}.tar.gz
ROOT=/fred/oz048/achokshi/software

PREFIX="${ROOT}/${PACKAGE}"
echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Extract source
wget ${SOURCE}
[ -r SOURCE ] && rm -rf SOURCE
mkdir -p ${PREFIX}/SOURCE
tar -xvf ${VERSION}.tar.gz -C ${PREFIX}/SOURCE --strip-components=1
cd ${PREFIX}/SOURCE

# Build with a clean slate of modules.
module purge

set -x

./unix/configure --prefix=${PREFIX}/${VERSION} --exec-prefix=${PREFIX}/${VERSION}
make -j12 verbose=1

[ -r ${PREFIX}/${VERSION} ] && rm -rf ${PREFIX}/${VERSION}
mkdir -p ${PREFIX}/${VERSION} && cd ${PREFIX}/${VERSION}

cp -r ${PREFIX}/SOURCE/bin .
cp -r ${PREFIX}/SOURCE/lib .
cp -r ${PREFIX}/SOURCE/include .
cp -r ${PREFIX}/SOURCE/share .
