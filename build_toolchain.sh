#!/usr/bin/env bash
set -euo pipefail

############################

# CONFIG

############################

BINUTILS_URL="https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.xz"
GCC_URL="https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"

BUILD_DIR="$(pwd)/skylark-toolchain-build"
PREFIX="$BUILD_DIR/stage"
FINAL_PREFIX="/opt/skylark"

NPROC=$(nproc)

############################

# CLEAN ENVIRONMENT

############################

echo "[INFO] Setting clean build environment"

unset LD_LIBRARY_PATH || true
unset LIBRARY_PATH || true
unset CPATH || true
unset C_INCLUDE_PATH || true
unset CHOST || true
unset CBUILD || true
unset CTARGET || true

export PATH="/usr/bin:/bin"

############################

# DETECT BUILD TRIPLET

############################

echo "[INFO] Detecting build triplet"

if command -v gcc >/dev/null 2>&1; then
BUILD_TRIPLET=$(gcc -dumpmachine)
else
BUILD_TRIPLET="$(uname -m)-pc-linux-gnu"
fi

echo "[INFO] Build triplet: $BUILD_TRIPLET"

############################

# PREPARE DIRECTORIES

############################

echo "[INFO] Preparing directories"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/src"
mkdir -p "$BUILD_DIR/build-binutils"
mkdir -p "$BUILD_DIR/build-gcc"
mkdir -p "$PREFIX"

############################

# DOWNLOAD SOURCES

############################

cd "$BUILD_DIR/src"

echo "[INFO] Downloading sources"

wget -c "$BINUTILS_URL"
wget -c "$GCC_URL"

echo "[INFO] Extracting sources"

tar xf binutils-2.46.0.tar.xz
tar xf gcc-15.2.0.tar.xz

############################

# BUILD BINUTILS

############################

echo "[INFO] Building Binutils"

cd "$BUILD_DIR/build-binutils"

../src/binutils-2.46.0/configure  \
--prefix="$PREFIX"  \
--build="$BUILD_TRIPLET"  \
--host="$BUILD_TRIPLET"  \
--target="$BUILD_TRIPLET"  \
--enable-gold  \
--enable-ld=default  \
--enable-plugins  \
--disable-werror  \
--disable-multilib

make -j"$NPROC"
make install

############################

# GCC PREREQUISITES

############################

echo "[INFO] Fetching GCC prerequisites"

cd "$BUILD_DIR/src/gcc-15.2.0"
./contrib/download_prerequisites

############################

# BUILD GCC

############################

echo "[INFO] Building GCC"

cd "$BUILD_DIR/build-gcc"

# Use newly built binutils

export PATH="$PREFIX/bin:$PATH"

../src/gcc-15.2.0/configure \
  --prefix="$PREFIX" \
  --build="$BUILD_TRIPLET" \
  --host="$BUILD_TRIPLET" \
  --target="$BUILD_TRIPLET" \
  --enable-languages=c,c++,fortran \
  --enable-lto \
  --enable-plugin \
  --enable-shared \
  --enable-threads=posix \
  --enable-libgomp \
  --enable-libquadmath \
  --enable-default-pie \
  --enable-host-pie \
  --disable-multilib \
  --with-system-zlib \
  --enable-checking=release \
  --disable-werror \
  --with-pkgversion="Skylark Toolchain GCC 15.2.0" \
  --with-bugurl="https://github.com/prajvalk/skylark"

make -j"$NPROC" bootstrap
make install

############################

# POST-BUILD: RPATH INJECTION

############################

echo "[INFO] Injecting RPATH into GCC specs"

GCC_BIN="$PREFIX/bin/gcc"
TARGET_TRIPLET="$("$GCC_BIN" -dumpmachine)"
GCC_VERSION="15.2.0"

SPECS_PATH="$PREFIX/lib/gcc/$TARGET_TRIPLET/$GCC_VERSION/specs"

"$GCC_BIN" -dumpspecs > specs.tmp

# Inject rpath into *link section safely

awk -v rpath="-rpath $FINAL_PREFIX/lib64" '
/^\*link:/ {
    print
    getline
    print " " rpath " " $0
    next
}
{ print }
' specs.tmp > specs.new

mkdir -p "$(dirname "$SPECS_PATH")"
mv specs.new "$SPECS_PATH"
rm -f specs.tmp

############################

# SANITY CHECKS

############################

echo "[INFO] Running sanity checks"

"$PREFIX/bin/gcc" --version
"$PREFIX/bin/gfortran" --version

echo 'int main(){return 0;}' > test.c
"$PREFIX/bin/gcc" test.c

echo 'program x; print *, "ok"; end' > test.f90
"$PREFIX/bin/gfortran" test.f90

rm a.out test.*

############################

# ATOMIC INSTALL

############################

echo "[INFO] Installing to $FINAL_PREFIX (requires sudo)"

sudo bash -c "
set -e

if [ -d "$FINAL_PREFIX" ]; then
mv "$FINAL_PREFIX" "${FINAL_PREFIX}-old-$(date +%s)"
fi

mv "$PREFIX" "$FINAL_PREFIX"
"

############################

# DONE

############################

echo "[SUCCESS] Skylark toolchain installed at $FINAL_PREFIX"
echo "[INFO] Add $FINAL_PREFIX/bin to PATH"

rm -rf $BUILD_DIR