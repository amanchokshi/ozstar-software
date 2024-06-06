#!/bin/bash

set -eu

PACKAGE=astropy-healpix
VERSION=1.0.3
ROOT=/fred/oz048/achokshi/software

PREFIX="${ROOT}/${PACKAGE}"
echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

module purge
module load python-scientific/3.10.4-foss-2022a

python -m venv --system-site-packages .
source bin/activate

pip install ${PACKAGE}==${VERSION}

deactivate
