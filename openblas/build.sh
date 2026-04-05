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
make -j$(nproc)

# Optional: run tests
# make test

# Install (default: /opt/OpenBLAS or /usr/local if not overridden)
echo "Installing OpenBLAS..."
sudo make install

echo "Done!"