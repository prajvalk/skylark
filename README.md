# Project Skylark
A collection of install scripts I found useful that is otherwise undocumented about it's use. For eg. 64bit ILP OpenMPI

Notes:
Everything installs to /opt/skylark, some packages require other packages, read README.md of every package before using.

```build_toolchain.sh``` builds a tested GNU GCC 15.2.0 + Binutils 2.46.0 toolchain into /opt/skylark, source ```env.sh``` before building and installing any other package. On the other hand if you want to use Intel/AMD toolchains you can modify this script.

## Testing Notice

Last tested on ArchLinux (CachyOS) on April 18, 2026. 

## Licensing Notice 

I do not ship any of proprietary toolchain source code or binaries (Intel oneAPI, AMD AOCC, NVIDIA CUDA), however I do have scripts for them if you also happen to have the toolchains.