# Add KHR as a header-only library.
add_library(khr INTERFACE)
target_include_directories(khr INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)
set_target_properties(khr PROPERTIES
  FOLDER "third_party"
  POSITION_INDEPENDENT_CODE ON
)
add_library(KHR::KHR ALIAS khr)
