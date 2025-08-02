# NCurses for reCamera RISC-V Cross-Compilation

This repository contains the ncurses library with cross-compilation support for the [Seeed Studio reCamera](https://wiki.seeedstudio.com/recamera_getting_started/) RISC-V platform.

## Overview

NCurses is a library that provides an API for creating text-based user interfaces in a terminal-independent manner. This fork includes cross-compilation scripts specifically configured for the reCamera's RISC-V SG2002 chipset.

## Prerequisites

- Linux development system (x86_64)
- Standard reCamera development environment setup
- RISC-V cross-compilation toolchain

For setting up the complete reCamera development environment, see the [reCamera Getting Started Guide](https://wiki.seeedstudio.com/recamera_getting_started/).

## Installation

This repository should be cloned into your `recamera` folder of a standard reCamera development environment setup:

### Quick Build

```bash
# Navigate to your recamera development folder
cd ~/recamera

# Clone this repository
git clone https://github.com/Toastee0/ncurses.git
cd ncurses

# Make the build script executable
chmod +x build-ncurses.sh

# Build ncurses for RISC-V
./build-ncurses.sh
```

### Build Configuration

The build script configures ncurses with the following options:
- **Target**: `riscv64-unknown-linux-musl`
- **Wide character support**: Enabled for UTF-8 compatibility
- **Shared and static libraries**: Both enabled
- **Installation prefix**: `/opt/ncurses-rv`
- **Fallback terminals**: linux, screen, vt100, xterm

### Toolchain Requirements

The build script expects the RISC-V toolchain at:
```
~/recamera/host-tools/gcc/riscv64-linux-musl-x86_64
```

This path is standard in a properly configured reCamera development environment. To use a different toolchain path, edit the `TOOLCHAIN_PATH` variable in `build-ncurses.sh`.

## Output

After successful compilation, ncurses will be installed to the sysroot with:
- Headers: `$SYSROOT/opt/ncurses-rv/include`
- Libraries: `$SYSROOT/opt/ncurses-rv/lib`
- Compatibility symlinks for standard library names

## Usage with Other Projects

This cross-compiled ncurses is compatible with other reCamera projects. For example, it's used by the [nano text editor for reCamera](https://github.com/Toastee0/nano).

## Integration with reCamera SDK

This ncurses build integrates with the reCamera OS SDK and can be used in projects built with the [SSCMA example framework](https://github.com/Seeed-Studio/sscma-example-sg200x).

## Related Projects

- [nano for reCamera](https://github.com/Toastee0/nano) - Cross-compiled nano text editor
- [SSCMA Examples](https://github.com/Seeed-Studio/sscma-example-sg200x) - Official reCamera examples
- [reCamera Documentation](https://wiki.seeedstudio.com/recamera_getting_started/)

## License

This project follows the original ncurses license terms. See the `COPYING` file for details.

## Contributing

Contributions are welcome! Please ensure any modifications maintain compatibility with the reCamera RISC-V platform.
