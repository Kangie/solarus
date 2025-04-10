# Contributing

## Build Instructions

### macOS

1. Install dependencies.

   ```sh
   brew install
     cmake \
     ninja \
     sdl2 \
     sdl2_image \
     sdl2_ttf \
     luajit \
     lua@5.1 \
     libvorbis \
     libmodplug \
     physfs \
     glm \
     openal-soft \
     qt@6
   ```

2. Configure and build the project. CMake presets are provided for ease of use.

   ```sh
   cmake --preset macos
   cmake --build --preset macos
   cpack --preset macos
   ```

   Alternatively, there is simply this one-liner to configure, build and package:

   ```sh
   cmake --workflow macos
   ```

   Available options when configuring with cmake:

   - `-DSOLARUS_FETCHCONTENT=<ON|OFF>`: Will clone Solarus' repo instead of trying to finding it in the system's installed libraries. Default is `ON`.
   - `-DSOLARUSLAUNCHER_DEPLOY_ENABLED=<ON|OFF>`: Enables deploying all the dependencies to the macOS bundle with `macdeployqt`. Default is `ON`.
   - `-DSOLARUSLAUNCHER_CODESIGN_ENABLED=<ON|OFF>`: Enables codesigning the macOS bundle with `codesign`. Default is `OFF`.
   - `-DSOLARUSLAUNCHER_CODESIGN_IDENTITY=<YOUR_ID>`: Organization's identifier to use with macOS's `codesign`. Default is Solarus Lab's id.
   - `-DSOLARUSLAUNCHER_NOTARIZE_ENABLED=<ON|OFF>`: Enables notarizing after codesigning the macOS bundle. Must be done on an approved machine by Solarus Labs and Apple. Default is `ON`.
   - `-DSOLARUSLAUNCHER_CPACK_PRETTY_DMG_ENABLED=<ON|OFF>`: Activates or skips the long AppleScript call when building the `.dmg`. Useful when debugging. Default is `ON`.

   Typically, to build a signed and notarized package for a release, this should be called:

   ```sh
   rm -rf build
   cmake --preset macos \
    -DSOLARUS_FETCHCONTENT=ON \
    -DSOLARUSLAUNCHER_DEPLOY_ENABLED=ON \
    -DSOLARUSLAUNCHER_CODESIGN_ENABLED=ON \
    -DSOLARUSLAUNCHER_NOTARIZE_ENABLED=ON \
    -DSOLARUSLAUNCHER_CPACK_PRETTY_DMG_ENABLED=ON
   cmake --build --preset macos
   cpack --preset macos
   ```

   Note that notarizing may take some time (from 5 minutes to a few hours) as it sends the package to Apple for validation.

### Windows (MSYS2)

On Windows, we use MSYS2, a Unix-like environment that makes installing dependencies and compiling much simpler.

1. Install dependencies.

   ```sh
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
       mingw-w64-ucrt-x86_64-SDL2_ttf \
       mingw-w64-ucrt-x86_64-qt6-base \
       mingw-w64-ucrt-x86_64-qt6-tools
   ```

2. Configure and build the project. CMake presets are provided for ease of use.

   ```sh
   cmake --preset msys2
   cmake --build --preset msys2
   cpack --preset msys2
   ```

   Alternatively, there is simply this one-liner to configure, build and package:

   ```sh
   cmake --workflow msys2
   ```

### Debian (Ubuntu, etc.)

1. Install dependencies.

   ```sh
   apt update
   apt install --no-install-recommends \
       build-essential \
       cmake \
       pkgconf \
       libsdl2-dev \
       libsdl2-image-dev \
       libsdl2-ttf-dev \
       libglm-dev \
       libluajit-5.1-dev \
       libphysfs-dev \
       libopenal-dev \
       libvorbis-dev \
       libmodplug-dev \
       qt6-base-dev \
       qt6-base-dev-tools \
       qt6-tools-dev
   ```

2. Configure and build the project. CMake presets are provided for ease of use.

   ```sh
   cmake --preset linux
   cmake --build --preset linux
   ```

## Internationalization

1. If needed, add the language to `CMakeLists.txt`. Please use its standard code.

   ```cmake
   qt_standard_project_setup(
     I18N_TRANSLATED_LANGUAGES en_US fr_FR # <-- Here.
     I18N_SOURCE_LANGUAGE en_US
   )
   ```

2. Configure the project with CMake.

   ```sh
   cmake --preset macos
   ```

3. Update the `.ts` files by building the target that will internally call `lupdate`:

   ```sh
   cmake --build --preset macos-i18n
   ```

4. Open the `.ts` file(s) with **Qt Linguist** and fill the blanks for all the strings. Don't forget to save the file.
