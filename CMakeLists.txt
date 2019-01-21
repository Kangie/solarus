# CMake 2.8.11 or above is necessary for recent Qt5 cmake helper functions.
cmake_minimum_required(VERSION 2.8.11)

project(solarus-quest-editor)

include(cmake/AddConfigurationVars.cmake)
include(cmake/AddCompilationFlags.cmake)
include(cmake/AddDefines.cmake)
include(cmake/AddDependencies.cmake)
include(cmake/AddIncludeDirectories.cmake)
include(cmake/AddSourceFiles.cmake)

# Add an icon for the executable in Windows.
if(WIN32)
  set(solarus_quest_editor_SOURCES
    ${solarus_quest_editor_SOURCES}
    cmake/win32/resources.rc
  )
endif()

include(cmake/AddQt5Files.cmake)
include(cmake/AddEditorExecutable.cmake)
include(cmake/AddInstallTarget.cmake)

# Platform specific.

# Windows: disable the console.
if(WIN32)
  if(MSVC)
    set_target_properties(solarus-quest-editor PROPERTIES LINK_FLAGS_RELEASE "/SUBSYSTEM:WINDOWS")
  elseif(CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_CXX_FLAGS "-mwindows ${CMAKE_CXX_FLAGS}")
  endif()
endif()

# Configuration for OSX build and deployment.
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  include(cmake/apple/OSXBuild.cmake)
endif()

# FreeDesktop compatible icons
if(UNIX AND NOT APPLE)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icon/sqe-icon-png-16px.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/16x16/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icon/sqe-icon-png-32px.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/32x32/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icon/sqe-icon-png-48px.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/48x48/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icon/sqe-icon-png-64px.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/64x64/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icon/sqe-icon-png-96px.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/96x96/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icon/sqe-icon-png-128px.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/128x128/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icon/sqe-icon-png-256px.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/256x256/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icon/sqe-icon-png-512px.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/512x512/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icon/sqe-icon-png-768px.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/768x768/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icon/sqe-icon-png-1024px.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor/1024x1024/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/logo/sqe-logo.png
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/pixmaps RENAME solarus-quest-editor.png)
endif(UNIX AND NOT APPLE)

# FreeDesktop compatible start menu launcher
if(UNIX AND NOT APPLE)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/solarus-quest-editor.desktop
    DESTINATION ${CMAKE_INSTALL_PREFIX}/share/applications)
endif(UNIX AND NOT APPLE)
