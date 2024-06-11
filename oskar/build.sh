#!/bin/bash

set -eu

PACKAGE=oskar
VERSION=2.9.5
REPO=https://github.com/OxfordSKA/OSKAR.git
ROOT=/fred/oz048/achokshi/software

PREFIX="${ROOT}/${PACKAGE}"
echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Clone Repo
[ -r git-repo ] && rm -rf git-repo
git clone ${REPO} ${PREFIX}/git-repo
cd "${PREFIX}/git-repo"
git checkout ${VERSION}
git submodule update --init --recursive

# Build with a clean slate of modules.
module purge
module load foss/2022a
module load cmake/3.24.3
module load cuda/12.0.0
module load qt5/5.15.5
module load hdf5/1.13.1
module load python-scientific/3.10.4-foss-2022a

module use /fred/oz048/achokshi/software/modulefiles
module load casacore/3.5.0.AC


set -x

[ -r build ] && rm -rf build
mkdir -p build
cd build

cmake .. \
        -DCMAKE_INSTALL_PREFIX="${PREFIX}/${VERSION}" -DCUDA_ARCH="8.0" \
        -DCASACORE_LIB_DIR=/fred/oz048/achokshi/software/casacore/3.5.0/lib \
        -DCMAKE_PREFIX_PATH=/apps/modules/software/Qt5/5.15.5-GCCcore-11.3.0 \
        -DCASACORE_INC_DIR=/fred/oz048/achokshi/software/casacore/3.5.0/include

make -j12 verbose=1
[ -r "${PREFIX}/${VERSION}" ] && rm -rf "${PREFIX}/${VERSION}"
make install

export OSKAR_INC_DIR=/fred/oz048/achokshi/software/oskar/2.9.5/include
export OSKAR_LIB_DIR=/fred/oz048/achokshi/software/oskar/2.9.5/lib

cd ${PREFIX}/${VERSION}

python -m venv --system-site-packages .
source bin/activate

pip install --user 'git+https://github.com/OxfordSKA/OSKAR.git@master#egg=oskarpy&subdirectory=python'

deactivate
