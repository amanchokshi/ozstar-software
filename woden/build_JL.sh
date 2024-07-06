#!/bin/bash

set -eu

PACKAGE=woden
VERSION=v2.1.0
REPO=https://github.com/JLBLine/WODEN.git
ROOT=/fred/oz048/achokshi/software

PREFIX="${ROOT}/${PACKAGE}"
echo "Package: ${PACKAGE}"
echo "Version: ${VERSION}"
echo "Prefix:  ${PREFIX}"

# Build with a clean slate of modules.
module purge
module load cuda/12.0.0
module load gcc/12.3.0
module load rust/1.70.0
module load cmake/3.26.3
module load python/3.11.3

set -x

mkdir -p ${PREFIX}/${VERSION}.JL && cd ${PREFIX}/${VERSION}.JL

##Do HYPERBEAM------------------------------------------------------------------
git clone --branch v0.9.2 https://github.com/MWATelescope/mwa_hyperbeam.git hyperbeam-0.9.2 && cd hyperbeam-0.9.2
cargo build --locked --release --features=cuda,hdf5-static
cd ..


##Do WODEN----------------------------------------------------------------------
git clone https://github.com/JLBLine/WODEN.git woden-0.2.1 && cd woden-0.2.1
git checkout v2.1.0

# ##cd in and cmake to compile the HIP version
mkdir build && cd build
cmake .. -DUSE_CUDA=ON \
    -DHBEAM_INC=${PREFIX}/${VERSION}.JL/hyperbeam-0.9.2/include \
    -DHBEAM_LIB=${PREFIX}/${VERSION}.JL/hyperbeam-0.9.2/target/release/libmwa_hyperbeam.so
make

cd ..

# Install python stuff
mkdir python && cd python
python -m venv --system-site-packages woden-env
source woden-env/bin/activate

pip install -U pip
pip install numpy==1.26.0
pip install -r ../requirements.txt
pip install ..

deactivate
