# Contributing

## Build Instructions

### macOS

Be sure to have Qt and Solarus' dependencies installed.

```bash
brew install cmake ninja sdl2 sdl2_image sdl2_ttf luajit lua@5.1 libvorbis libmodplug physfs glm openal-soft qt@6
```

CMake presets are provided for ease of use.

```bash
cmake --preset macos
cmake --build --preset macos
cpack --preset macos

# or simply (one-liner to configure, build and package):
cmake --workflow macos
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

   ```bash
   cmake --preset macos
   ```

3. Update the `.ts` files by building the target that will internally call `lupdate`:

   ```bash
   cmake --build --preset macos-i18n
   ```

4. Open the `.ts` file(s) with **Qt Linguist** and fill the blanks for all the strings. Don't forget to save the file.
