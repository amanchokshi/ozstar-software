#!/bin/bash

set -eu

# Use our own custom ROOT.
ROOT=/fred/oz048/achokshi/software

PACKAGE=cuffs
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
ml gcc/12.2.0 openmpi/4.1.4 cfitsio/4.2.0 hdf5/1.14.0 cuda/12.0.0

# Other build modules.
ml use /fred/oz048/achokshi/software/modulefiles
ml libconfig/master

set -x

CFITSIO_ROOT=/apps/modules/software/CFITSIO/4.2.0-GCCcore-11.3.0
CUDA_HOME=/apps/modules/software/CUDA/12.0.0
HDF5_DIR=/apps/modules/software/HDF5/1.14.0-gompi-2022b

# Alter the hard-coded paths from cuFFS's build script. (Astronomers + coding, a
# match made in heaven.)
sed -e "s|^\(LIB_CONFIG_PATH\)=.*|\1=${LIBCONFIG_INCLUDE_DIR}/..|" \
    -e "s|^\(CFITSIO_PATH\)=.*|\1=${CFITSIO_ROOT}|" \
    -e "s|^\(CUDA_PATH\)=.*|\1=${CUDA_HOME}|" \
    -e "s|^\(HDF5_PATH\)=.*|\1=${HDF5_DIR}|" \
    -e "s|^\(NVCC_FLAGS=arch\)=.*|\1=compute_80,code=sm_80|" \
    -i build.sh

# The build script can optionally use the GCC_FLAGS variable. Allow undefined
# variables for it.
set +u
source ./build.sh
set -u

# Remove the old prefix directory, as we're about to replace it.
[ -r "${PREFIX}/${VERSION}" ] && rm -r "${PREFIX}/${VERSION}"

# Copy the binaries to the right spot.
mkdir -p "${PREFIX}/${VERSION}"/bin
cp fitsrot makecube rmsynthesis "${PREFIX}/${VERSION}"/bin
