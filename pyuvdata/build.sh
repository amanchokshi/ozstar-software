#!/bin/bash

set -eu

PACKAGE=pyuvdata
# VERSION=2.4.4
VERSION=3.0.0
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
# module load python-scientific/3.10.4-foss-2022a
module load gcc/12.3.0 python/3.11.3

# python -m venv --system-site-packages .
python -m venv .
source bin/activate

pip install -U pip
pip install ${PACKAGE}==${VERSION}

deactivate
