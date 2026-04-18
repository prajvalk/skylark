#!/usr/bin/env bash

set -e  # Exit on error

# Variables
VERSION="0.3.32"
ARCHIVE="v${VERSION}.tar.gz"
URL="https://github.com/OpenMathLib/OpenBLAS/archive/refs/tags/${ARCHIVE}"
DIR="OpenBLAS-${VERSION}"

# Download
echo "Downloading OpenBLAS ${VERSION}..."
wget -O ${ARCHIVE} ${URL}

# Extract
echo "Extracting..."
tar -xf ${ARCHIVE}

cd ${DIR}

# Build (use all available cores)
echo "Building OpenBLAS..."
make -j$(nproc) INTERFACE64=1 BINARY=64

# Optional: run tests
# make test

# Install (default: /opt/OpenBLAS or /usr/local if not overridden)
echo "Installing OpenBLAS..."
sudo make PREFIX=/opt/skylark install INTERFACE64=1 BINARY=64

cd ..

rm -rf ${DIR}
rm ${ARCHIVE}

echo "Done!"