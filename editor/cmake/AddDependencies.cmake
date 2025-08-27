# Find dependencies.
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" "${CMAKE_SOURCE_DIR}/cmake/modules/")

# Wheither LuaJIT should be used instead of vanilla Lua.
option(SOLARUS_USE_LUAJIT "Use LuaJIT instead of default Lua (recommended)" ON)

find_package(Qt6Core "6.8" REQUIRED)
find_package(Qt6Widgets REQUIRED)
find_package(Qt6OpenGL REQUIRED)
find_package(Qt6OpenGLWidgets REQUIRED)
find_package(Qt6Svg REQUIRED)

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

# Control Qlementine acquisition method.
include(FetchContent)
option(SOLARUS_USE_LOCAL_QLEMENTINE "Use a local build of Qlementine (highest priority)" OFF)
option(SOLARUS_USE_SYSTEM_QLEMENTINE "Use system-installed Qlementine via pkgconfig" ON)

set(qlementine_FOUND FALSE)

# Priority 1: Local Qlementine build
if(SOLARUS_USE_LOCAL_QLEMENTINE)
  set(SOLARUS_QLEMENTINE_LOCAL_PATH "" CACHE PATH "Path to the local Qlementine source directory")
  # Check if the provided path is valid.
  if(NOT IS_DIRECTORY "${SOLARUS_QLEMENTINE_LOCAL_PATH}")
    message(FATAL_ERROR "SOLARUS_QLEMENTINE_LOCAL_PATH is set to '${SOLARUS_QLEMENTINE_LOCAL_PATH}' but it's not a valid directory. Please provide the correct path to your local Qlementine clone.")
  else()
    set(Qlementine_SOURCE_DIR ${SOLARUS_QLEMENTINE_LOCAL_PATH})
    message(STATUS "Using local Qlementine source from: ${SOLARUS_QLEMENTINE_LOCAL_PATH}")
    FetchContent_Declare(
      qlementine
      SOURCE_DIR "${SOLARUS_QLEMENTINE_LOCAL_PATH}"
      EXCLUDE_FROM_ALL
    )
    FetchContent_MakeAvailable(qlementine)
    set(qlementine_FOUND TRUE)
  endif()
endif()

# Priority 2: System-installed Qlementine
if(NOT qlementine_FOUND AND SOLARUS_USE_SYSTEM_QLEMENTINE)
  find_package(qlementine REQUIRED)
endif()

# Priority 3: Fetch from Git (fallback)
if(NOT qlementine_FOUND)
  message(STATUS "Using Qlementine from Git repository (FetchContent)")
  FetchContent_Declare(
    qlementine
    GIT_REPOSITORY https://github.com/oclero/qlementine.git
    GIT_TAG        v1.4.0
    EXCLUDE_FROM_ALL
  )
  FetchContent_MakeAvailable(qlementine)
  set(qlementine_FOUND TRUE)
endif()
