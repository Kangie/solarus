# Add defines for the install path and the build path to help guess the assets
# location at runtime.
add_definitions(-DSOLARUSEDITOR_SOURCE_PATH="${CMAKE_SOURCE_DIR}")
add_definitions(-DSOLARUSEDITOR_BINDIR_PATH="${CMAKE_INSTALL_PREFIX}/${SOLARUS_INSTALL_BINDIR}")
add_definitions(-DSOLARUSEDITOR_DATADIR_PATH="${CMAKE_INSTALL_PREFIX}/${SOLARUS_INSTALL_DATADIR}")

