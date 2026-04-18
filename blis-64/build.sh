#!/bin/bash

set -e

# Get the source code
mkdir -p skylark_wd
pushd skylark_wd
wget https://github.com/amd/blis/archive/refs/tags/5.2.2.tar.gz
tar -xf 5.2.2.tar.gz

cd blis-5.2.2
./configure -i 64 -b 64 --prefix=/opt/skylark zen
make -j

# Install
sudo make install

popd
rm -rf skylark_wd