# AppID to report to the window system on Linux/Wayland.
# From a user PoV this also determines were the corresponding XDG metadata is installed in the system.
set(SOLARUS_APP_ID "org.solarus_games.solarus" CACHE STRING "AppID base for installed XDG metadata on Linux/BSD.")
add_definitions(-DSOLARUS_APP_ID=\"${SOLARUS_APP_ID}\")

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

