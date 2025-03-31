####
# By default, you will build a binary with the maximum of compatibility that your current version can provide.
# You may want to produce an optimized (or exotic) binary instead of a standard one.
# To do so, overload the following options :
#
# SOLARUS_ARCH represent the build (multi-)architecture.
# SOLARUS_DEPLOYMENT represent the oldest macOS version supported.
#
# Some options set to the cache also need the FORCE parameter for obscure reasons.
#
# Exportable to XCode.
####

# Build architectures.
if(NOT SOLARUS_ARCH)
  set(SOLARUS_ARCH ${CMAKE_HOST_SYSTEM_PROCESSOR})
endif()
set(CMAKE_OSX_ARCHITECTURES "${SOLARUS_ARCH}" CACHE STRING "Build architecture" FORCE)

# Deployment version.
if(NOT SOLARUS_DEPLOYMENT)
  set(SOLARUS_DEPLOYMENT "13.6")
endif()
set(CMAKE_OSX_DEPLOYMENT_TARGET "${SOLARUS_DEPLOYMENT}" CACHE STRING "Oldest OS version supported" FORCE)

# LuaJIT workaround.
# According to LuaJIT doc, OSX needs to link with additional flags if 64bit build is requested
if(SOLARUS_USE_LUAJIT AND SOLARUS_ARCH MATCHES "x86_64")
  if(XCODE)
    set_property(TARGET solarus-quest-editor PROPERTY
      "XCODE_ATTRIBUTE_LINKER_FLAGS[arch=x86_64]" "-pagezero_size 10000 -image_base 100000000"
    )
  elseif(NOT CMAKE_EXE_LINKER_FLAGS MATCHES "-pagezero_size 10000 -image_base 100000000")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pagezero_size 10000 -image_base 100000000" CACHE STRING "LuaJIT woraround" FORCE)
  endif()
endif()

# Bundle icon.
set(MACOSX_BUNDLE_ICON_FILE "solarus-quest-editor.icns")
set(APP_ICON_MACOS "${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon/${MACOSX_BUNDLE_ICON_FILE}")
set_source_files_properties(${APP_ICON_MACOS} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
target_sources(solarus-quest-editor PRIVATE
  ${APP_ICON_MACOS}
)

# Plist.
set(MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_BINARY_DIR}/Info.plist")
configure_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/macOS/Info.plist.in"
  "${MACOSX_BUNDLE_INFO_PLIST}"
  @ONLY
)
target_sources(solarus-quest-editor PRIVATE
  ${MACOSX_BUNDLE_INFO_PLIST}
)
set_target_properties(solarus-quest-editor PROPERTIES
  MACOSX_BUNDLE_INFO_PLIST "${MACOSX_BUNDLE_INFO_PLIST}"
  MACOSX_BUNDLE_BUNDLE_NAME ${SOLARUSEDITOR_APP_DISPLAY_NAME}
  MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
  MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
  MACOSX_BUNDLE_GUI_IDENTIFIER ${SOLARUSEDITOR_APP_ID}
  MACOSX_BUNDLE_COPYRIGHT ${SOLARUSEDITOR_COPYRIGHT}
  MACOSX_BUNDLE_ICON_FILE ${MACOSX_BUNDLE_ICON_FILE}
  MACOSX_BUNDLE TRUE
  XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED OFF
  XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ""
  XCODE_ATTRIBUTE_CODE_SIGN_STYLE "Manual"
  XCODE_ATTRIBUTE_CODE_SIGN_INJECT_BASE_ENTITLEMENTS OFF
  XCODE_ATTRIBUTE_OTHER_CODE_SIGN_FLAGS ""
)
