cmake_minimum_required(VERSION 3.19.0)

project("solaruslauncher"
  LANGUAGES CXX
  VERSION 2.0.0
  HOMEPAGE_URL "https://www.solarus-games.org"
  DESCRIPTION "Game Launcher for Solarus Quests"
)

if(NOT PROJECT_VERSION_TWEAK)
  set(PROJECT_VERSION_TWEAK 0)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/addGeneralConfig.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/addDefinitions.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/addDependencies.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/addTarget.cmake)

# Configure build for each platform.
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/macOS/macOSConfig.cmake)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows" AND NOT MINGW)
  include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/windows/windowsConfig.cmake)
elseif(UNIX AND NOT APPLE OR MINGW)
  include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/linux/linuxConfig.cmake)
endif()

# Configure deployement for each platform.
set(ENABLE_QTDEPLOY OFF CACHE BOOL "Enable deployment using Qt deploy tool")
if(ENABLE_QTDEPLOY)
  if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/macOS/macOSDeploy.cmake)
  elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows" AND NOT MINGW)
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/windows/windowsDeploy.cmake)
  endif()
endif()

# Configure packaging for each platform.
set(ENABLE_CPACK OFF CACHE BOOL "Enable packaging with CPack")
if(ENABLE_CPACK)
  include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/addPackage.cmake)
  if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/macOS/macOSPackage.cmake)
  elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/windows/windowsPackage.cmake)
  endif()
  include(CPack)
endif()
