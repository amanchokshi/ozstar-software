#!/bin/bash

# Rust needs to have been installed before running this script.

set -eu

PACKAGE=hyperbeam
ROOT=/fred/oz048/achokshi/software
cd ${ROOT}/${PACKAGE}/git-repo
if git describe --tags &> /dev/null; then
    VERSION=$(git describe --tags)
elif ! git branch | grep "\\*" | grep "detached"; then
    VERSION=$(git branch | grep "\\*" | cut -d" " -f2-)
else
    VERSION=$(git branch | grep "\\*" | grep "detached" | rev | cut -d" " -f1 | rev | sed "s|)||")
fi
# If you want to override the version, do it here.
# VERSION=v0.5.0

PREFIX="${ROOT}/${PACKAGE}"
echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Build with a clean slate of modules.
module purge
module load gcc/12.3.0
module load cuda/12.0.0
module load rust/1.70.0
module load cmake/3.26.3

set -x

# Interp MWA Beam
MWA_BEAM_FILE=/fred/oz048/achokshi/software/mwa_beams/MWA_embedded_element_pattern_rev2_interp_167_197MHz.h5

if [ ! -r MWA_embedded_element_pattern_rev2_interp_167_197MHz.h5 ]; then
    ln -s ${MWA_BEAM_FILE} .
fi

export HYPERDRIVE_CUDA_COMPUTE=80
export CARGO_HOME=${PREFIX}/${VERSION}

cargo build --release --features=cuda,hdf5-static

[ -r "${PREFIX}/${VERSION}" ] && rm -rf "${PREFIX}/${VERSION}"
mkdir -p "${PREFIX}/${VERSION}"/lib "${PREFIX}/${VERSION}"/include
cp include/mwa_hyperbeam.h "${PREFIX}/${VERSION}"/include/
cp target/release/libmwa_hyperbeam.so target/release/libmwa_hyperbeam.a "${PREFIX}/${VERSION}"/lib/
