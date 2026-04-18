#!/bin/bash

set -e

# Get the source code
mkdir -p skylark_wd
pushd skylark_wd
wget https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.10.tar.bz2
tar -xf openmpi-5.0.10.tar.bz2

# Build
cd openmpi-5.0.10
mkdir build
cd build
../configure FCFLAGS="-m64 -fdefault-integer-8" CFLAGS=-m64 CXXFLAGS=-m64 --enable-mpi-fortran=usempi --prefix=/opt/skylark
make -j
make -j check

# Install
sudo make install

popd
rm -rf skylark_wd