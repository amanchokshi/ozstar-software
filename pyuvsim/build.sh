#!/bin/bash

set -eu

PACKAGE=pyuvsim
VERSION=1.4.0
ROOT=/fred/oz048/achokshi/software

PREFIX="${ROOT}/${PACKAGE}"
echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Build Dir
cd ${PREFIX}
[ -r ${VERSION} ] && rm -rf ${VERSION}
mkdir -p ${VERSION} && cd ${VERSION}

module purge
module load python-scientific/3.11.3-foss-2023a

# python -m venv --system-site-packages .
python -m venv .
source bin/activate

pip install -U pip
pip install "${PACKAGE}[healpix]==${VERSION}"

deactivate
