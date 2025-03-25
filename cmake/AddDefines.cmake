# AppID to report to the window system on Linux/Wayland.
# From a user PoV this also determines were the corresponding XDG metadata is installed in the system.
# Also used as the macOS bundle identifier.
set(SOLARUSEDITOR_APP_ID "org.solarus-games.solarus-editor")
add_definitions(-DSOLARUSEDITOR_APP_ID=\"${SOLARUSEDITOR_APP_ID}\")

# Application display name.
set(SOLARUSEDITOR_APP_DISPLAY_NAME "Solarus Editor")
add_definitions(-DSOLARUSEDITOR_APP_DISPLAY_NAME=\"${SOLARUSEDITOR_APP_DISPLAY_NAME}\")

# Executable name.
set(SOLARUSEDITOR_EXECUTABLE_NAME "solarus-quest-editor")
add_definitions(-DSOLARUSEDITOR_EXECUTABLE_NAME=\"${SOLARUSEDITOR_EXECUTABLE_NAME}\")

# More metadata use on multiple platforms.
string(TIMESTAMP PROJECT_BUILD_YEAR "%Y")
set(SOLARUSEDITOR_ORGANISATION "Solarus Labs")
add_definitions(-DSOLARUSEDITOR_ORGANISATION=\"${SOLARUSEDITOR_ORGANISATION}\")

set(SOLARUSEDITOR_COPYRIGHT "© 2006-${PROJECT_BUILD_YEAR} ${SOLARUSEDITOR_ORGANISATION}.")
add_definitions(-DSOLARUSEDITOR_COPYRIGHT=\"${SOLARUSEDITOR_COPYRIGHT}\")

set(SOLARUSEDITOR_WEBSITE "https://www.solarus-games.org")
add_definitions(-DSOLARUSEDITOR_WEBSITE=\"${SOLARUSEDITOR_WEBSITE}\")

# Add defines for the install path and the build path to help guess the assets
# location at runtime.
add_definitions(-DSOLARUSEDITOR_SOURCE_PATH="${CMAKE_SOURCE_DIR}")
add_definitions(-DSOLARUSEDITOR_BINDIR_PATH="${CMAKE_INSTALL_PREFIX}/${SOLARUS_INSTALL_BINDIR}")
add_definitions(-DSOLARUSEDITOR_DATADIR_PATH="${CMAKE_INSTALL_PREFIX}/${SOLARUS_INSTALL_DATADIR}")

# Add define for the assets directory.
if(NOT SOLARUSEDITOR_ASSETS_DIR STREQUAL "")
  add_definitions(-DSOLARUSEDITOR_ASSETS_DIR="${SOLARUSEDITOR_ASSETS_DIR}")
endif()

# Add define for disabling GUI native dialogs.
if(SOLARUSEDITOR_NO_NATIVE_DIALOGS)
  add_definitions(-DSOLARUSEDITOR_NO_NATIVE_DIALOGS)
endif()

