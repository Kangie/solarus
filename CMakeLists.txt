cmake_minimum_required(VERSION 3.10)

project(solarus-quest-editor VERSION 2.0.0)

include(cmake/AddOptions.cmake)
include(cmake/AddConfigurationVars.cmake)
include(cmake/AddCompilationFlags.cmake)
include(cmake/AddDefines.cmake)
include(cmake/AddDependencies.cmake)
include(cmake/AddIncludeDirectories.cmake)
include(cmake/AddVersionHeader.cmake)
include(cmake/AddSourceFiles.cmake)

# Add an icon for the executable in Windows.
if(MINGW)
  set(solarus_quest_editor_SOURCES
    ${solarus_quest_editor_SOURCES}
    cmake/win32/resources-mingw.rc
  )
elseif(WIN32)
  set(solarus_quest_editor_SOURCES
    ${solarus_quest_editor_SOURCES}
    cmake/win32/resources.rc
  )
elseif(APPLE)
  set(MACOSX_BUNDLE_ICON_FILE "solarus-quest-editor.icns")
  set(APP_ICON_MACOS "${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon/${MACOSX_BUNDLE_ICON_FILE}")
  set_source_files_properties(${APP_ICON_MACOS} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
  set(solarus_quest_editor_SOURCES
    ${solarus_quest_editor_SOURCES}
    ${APP_ICON_MACOS}
  )
endif()

include(cmake/AddQtFiles.cmake)
include(cmake/AddEditorExecutable.cmake)
include(cmake/AddInstallTargets.cmake)
include(cmake/AddUninstallTargets.cmake)

# Platform specific.

# Windows: disable the console.
if(WIN32)
  if(MSVC)
    set_target_properties(solarus-quest-editor PROPERTIES LINK_FLAGS_RELEASE "/SUBSYSTEM:WINDOWS")
  elseif(CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_CXX_FLAGS "-mwindows ${CMAKE_CXX_FLAGS}")
  endif()
endif()

# Configuration for macOS build and deployment.
if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  include(cmake/macOS/macOSBuild.cmake)
endif()

# FreeDesktop compatible icons
if(UNIX AND NOT APPLE)
  # Pixmap icons for sizes under 48x48 pixels
  foreach(SIZE IN ITEMS 16 20 24 32 40 48)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon/solarus-quest-editor-${SIZE}x${SIZE}.png
      DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/icons/hicolor/${SIZE}x${SIZE}/apps RENAME ${SOLARUSEDITOR_APP_ID}.png)
  endforeach(SIZE)
  
  # Pixmap icon for desktops that don't support multiple sizes
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon/solarus-quest-editor-512x512.png
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/pixmaps RENAME ${SOLARUSEDITOR_APP_ID}.png)

  # Vector icons, automatically chosen for sizes above 48x48 pixels
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon/solarus-quest-editor.svg
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/apps RENAME ${SOLARUSEDITOR_APP_ID}.svg)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon/solarus-quest-editor-symbolic.svg
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/icons/hicolor/symbolic/apps RENAME ${SOLARUSEDITOR_APP_ID}-symbolic.svg)
  
endif(UNIX AND NOT APPLE)

# FreeDesktop compatible start menu launcher
if(UNIX AND NOT APPLE)
  configure_file (resources/app.desktop.in resources/${SOLARUSEDITOR_APP_ID}.desktop @ONLY)
  install (FILES ${CMAKE_CURRENT_BINARY_DIR}/resources/${SOLARUSEDITOR_APP_ID}.desktop
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/applications)
endif(UNIX AND NOT APPLE)
