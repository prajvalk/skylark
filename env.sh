#!/usr/bin/env bash

# Skylark environment (auto-generated)

# This file defines the official Skylark toolchain

export SKYROOT=/opt/skylark

############################

# PATH (Skylark first)

############################

export PATH="$SKYROOT/bin:$PATH"

############################

# Compiler (ABSOLUTE PATHS)

############################

export CC="$SKYROOT/bin/gcc"
export CXX="$SKYROOT/bin/g++"
export FC="$SKYROOT/bin/gfortran"

############################

# Compiler flags (baseline)

############################

export CFLAGS="-O3 -march=native -fopenmp"
export CXXFLAGS="-O3 -march=native -fopenmp"
export FCFLAGS="-O3 -march=native -fopenmp"

############################

# Linker flags (critical)

############################

export LDFLAGS="-Wl,-rpath,$SKYROOT/lib64"

############################

# pkg-config (future-proof)

############################

export PKG_CONFIG_PATH="$SKYROOT/lib64/pkgconfig:$PKG_CONFIG_PATH"

############################

# CMake (important)

############################

export CMAKE_PREFIX_PATH="$SKYROOT:$CMAKE_PREFIX_PATH"

############################

# Python (future)

############################

#export PYTHONHOME="$SKYROOT/python" 2>/dev/null || true
#export PYTHONPATH="$SKYROOT/python/lib/python3.*/site-packages:$PYTHONPATH" 2>/dev/null || true

############################

# OpenMP behavior (optional)

############################

export OMP_NUM_THREADS=${OMP_NUM_THREADS:-$(nproc)}

############################

# Skylark marker

############################

export SKYMARK="skylark-gcc-15.2.0"
