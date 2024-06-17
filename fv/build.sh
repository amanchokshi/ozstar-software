#!/bin/bash

set -eu

PACKAGE=fv
VERSION=5.5.2
SOURCE=https://heasarc.gsfc.nasa.gov/FTP/software/lheasoft/fv/fv${VERSION}_Linux.tar.gz
ROOT=/fred/oz048/achokshi/software

PREFIX="${ROOT}/${PACKAGE}"
echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Extract source
wget ${SOURCE}
tar -xvf fv${VERSION}_Linux.tar.gz
