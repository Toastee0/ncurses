#!/bin/bash

# RISC-V cross-compilation environment
# This assumes the script is run from within the recamera development folder
RECAMERA_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export TOOLCHAIN_PATH="$RECAMERA_ROOT/host-tools/gcc/riscv64-linux-musl-x86_64"
export PREFIX="/opt/ncurses-rv"
export SYSROOT="$TOOLCHAIN_PATH/sysroot"

# Cross-compiler settings
export CC="$TOOLCHAIN_PATH/bin/riscv64-unknown-linux-musl-gcc"
export CXX="$TOOLCHAIN_PATH/bin/riscv64-unknown-linux-musl-g++"
export AR="$TOOLCHAIN_PATH/bin/riscv64-unknown-linux-musl-ar"
export RANLIB="$TOOLCHAIN_PATH/bin/riscv64-unknown-linux-musl-ranlib"
export STRIP="$TOOLCHAIN_PATH/bin/riscv64-unknown-linux-musl-strip"

# Additional flags
export CFLAGS="-O2 -pipe"
export CXXFLAGS="-O2 -pipe"
export LDFLAGS=""

# Verify we're in a proper reCamera development environment
if [ ! -d "$TOOLCHAIN_PATH" ]; then
    echo "Error: RISC-V toolchain not found at $TOOLCHAIN_PATH"
    echo "Please ensure this ncurses repository is cloned into your recamera development folder"
    echo "Expected structure: ~/recamera/ncurses and ~/recamera/host-tools/gcc/..."
    exit 1
fi

echo "Building ncurses for RISC-V..."
echo "Recamera root: $RECAMERA_ROOT"
echo "Using compiler: $CC"

# Clean previous build
make distclean 2>/dev/null || true

# Configure ncurses for cross-compilation
./configure \
    --host=riscv64-unknown-linux-musl \
    --target=riscv64-unknown-linux-musl \
    --build=x86_64-pc-linux-gnu \
    --prefix="$PREFIX" \
    --with-sysroot="$SYSROOT" \
    --enable-widec \
    --enable-shared \
    --enable-static \
    --without-debug \
    --without-ada \
    --without-manpages \
    --without-progs \
    --without-tests \
    --disable-stripping \
    --with-fallbacks=linux,screen,vt100,xterm

if [ $? -eq 0 ]; then
    echo "Configuration successful, building..."
    make -j$(nproc)
    
    if [ $? -eq 0 ]; then
        echo "Build successful, installing to sysroot..."
        # Install to sysroot for linking with other programs
        make DESTDIR="$SYSROOT" install
        
        if [ $? -eq 0 ]; then
            echo "ncurses cross-compilation completed successfully!"
            echo "Headers installed to: $SYSROOT$PREFIX/include"
            echo "Libraries installed to: $SYSROOT$PREFIX/lib"
            
            # Create symlinks for standard names
            cd "$SYSROOT$PREFIX/lib"
            if [ -f libncursesw.a ]; then
                ln -sf libncursesw.a libcurses.a
                ln -sf libncursesw.a libncurses.a
            fi
            if [ -f libncursesw.so ]; then
                ln -sf libncursesw.so libcurses.so
                ln -sf libncursesw.so libncurses.so
            fi
            
            # Create header symlinks
            cd "$SYSROOT$PREFIX/include"
            if [ -f ncursesw/curses.h ]; then
                ln -sf ncursesw/curses.h curses.h
                ln -sf ncursesw/ncurses.h ncurses.h
            fi
            
            echo "Symlinks created for compatibility"
        else
            echo "Installation failed!"
            exit 1
        fi
    else
        echo "Build failed!"
        exit 1
    fi
else
    echo "Configuration failed!"
    exit 1
fi
