# Solarus compilation using MSYS2

This document details how to build Solarus for Windows using the MSYS2 toolchain.

From <https://www.msys2.org/>:

> MSYS2 is a collection of tools and libraries providing you with an easy-to-use
> environment for building, installing and running native Windows software.
> It consists of a command line terminal called mintty, bash, version control systems
> like git and subversion, tools like tar and awk and even build systems like autotools,
> all based on a modified version of Cygwin. Despite some of these central parts being
> based on Cygwin, the main focus of MSYS2 is to provide a build environment for native
> Windows software and the Cygwin-using parts are kept at a minimum. MSYS2 provides
> up-to-date native builds for GCC, mingw-w64, CPython, CMake, Meson, OpenSSL,
> FFmpeg, Rust, Ruby, just to name a few.

## Installing MSYS2

Follow the official [Installation](https://www.msys2.org/#installation) documentation to
setup and prepare MSYS2. The MSYS2 installer will create a shortcut for each available
[environment](https://www.msys2.org/docs/environments/) in your Start Menu.

The recommended environment to use for building Solarus is **UCRT64**.

## Updating MSYS2

MSYS2 is a rolling release distribution and it is strongly advised to keep it up to date.
Follow the official [Updating](https://www.msys2.org/docs/updating/) documentation to
update your MSYS2 installation from time to time.

## Dependency packages

To build Solarus in MSYS2, the following dependency packages are required to be installed:
```
pacman --noconfirm --needed -S \
    git \
    mingw-w64-ucrt-x86_64-cmake \
    mingw-w64-ucrt-x86_64-gcc \
    mingw-w64-ucrt-x86_64-glm \
    mingw-w64-ucrt-x86_64-libmodplug \
    mingw-w64-ucrt-x86_64-libvorbis \
    mingw-w64-ucrt-x86_64-luajit \
    mingw-w64-ucrt-x86_64-ninja \
    mingw-w64-ucrt-x86_64-openal \
    mingw-w64-ucrt-x86_64-physfs \
    mingw-w64-ucrt-x86_64-pkgconf \
    mingw-w64-ucrt-x86_64-SDL2 \
    mingw-w64-ucrt-x86_64-SDL2_image \
    mingw-w64-ucrt-x86_64-SDL2_ttf
```

The following additional dependency packages are required to be installed if building the GUI:
```
pacman --noconfirm --needed -S \
    mingw-w64-ucrt-x86_64-qt5-base \
    mingw-w64-ucrt-x86_64-qt5-tools
```
> **Note:** The GUI components include the Solarus Launcher and the Solarus Quest Editor.

The following additional dependency packages are required for debugging Solarus builds:
```
pacman --noconfirm --needed -S \
    mingw-w64-ucrt-x86_64-gdb
```

## Building Solarus

Ensure that the [dependency packages](#dependency-packages) for Solarus are installed in
your MSYS2 installation.

Launch the **UCRT64** shell and clone the repository:
```
git clone https://gitlab.com/solarus-games/solarus.git
```

Go into the cloned repository and configure the build using CMake:
```
cd solarus
cmake -B build -G "Ninja"
```

The following common configuration options can be added to the CMake command above:

* `-DSOLARUS_GUI=OFF`: Disable building the GUI.
* `-DCMAKE_BUILD_TYPE=Debug`: Configure the build for debugging.

Start the configured build using CMake:
```
cmake --build build
```
> **Note:** The built binaries will be located in the `build` directory.

After the build is completed, optionally run the Solarus test suite:
```
ctest --test-dir build
```

## Running the build

After [building Solarus](#building-solarus), working binaries should be in the `build` directory.

You can invoke these binaries directly from the **UCRT64** shell to start a quest or
use the GUI launcher:
```
cd build
solarus-run.exe /path/to/quest
gui/solarus-launcher.exe
```

If you configured the build for debugging, you can use the standard
[GDB debugger](https://sourceware.org/gdb/download/onlinedocs/gdb.html/index.html):
```
cd build
gdb --args solarus-run.exe /path/to/quest
```
> **Tip:** To obtain a complete stack trace after a crash, type `bt full` in `gdb`.
