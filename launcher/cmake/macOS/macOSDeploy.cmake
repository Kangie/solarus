set(CODESIGN_IDENTITY "" CACHE STRING "Codesigning identity (`security find-identity -v -p codesigning`)")
set(ENABLE_NOTARIZE OFF CACHE BOOL "Enable notarization")

set(DEPLOY_TOOL_OPTIONS_ARG "-libpath=/opt/homebrew/lib")

install(TARGETS ${PROJECT_NAME}
  BUNDLE DESTINATION . COMPONENT ${PROJECT_NAME}
  LIBRARY DESTINATION $<TARGET_FILE_NAME:${PROJECT_NAME}>.app/Contents/Frameworks COMPONENT ${PROJECT_NAME}
)

find_program(MAC_DEPLOY_QT NAMES macdeployqt)

message(STATUS "macdeployqt found at ${MAC_DEPLOY_QT}")
if(NOT MAC_DEPLOY_QT)
  message(FATAL_ERROR "macdeployqt not found. Please install Qt and add it to your PATH.")
endif()

file(CONFIGURE
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/fixup_bundle.cmake
  @ONLY
  CONTENT
  [=[
include(BundleUtilities)

# Used to generate Qt.conf & copy Qt plugins.
execute_process(COMMAND @MAC_DEPLOY_QT@ "${CMAKE_INSTALL_PREFIX}/@EXECUTABLE_NAME@.app")

# Get installed Qt Plugins.
file(GLOB_RECURSE QT_PLUGINS "${CMAKE_INSTALL_PREFIX}/@EXECUTABLE_NAME@.app/Contents/Plugins/*.dylib")

# Fixup the bundle.
fixup_bundle("${CMAKE_INSTALL_PREFIX}/@EXECUTABLE_NAME@.app"
  "${QT_PLUGINS}"
  "@QT6_INSTALL_PREFIX@/lib;/opt/homebrew/lib;@CMAKE_BINARY_DIR@/_deps/solarus-build"
)
]=]
)

install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/fixup_bundle.cmake COMPONENT ${PROJECT_NAME})

# Enable the following if you want to sign the bundle.
set(CODESIGN_IDENTITY "" CACHE BOOL "Identity used to sign the bundle")
if(CODESIGN_IDENTITY)
  file(CONFIGURE
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/codesign_bundle.cmake
    @ONLY
    CONTENT
    [=[
message(STATUS "Executing codesign with @CODESIGN_IDENTITY@")
# FIXME: --deep is deprecated....
execute_process(COMMAND xcrun codesign
  --force
  --deep
  --options runtime
  --timestamp
  --sign "@CODESIGN_IDENTITY@"
  "${CMAKE_INSTALL_PREFIX}/@EXECUTABLE_NAME@.app"
  COMMAND_ERROR_IS_FATAL ANY
)

# check if the codesigning was successful
execute_process(COMMAND codesign --verify --deep --strict --verbose=4 "${CMAKE_INSTALL_PREFIX}/@EXECUTABLE_NAME@.app"
  COMMAND_ERROR_IS_FATAL ANY
)
]=]
  )
  install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/codesign_bundle.cmake COMPONENT ${PROJECT_NAME})

  # Enable the following if you want to notarize the bundle.
  set(ENABLE_NOTARIZE OFF CACHE BOOL "Enable notarization")
  if(ENABLE_NOTARIZE)
    file(CONFIGURE
      OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/notarize_bundle.cmake
      @ONLY
      CONTENT
      [=[
  message(STATUS "Notarizing the bundle")
  set(TMP_ZIP_PATH "/tmp/@EXECUTABLE_NAME@.zip")
  execute_process(COMMAND ditto -c -k --keepParent
    "${CMAKE_INSTALL_PREFIX}/@EXECUTABLE_NAME@.app"
    "${TMP_ZIP_PATH}"
    COMMAND_ERROR_IS_FATAL ANY
  )

  execute_process(COMMAND xcrun notarytool submit --wait
    --keychain-profile "notarytool-password"
    "${TMP_ZIP_PATH}"
    RESULT_VARIABLE NOTARIZE_RESULT
    COMMAND_ERROR_IS_FATAL ANY
  )

  if(NOT NOTARIZE_RESULT EQUAL 0)
    message(STATUS "Notarization failed with error code ${NOTARIZE_RESULT}")
    message(FATAL_ERROR "run : xcrun notarytool log --keychain-profile \"notarytool-password\" <id>"
      COMMAND_ERROR_IS_FATAL ANY
    )
  endif()

  execute_process(COMMAND xcrun stapler staple "${CMAKE_INSTALL_PREFIX}/@EXECUTABLE_NAME@.app"
    COMMAND_ERROR_IS_FATAL ANY
  )
  ]=]
    )
    install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/notarize_bundle.cmake COMPONENT ${PROJECT_NAME})
  endif()

endif()
