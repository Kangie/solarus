# This file adds the necessary dependencies of the Solarus GUI library.

find_package(Qt6Core "6.8" REQUIRED)
find_package(Qt6Widgets "6.8" REQUIRED)

# Find Qt6LinguistTools within the host path when set.
# This is required for cross compilation with Qt6 as the module is
# absent in the target install tree.
find_package(Qt6LinguistTools "6.8" QUIET)
if (NOT Qt6LinguistTools_FOUND AND QT_HOST_PATH)
  find_package(Qt6LinguistTools "6.8"
               PATHS "${QT_HOST_PATH}" "${QT_HOST_PATH}/lib/cmake"
               NO_CMAKE_FIND_ROOT_PATH NO_DEFAULT_PATH QUIET)
endif()
if (NOT Qt6LinguistTools_FOUND)
  message(FATAL_ERROR "CMake module Qt6LinguistTools could not be found.")
endif()
