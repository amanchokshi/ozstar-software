#!/bin/bash

set -eu

# Use our own custom ROOT.
ROOT=/fred/oz048/achokshi/software

PACKAGE=hyperdrive

cd "${ROOT}/${PACKAGE}/git-repo"
if ! git branch | grep "\\*" | grep "detached"; then
    VERSION=$(git branch | grep "\\*" | cut -d" " -f2-)
elif git describe --tags &> /dev/null; then
    VERSION=$(git describe --tags)
else
    VERSION=$(git branch | grep "\\*" | grep "detached" | rev | cut -d" " -f1 | rev | sed "s|)||")
fi

PREFIX="${ROOT}/${PACKAGE}"
echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Build with a clean slate of modules.
ml purge
ml gcc/12.3.0 cuda/12.0.0 rust/1.70.0 cmake/3.26.3
ml use /fred/oz048/achokshi/software/modulefiles
ml cfitsio/3.49

set -x

export HYPERDRIVE_CUDA_COMPUTE=80
export CARGO_HOME=${PREFIX}/${VERSION}

[ -r "${PREFIX}/${VERSION}" ] && rm -rf "${PREFIX}/${VERSION}"
mkdir -p "${PREFIX}/${VERSION}/bin"
cargo install --path . --locked --features=hdf5-static,cuda 