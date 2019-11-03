# - Find Solarus GUI
# Find the Solarus GUI includes and library.
#
#  SOLARUS_GUI_INCLUDE_DIRS   - where to find solarus GUI headers.
#  SOLARUS_GUI_LIBRARIES      - List of libraries when using libsolarus-gui.
#
# A custom installation path to search can be provided using
# the SOLARUS_GUI_DIR environment or CMake variables. If not found,
# the SOLARUS_DIR environment or CMake variables are used as fallback.

# Try to find the Solarus GUI include directory.
find_path(SOLARUS_GUI_INCLUDE_DIR
  NAMES
    solarus/gui/main_window.h
  HINTS
    ${SOLARUS_GUI_DIR}
    $ENV{SOLARUS_GUI_DIR}
    ${SOLARUS_DIR}
    $ENV{SOLARUS_DIR}
  PATHS
    /sw # Fink
    /opt/local # DarwinPorts
    /opt/csw # Blastwave
    /opt
  PATH_SUFFIXES
    include
)

# Try to find the Solarus GUI library.
find_library(SOLARUS_GUI_LIBRARY
  NAMES
    solarus-gui
  HINTS
    ${SOLARUS_GUI_DIR}
    $ENV{SOLARUS_GUI_DIR}
    ${SOLARUS_DIR}
    $ENV{SOLARUS_DIR}
  PATHS
    /sw # Fink
    /opt/local # DarwinPorts
    /opt/csw # Blastwave
    /opt
  PATH_SUFFIXES
    lib
    lib64
)

# Check if include and library directories were found.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SolarusGui
  REQUIRED_VARS
    SOLARUS_GUI_INCLUDE_DIR
    SOLARUS_GUI_LIBRARY
)
set(SOLARUS_GUI_INCLUDE_DIRS ${SOLARUS_GUI_INCLUDE_DIR})
set(SOLARUS_GUI_LIBRARIES ${SOLARUS_GUI_LIBRARY})
