cmake_minimum_required(VERSION 3.1)

project(solarus-quest-editor VERSION 1.6.2)

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
endif()

include(cmake/AddQt5Files.cmake)
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
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app-icon/solarus-quest-editor-16x16.png
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/icons/hicolor/16x16/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app-icon/solarus-quest-editor-20x20.png
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/icons/hicolor/20x20/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app-icon/solarus-quest-editor-24x24.png
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/icons/hicolor/24x24/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app-icon/solarus-quest-editor-32x32.png
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/icons/hicolor/32x32/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app-icon/solarus-quest-editor-40x40.png
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/icons/hicolor/40x40/apps RENAME solarus-quest-editor.png)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app-icon/solarus-quest-editor-48x48.png
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/icons/hicolor/48x48/apps RENAME solarus-quest-editor.png)
  
  # Pixmap icon for desktops that don't support multiple sizes
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app-icon/solarus-quest-editor-512x512.png
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/pixmaps RENAME solarus-quest-editor.png)

  # Vector icons, automatically chosen for sizes above 48x48 pixels
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app-icon/solarus-quest-editor.svg
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/apps)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app-icon/solarus-quest-editor-symbolic.svg
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/icons/hicolor/symbolic/apps)
  
endif(UNIX AND NOT APPLE)

# FreeDesktop compatible start menu launcher
if(UNIX AND NOT APPLE)
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/solarus-quest-editor.desktop
    DESTINATION ${SOLARUS_INSTALL_DATAROOTDIR}/applications)
endif(UNIX AND NOT APPLE)
