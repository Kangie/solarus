# Find dependencies.
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" "${CMAKE_SOURCE_DIR}/cmake/modules/")

# Wheither LuaJIT should be used instead of vanilla Lua.
option(SOLARUS_USE_LUAJIT "Use LuaJIT instead of default Lua (recommended)" ON)

find_package(Qt6Core REQUIRED)
if(Qt6Core_VERSION VERSION_LESS "6.8")
  message(WARNING "Solarus recommends using Qt version 6.8 or newer. Graphical issues or "
                  "memory leaks might be encountered with older Qt versions.")
endif()
find_package(Qt6Widgets REQUIRED)
find_package(Qt6OpenGL REQUIRED)
find_package(Qt6OpenGLWidgets REQUIRED)

# Find Qt6LinguistTools within the host path when set.
# This is required for cross compilation with Qt6 as the module is
# absent in the target install tree.
find_package(Qt6LinguistTools QUIET)
if(NOT Qt6LinguistTools_FOUND AND QT_HOST_PATH)
  find_package(Qt6LinguistTools
               PATHS "${QT_HOST_PATH}" "${QT_HOST_PATH}/lib/cmake"
               NO_CMAKE_FIND_ROOT_PATH NO_DEFAULT_PATH QUIET)
endif()
if(NOT Qt6LinguistTools_FOUND)
  message(FATAL_ERROR "CMake module Qt6LinguistTools could not be found.")
endif()

find_package(SDL2 "2.0.18" REQUIRED)
find_package(SDL2_image REQUIRED)
find_package(SDL2_ttf REQUIRED)
find_package(OpenAL REQUIRED)
find_package(VorbisFile REQUIRED)
find_package(Ogg REQUIRED)
find_package(ModPlug REQUIRED)
find_package(PhysFS REQUIRED)
find_package(OpenAL REQUIRED)
if(SOLARUS_USE_LUAJIT)
  find_package(LuaJit REQUIRED)
else()
  find_package(Lua51 "5.1" EXACT REQUIRED)
endif()
find_package(Solarus "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}" EXACT REQUIRED)

# Explicit link to libdl is needed for Lua on some systems.
find_library(DL_LIBRARY dl)
if("${DL_LIBRARY}" MATCHES DL_LIBRARY-NOTFOUND)
  set(DL_LIBRARY "")
endif()

include(FetchContent)
FetchContent_Declare(
  qlementine
  GIT_REPOSITORY https://github.com/oclero/qlementine.git
  GIT_TAG        1ee38de727b83eabed614429faf4a08d7288543b # dev (temporary until 1.2 release)
)
FetchContent_MakeAvailable(qlementine)
