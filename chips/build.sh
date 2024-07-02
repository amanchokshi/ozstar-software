#!/bin/bash

set -eu

PACKAGE=chips
ROOT=/fred/oz048/achokshi/software

cd "${ROOT}/${PACKAGE}/git-repo"
if ! git branch | grep "\\*" | grep "detached"; then
    VERSION=$(git branch | grep "\\*" | cut -d" " -f2-)
elif git describe --tags &> /dev/null; then
    VERSION=$(git describe --tags)
else
    VERSION=$(git branch | grep "\\*" | grep "detached" | rev | cut -d" " -f1 | rev | sed "s|)||")
fi
# VERSION=master

PREFIX=${ROOT}/${PACKAGE}
FIX=${PREFIX}/chips_fix

echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Clean up and reset git-repo
[ -r ${PREFIX}/${VERSION} ] && rm -rf ${PREFIX}/${VERSION}
cd ${PREFIX}/git-repo/src
git reset --hard HEAD && git clean -fd

# This contains extra shit that the CHIPS repo need to build, but doesn't come with. 
# primary_beam_dug.h
# Makefile.nt
# SLALIB_C
cp -r ${FIX}/* .

# Build with a clean slate of modules.
module purge
module load foss/2022a
module load lapack/3.10.1
module load cfitsio/4.2.0
module load python-scientific/3.10.4-foss-2022a

set -x

export CHIPS_DIR=${PREFIX}/git-repo

make -f Makefile.nt

# Make ${VERSION} "build" dir
[ -r ${PREFIX}/${VERSION} ] && rm -rf ${PREFIX}/${VERSION}
mkdir -p ${PREFIX}/${VERSION} && cd ${PREFIX}/${VERSION}
cp -r ${PREFIX}/git-repo/scripts .
cp -r ${PREFIX}/git-repo/src .
cp -r ${PREFIX}/git-repo/bin .

# Symlinking like Jack: /fred/oz048/jline/software/chips/bin
cd bin
ln -s grid_bn gridvisdiff
ln -s fft_thermal lssa_fg_thermal
cd -

# Install python stuff
mkdir python && cd python
python -m venv --system-site-packages chips-env
source chips-env/bin/activate

git clone https://github.com/JLBLine/CHIPS_wrappers.git

cd CHIPS_wrappers
pip install .
cd -

deactivate

set +x
