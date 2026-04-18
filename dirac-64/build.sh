#!/bin/bash

set -e

# Download
wget https://zenodo.org/records/19610239/files/DIRAC-26.1-Source.tar.xz?download=1
mv 'DIRAC-26.1-Source.tar.xz?download=1' DIRAC.tar.xz

tar -xf DIRAC.tar.xz

cd DIRAC-26.1-Source/

# Build
./setup --mpi --int64 --prefix=/opt/skylark --cmake-options="-DBLAS_LIBRARIES=/opt/skylark/lib/libopenblas.so -DLAPACK_LIBRARIES=/opt/skylark/lib/libopenblas.so" --pelib=off
cd build
make -j
sudo make install
cd ..

# Clean
rm -rf DIRAC*