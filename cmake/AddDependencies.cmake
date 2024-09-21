# Find dependencies.
set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" "${CMAKE_SOURCE_DIR}/cmake/modules/")

# Wheither LuaJIT should be used instead of vanilla Lua.
option(SOLARUS_USE_LUAJIT "Use LuaJIT instead of default Lua (recommended)" ON)

find_package(Qt6Core "6.5" REQUIRED)
find_package(Qt6Widgets "6.5" REQUIRED)
find_package(Qt6LinguistTools "6.5" REQUIRED)
find_package(Qt6OpenGL "6.5" REQUIRED)
find_package(Qt6OpenGLWidgets "6.5" REQUIRED)
find_package(SDL2 "2.0.6" REQUIRED)
find_package(SDL2_image REQUIRED)
find_package(SDL2_ttf REQUIRED)
find_package(OpenAL REQUIRED)
find_package(VorbisFile REQUIRED)
find_package(Ogg REQUIRED)
find_package(ModPlug REQUIRED)
find_package(PhysFS REQUIRED)
if(SOLARUS_USE_LUAJIT)
  find_package(LuaJit REQUIRED)
else()
  find_package(Lua51 "5.1" EXACT REQUIRED)
endif()
find_package(Solarus "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}" EXACT REQUIRED)
find_package(SolarusGui REQUIRED)

# Explicit link to libdl is needed for Lua on some systems.
find_library(DL_LIBRARY dl)
if("${DL_LIBRARY}" MATCHES DL_LIBRARY-NOTFOUND)
  set(DL_LIBRARY "")
endif()

include(FetchContent)
FetchContent_Declare(
  qlementine
  GIT_REPOSITORY https://github.com/oclero/qlementine.git
  GIT_TAG        59860afd2de0079761e2ed15512791ca8d230dbe
)
FetchContent_MakeAvailable(qlementine)
