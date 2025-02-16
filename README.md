<div align="center" style="margin-bottom: 3em;">
  <img alt="Solarus Launcher logo" src="branding/logo.svg" width="350px"/>
</div>

# Solarus Launcher (Legacy)

[![License](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://www.gnu.org/copyleft/gpl.html)
[![Qt version](https://img.shields.io/badge/Qt-6.8.1+-41CD52?logo=qt)](https://www.qt.io)

**Solarus Launcher (Legacy)** is a game launcher and browser for [Solarus](https://gitlab.com/solarus-games/solarus). It is written in C++/QtWidgets, and is kept for compatibility before being replaced by the new QtQuick launcher..

## Build Instructions

Be sure to have Qt and Solarus' dependencies installed.

```bash
brew install cmake ninja sdl2 sdl2_image sdl2_ttf luajit lua@5.1 libvorbis libmodplug physfs glm openal-soft qt@6
```

CMake presets are provided for ease of use.

```bash
cmake --preset macos
cmake --build --preset macos
```

## License

The source code is licensed under the terms of the [GNU General Public License v3](https://www.gnu.org/licenses/gpl-3.0.html) (GPL v3).

Images used in the editor are licensed under [Creative Commons Attribution-ShareAlike 4.0](http://creativecommons.org/licenses/by-sa/4.0/) (CC BY-SA 4.0).
