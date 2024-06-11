#!/bin/bash

set -eu

PACKAGE=pyuvdata
VERSION=2.4.4
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
module load python-scientific/3.10.4-foss-2022a

python -m venv --system-site-packages .
source bin/activate

pip install ${PACKAGE}==${VERSION}

deactivate
