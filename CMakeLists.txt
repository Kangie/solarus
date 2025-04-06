cmake_minimum_required(VERSION 3.19.0)

project("solaruslauncher"
  LANGUAGES CXX
  VERSION 2.0.0
  HOMEPAGE_URL "https://www.solarus-games.org"
  DESCRIPTION "Game Launcher for Solarus Quests"
)

if(NOT PROJECT_VERSION_TWEAK)
  set(PROJECT_VERSION_TWEAK 0)
endif()

include(GNUInstallDirs)

message(STATUS "Architecture: ${CMAKE_HOST_SYSTEM_PROCESSOR}")

string(TIMESTAMP PROJECT_BUILD_YEAR "%Y")
set(DISPLAY_NAME "Solarus Launcher")
set(EXECUTABLE_NAME "solarus-launcher")
set(APP_COPYRIGHT "© 2006-${PROJECT_BUILD_YEAR} Solarus Labs.")
set(APP_IDENTIFIER "org.solarus-games.solarus-launcher")
set(APP_GLOBAL_PROJECT "Solarus")
set(APP_ORGANISATION "Solarus Labs")
set(APP_ORGANISATION_DOMAIN "solarus-games.org")
set(APP_LICENSE "GPL-3.0 and CC-BY-SA-4.0") # Should be SPDX identifiers.
set(APP_TRADEMARKS "Licensed under ${APP_LICENSE}")
set(APP_EMAIL "solarus-labs@solarus-games.org")
set(LINKS_X "https://x.com/solarusgames")
set(LINKS_MASTODON "https://mastodon.gamedev.place/@solarus")
set(LINKS_YOUTUBE "https://www.youtube.com/c/ChristophoZS")
set(LINKS_DISCORD "https://discord.gg/yYHjJHt")
set(LINKS_SOURCE_CODE "https://www.gitlab.com/solarus-games/solarus")
set(LINKS_BUGTRACKER "https://www.gitlab.com/solarus-games/solarus-launcher/-/issues")
set(LINKS_CONTACT "https://www.solarus-games.org/about/contact")
set(LINKS_RELEASES "https://gitlab.com/api/v4/projects/solarus-games%2Fsolarus-launcher-legacy/releases")
set(LINKS_UPDATE_ENDPOINT "https://gitlab.com/api/v4/projects/solarus-games%2Fsolarus-launcher-legacy/releases/permalink/latest")
set(LINKS_HELP "https://docs.solarus-games.org")
set(LINKS_DONATION "https://www.solarus-games.org/about/donate/")

set(DOCUMENT_NAME "Solarus Quest")
set(DOCUMENT_EXTENSION "solarus")
set(DOCUMENT_TYPE_IDENTIFIER "org.solarus-games.solarus-quest")

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" "${CMAKE_SOURCE_DIR}/cmake/modules/")

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY AUTOGEN_TARGETS_FOLDER CMakeAutogenTargets)

if(NOT CMAKE_OSX_DEPLOYMENT_TARGET)
  set(CMAKE_OSX_DEPLOYMENT_TARGET "13.6")
endif()

# Find Qt.
find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Svg Network LinguistTools)
if (NOT Qt6LinguistTools_FOUND AND QT_HOST_PATH)
  find_package(Qt6LinguistTools "6.4"
               PATHS "${QT_HOST_PATH}" "${QT_HOST_PATH}/lib/cmake"
               NO_CMAKE_FIND_ROOT_PATH NO_DEFAULT_PATH QUIET)
endif()
if (NOT Qt6LinguistTools_FOUND)
  message(FATAL_ERROR "CMake module Qt6LinguistTools could not be found.")
endif()
if (Qt6_VERSION VERSION_LESS 6.4)
  message(FATAL_ERROR "At least Qt 6.4 is needed for this project.")
endif()

message(STATUS "Using Qt ${Qt6_VERSION}")
if (Qt6_VERSION VERSION_LESS 6.7)
  qt_standard_project_setup()
else()
  qt_standard_project_setup(
    I18N_TRANSLATED_LANGUAGES en_US fr_FR
    I18N_SOURCE_LANGUAGE en_US
  )
endif()

# Dependencies.
include(FetchContent)

# Qlementine Icons: an SVG icon library made for Qt.
FetchContent_Declare(qlementine-icons
  GIT_REPOSITORY "https://github.com/oclero/qlementine-icons.git"
  GIT_TAG v1.8.0
)
FetchContent_MakeAvailable(qlementine-icons)
set_target_properties(qlementine-icons
  PROPERTIES
    FOLDER dependencies
)

# Qlementine: the QStyle library to have a modern look n' feel.
FetchContent_Declare(qlementine
  GIT_REPOSITORY "https://github.com/oclero/qlementine.git"
  GIT_TAG v1.2.1
)
FetchContent_MakeAvailable(qlementine)
set_target_properties(qlementine
  PROPERTIES
    FOLDER dependencies
)

FetchContent_Declare(QtAppInstanceManager
 GIT_REPOSITORY "https://github.com/oclero/qtappinstancemanager.git"
 GIT_TAG v1.3.0
)
FetchContent_MakeAvailable(QtAppInstanceManager)
set_target_properties(QtAppInstanceManager
  PROPERTIES
    FOLDER dependencies
)

# Solarus: the engine.
# If this flag is set, CMake will download Solarus from its git repository
# instead of using a locally pre-built version.
set(SOLARUS_FETCHCONTENT OFF CACHE BOOL "Enable downloading of Solarus from its git repository")
if(SOLARUS_FETCHCONTENT)
  message(STATUS "Solarus: Fetching from git repository")
  set(SOLARUS_CLI OFF)
  set(SOLARUS_FILE_LOGGING OFF)
  set(SOLARUS_DEPLOYMENT ${CMAKE_OSX_DEPLOYMENT_TARGET})
  FetchContent_Declare(solarus
    GIT_REPOSITORY "https://gitlab.com/solarus-games/solarus.git"
    GIT_TAG v2.0.0
  )
  FetchContent_MakeAvailable(solarus)
  set_target_properties(solarus
    PROPERTIES
      FOLDER dependencies
  )
  # Disable warnings for Solarus.
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
    target_compile_options(solarus PRIVATE -w)
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    target_compile_options(solarus PRIVATE /w)
  endif()
else()
  # Ensure that Solarus is found, one way or another.
  message(STATUS "Solarus: Using from system")
  find_package(Solarus REQUIRED)
endif()

# Icon.
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(MACOSX_BUNDLE_ICON_FILE "solarus_launcher_icon.icns")
  set(APP_ICON_MACOS "${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon/${MACOSX_BUNDLE_ICON_FILE}")
  set_source_files_properties(${APP_ICON_MACOS} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")

  set(MACOSX_DOCUMENT_ICON_FILE "macos_doc_icon.icns")
  set(DOCUMENT_ICON_MACOS "${CMAKE_CURRENT_SOURCE_DIR}/resources/doc_icon/macos/${MACOSX_DOCUMENT_ICON_FILE}")
  set_source_files_properties(${DOCUMENT_ICON_MACOS} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
endif()

# Get all sources.
file(GLOB_RECURSE SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/sources/*.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/sources/*.h"
)

# Target.
qt_add_executable(${PROJECT_NAME} MANUAL_FINALIZATION
  $<$<PLATFORM_ID:Darwin>:${APP_ICON_MACOS}>
  $<$<PLATFORM_ID:Darwin>:${DOCUMENT_ICON_MACOS}>
  ${SOURCES}
)
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/sources)

qt_add_resources(${PROJECT_NAME} "resources"
  PREFIX "/solarus/launcher/"
  FILES
    # resources/flags/de.svg
    resources/flags/en.svg
    # resources/flags/es.svg
    resources/flags/fr.svg
    # resources/flags/it.svg
    # resources/flags/pt.svg
    # resources/flags/ru.svg
    # resources/flags/zh.svg
    resources/app_icon/solarus_launcher_icon_16.png
    resources/app_icon/solarus_launcher_icon_20.png
    resources/app_icon/solarus_launcher_icon_32.png
    resources/app_icon/solarus_launcher_icon_40.png
    resources/app_icon/solarus_launcher_icon_48.png
    resources/app_icon/solarus_launcher_icon_64.png
    resources/app_icon/solarus_launcher_icon_96.png
    resources/app_icon/solarus_launcher_icon_128.png
    resources/app_icon/solarus_launcher_icon_256.png
    resources/app_icon/solarus_launcher_icon_512.png
    resources/app_icon/solarus_launcher_icon_1024.png
    resources/app_icon/solarus_launcher_icon.icns
    resources/app_icon/solarus_launcher_icon.ico
    resources/app_icon/solarus_launcher_icon.svg
    resources/themes/dark.json
    resources/themes/light.json
    resources/age_ratings/all.svg
    resources/age_ratings/restricted.svg
    resources/age_ratings/warning.svg
)

if (Qt6_VERSION VERSION_LESS 6.7)
  qt_add_translations(${PROJECT_NAME}
    TS_FILES
      ${CMAKE_CURRENT_SOURCE_DIR}/i18n/${PROJECT_NAME}_en_US.ts
      ${CMAKE_CURRENT_SOURCE_DIR}/i18n/${PROJECT_NAME}_fr_FR.ts
  )
else()
  qt_add_translations(${PROJECT_NAME}
    TS_FILE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/i18n
  )
endif()

target_link_libraries(${PROJECT_NAME}
  PRIVATE
    Qt6::Widgets
    Qt6::Svg
    Qt6::Network
    qlementine
    qlementine-icons
    solarus
    oclero::QtAppInstanceManager
)

if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(CMAKE_MACOSX_RPATH ON)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)
  # set(CMAKE_INSTALL_RPATH "@executable_path/../Frameworks;@loader_path/../Frameworks")
  set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE_ICON_FILE ${MACOSX_BUNDLE_ICON_FILE}
  )
endif()

set_target_properties(${PROJECT_NAME} PROPERTIES
  # ${BUNDLE_ID_OPTION}
  OUTPUT_NAME ${EXECUTABLE_NAME}
  MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
  MACOSX_BUNDLE_BUNDLE_NAME ${DISPLAY_NAME}
  MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
  MACOSX_BUNDLE_GUI_IDENTIFIER ${APP_IDENTIFIER}
  MACOSX_BUNDLE_COPYRIGHT ${APP_COPYRIGHT}
  MACOSX_BUNDLE TRUE
  WIN32_EXECUTABLE TRUE
  XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED OFF
  XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ""
  XCODE_ATTRIBUTE_CODE_SIGN_STYLE "Manual"
  XCODE_ATTRIBUTE_CODE_SIGN_INJECT_BASE_ENTITLEMENTS OFF
  XCODE_ATTRIBUTE_OTHER_CODE_SIGN_FLAGS ""
  # INSTALL_RPATH "@executable_path/../Frameworks;@loader_path/../Frameworks"
)

target_compile_definitions(${PROJECT_NAME} PRIVATE
  PROJECT_VERSION="${PROJECT_VERSION}"
  PROJECT_VERSION_MAJOR=${PROJECT_VERSION_MAJOR}
  PROJECT_VERSION_MINOR=${PROJECT_VERSION_MINOR}
  PROJECT_VERSION_PATCH=${PROJECT_VERSION_PATCH}
  PROJECT_APP_EXECUTABLE_NAME="${EXECUTABLE_NAME}"
  PROJECT_DISPLAY_NAME="${DISPLAY_NAME}"
  PROJECT_APP_COPYRIGHT="${APP_COPYRIGHT}"
  PROJECT_APP_ORGANISATION="${APP_ORGANISATION}"
  PROJECT_APP_ORGANISATION_DOMAIN="${APP_ORGANISATION_DOMAIN}"
  PROJECT_HOMEPAGE_URL="${PROJECT_HOMEPAGE_URL}"
  PROJECT_APP_IDENTIFIER="${APP_IDENTIFIER}"
  PROJECT_LINKS_X="${LINKS_X}"
  PROJECT_LINKS_MASTODON="${LINKS_MASTODON}"
  PROJECT_LINKS_YOUTUBE="${LINKS_YOUTUBE}"
  PROJECT_LINKS_DISCORD="${LINKS_DISCORD}"
  PROJECT_LINKS_SOURCE_CODE="${LINKS_SOURCE_CODE}"
  PROJECT_LINKS_CONTACT="${LINKS_CONTACT}"
  PROJECT_LINKS_RELEASES="${LINKS_RELEASES}"
  PROJECT_LINKS_UPDATE_ENDPOINT="${LINKS_UPDATE_ENDPOINT}"
  PROJECT_DOCUMENT_EXTENSION="${DOCUMENT_EXTENSION}"
)

set(EXECUTABLE_PATH "$<TARGET_FILE:${PROJECT_NAME}>")
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(BUNDLE_PATH "$<TARGET_BUNDLE_DIR:${PROJECT_NAME}>")
endif()
set(CODE_SIGN_IDENTITY "" CACHE STRING "Codesigning identity (`security find-identity -v -p codesigning`)")
set(ENABLE_NOTARIZE OFF CACHE BOOL "Enable notarization")

set(ENABLE_QTDEPLOY ON CACHE BOOL "Enable using Qt deploy tool")
if(ENABLE_QTDEPLOY AND (CMAKE_SYSTEM_NAME STREQUAL "Darwin" OR CMAKE_SYSTEM_NAME STREQUAL "Windows"))
  if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
    set(DEPLOY_TOOL_OPTIONS_ARG "-libpath=/opt/homebrew/lib")
  endif()

  qt_generate_deploy_script(
      TARGET ${PROJECT_NAME}
      OUTPUT_SCRIPT DEPLOY_SCRIPT
      CONTENT "
  qt_deploy_runtime_dependencies(
      EXECUTABLE \"${EXECUTABLE_PATH}\"
      BIN_DIR .
      DEPLOY_TOOL_OPTIONS ${DEPLOY_TOOL_OPTIONS_ARG}
      GENERATE_QT_CONF
      VERBOSE
      NO_APP_STORE_COMPLIANCE
  )

  if(\"${CMAKE_SYSTEM_NAME}\" MATCHES \"Darwin\" AND NOT \"${CODE_SIGN_IDENTITY}\" STREQUAL \"\")
    message(STATUS \"Executing codesign with ${CODE_SIGN_IDENTITY}\")
    execute_process(COMMAND xcrun codesign
      --force
      --deep
      --options runtime
      --timestamp
      --sign \"${CODE_SIGN_IDENTITY}\"
      \"${BUNDLE_PATH}\"
      COMMAND_ERROR_IS_FATAL ANY
    )

    if(ENABLE_NOTARIZE)
      set(TMP_ZIP_PATH \"/tmp/$<TARGET_FILE_NAME:${PROJECT_NAME}>.zip\")

      execute_process(COMMAND ditto -c -k --keepParent
        \"${BUNDLE_PATH}\"
        \"${TMP_ZIP_PATH}\"
        COMMAND_ERROR_IS_FATAL ANY
      )

      execute_process(COMMAND xcrun notarytool submit --wait
        ${CODE_SIGN_IDENTITY}
        --keychain-profile \"notarytool-password\"
        \"${TMP_ZIP_PATH}\"
        COMMAND_ERROR_IS_FATAL ANY
      )

      execute_process(COMMAND xcrun stapler staple
        \"${BUNDLE_PATH}\"
        COMMAND_ERROR_IS_FATAL ANY
      )
    endif()
  endif()
  ")
endif()


if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION . COMPONENT ${PROJECT_NAME}
    LIBRARY DESTINATION $<TARGET_FILE_NAME:${PROJECT_NAME}>.app/Contents/Frameworks COMPONENT ${PROJECT_NAME}
  )
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows" AND NOT MINGW)
  install(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION . COMPONENT ${COMPONENT_NAME}
    RUNTIME DESTINATION . COMPONENT ${PROJECT_NAME}
  )
endif()
if(DEPLOY_SCRIPT)
  install(SCRIPT "${DEPLOY_SCRIPT}" COMPONENT ${PROJECT_NAME})
endif()

# Add Info.plist to the macOS bundle only on macOS.
set(EXECUTABLE_NAME ${EXECUTABLE_NAME})
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(MACOSX_BUNDLE_INFO_PLIST "${CMAKE_CURRENT_BINARY_DIR}/Info.plist")
  configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/macOS/Info.plist.in"
    "${MACOSX_BUNDLE_INFO_PLIST}"
    @ONLY
  )
  target_sources(${PROJECT_NAME} PRIVATE "${MACOSX_BUNDLE_INFO_PLIST}")
  set_target_properties(${PROJECT_NAME} PROPERTIES MACOSX_BUNDLE_INFO_PLIST "${MACOSX_BUNDLE_INFO_PLIST}")
endif()

# Add the resources.rc file to the Windows exe only on Windows.
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  # Generate the manifest file.
  set(APPLICATION_MANIFEST_ABSOLUTE_PATH "${CMAKE_CURRENT_BINARY_DIR}/${EXECUTABLE_NAME}.manifest")
  configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/windows/App.exe.manifest.in"
    "${APPLICATION_MANIFEST_ABSOLUTE_PATH}"
  )
  file(TO_NATIVE_PATH
    "${APPLICATION_MANIFEST_ABSOLUTE_PATH}"
    WINDOWS_APPLICATION_MANIFEST_ABSOLUTE_PATH
  )

  # We embed both the app icon and its document icon in the exe.
  file(TO_NATIVE_PATH
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon/solarus_launcher_icon.ico"
    WINDOWS_APPLICATION_ICON_ABSOLUTE_PATH
  )
  file(TO_NATIVE_PATH
    "${CMAKE_CURRENT_SOURCE_DIR}/resources/doc_icon/windows/win_doc_icon.ico"
    WINDOWS_FILE_ICON_ABSOLUTE_PATH
  )

  configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/windows/Resources.rc.in"
    "${CMAKE_CURRENT_BINARY_DIR}/Resources.rc"
  )
  target_sources(${PROJECT_NAME} PRIVATE "${CMAKE_CURRENT_BINARY_DIR}/Resources.rc")
endif()

if(UNIX AND NOT APPLE OR MINGW)
  # Executable.
  install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
  )

  # Desktop environment metadata.
  set(DESKTOP_FILE ${CMAKE_CURRENT_BINARY_DIR}/${APP_IDENTIFIER}.desktop)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/linux/app.desktop.in
    ${DESKTOP_FILE}
    @ONLY
  )
  install(FILES ${DESKTOP_FILE}
    DESTINATION share/applications
  )

  # AppStream Metadata metadata (for Gnome Software Center).
  set(METAINFO_FILE ${CMAKE_CURRENT_BINARY_DIR}/${APP_IDENTIFIER}.metainfo.xml)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cmake/linux/app.metainfo.xml.in
    ${METAINFO_FILE}
    @ONLY
  )
  install(FILES ${METAINFO_FILE}
    DESTINATION share/metainfo
  )

  # Raster images for icon sizes under 48x48 pixels.
  foreach(SIZE IN ITEMS 16 20 24 32 40 48)
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon/solarus_launcher_icon_${SIZE}.png
      DESTINATION share/icons/hicolor/${SIZE}x${SIZE}/apps RENAME ${APP_IDENTIFIER}.png
    )
  endforeach(SIZE)

  # Raster image for desktops that don't support multiple sizes.
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon/solarus_launcher_icon_512.png
    DESTINATION share/pixmaps RENAME ${APP_IDENTIFIER}.png
  )

  # Vector images, automatically chosen for icon sizes above 48x48 pixels
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon/solarus_launcher_icon.svg
    DESTINATION share/icons/hicolor/scalable/apps RENAME ${APP_IDENTIFIER}.svg
  )

  # Monochromatic vector image for some desktop environments that need it.
  install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/resources/app_icon/solarus_launcher_icon_symbolic.svg
    DESTINATION share/icons/hicolor/symbolic/apps RENAME ${APP_IDENTIFIER}.svg
  )

  # Register a .solarus extension.
  install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/cmake/linux/solarus.xml DESTINATION share/mime/packages)

  # Association to files wth the "".solarus" extension.
  install(CODE "execute_process(COMMAND update-mime-database /usr/share/mime)")
  install(CODE "execute_process(COMMAND update-desktop-database /usr/share/applications)")
  install(CODE "execute_process(COMMAND mkdir -p /root/.config)") # Ensure the .config directory exists.
  install(CODE "execute_process(COMMAND touch /root/.config/mimeapps.list)") # Ensure the mimeapps.list file exists.
  install(CODE "execute_process(COMMAND xdg-mime default ${APP_IDENTIFIER}.desktop application/x-solarus)")

endif()

qt_finalize_executable(${PROJECT_NAME})

# Packaging.
set(CPACK_PACKAGE_NAME "${DISPLAY_NAME}")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_DESCRIPTION}")
set(CPACK_PACKAGE_VENDOR "${APP_ORGANISATION}")
set(CPACK_PACKAGE_CONTACT "${APP_EMAIL}")
set(CPACK_PACKAGE_LICENSE "${APP_LICENSE}")
set(CPACK_COMPONENTS_ALL ${COMPONENT_NAME})
set(CPACK_PACKAGE_FILE_NAME "${DISPLAY_NAME} Installer v${PROJECT_VERSION}")

if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(DMG_SCRIPT ON CACHE BOOL "Enable DMG customization with AppleScript")

  set(BUNDLE_NAME "${DISPLAY_NAME}.app")
  if(DMG_SCRIPT)
    set(DMG_APPLESCRIPT "${CMAKE_CURRENT_BINARY_DIR}/DMGSetup.applescript")
    configure_file(
      ${CMAKE_CURRENT_SOURCE_DIR}/cmake/cpack/DragNDrop/DMGSetup.applescript.in
      ${DMG_APPLESCRIPT}
      @ONLY
    )
  endif()

  set(CPACK_GENERATOR "DragNDrop")
  set(CPACK_PACKAGE_VENDOR "${APP_ORGANISATION}")
  set(CPACK_PACKAGE_FILE_NAME "${DISPLAY_NAME} Installer")
  set(CPACK_PACKAGE_ICON "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cpack/DragNDrop/DMGVolumeIcon.icns")
  set(CPACK_BUNDLE_NAME "${DISPLAY_NAME}")
  set(CPACK_DMG_VOLUME_NAME "${DISPLAY_NAME} Installer")
  set(CPACK_DMG_BACKGROUND_IMAGE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cpack/DragNDrop/DMGBackground@2x.png")
  if(DMG_APPLESCRIPT)
    set(CPACK_DMG_DS_STORE_SETUP_SCRIPT "${DMG_APPLESCRIPT}")
  endif()
  set(CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_CURRENT_BINARY_DIR};${PROJECT_NAME};${PROJECT_NAME};/")
  # Components.
  set(CPACK_COMPONENTS_ALL ${PROJECT_NAME})

elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  set(CPACK_GENERATOR "NSIS")
  set(CPACK_PACKAGE_VENDOR "${APP_ORGANISATION}")
  set(CPACK_NSIS_DISPLAY_NAME "${PROJECT_NAME}")
  set(CPACK_NSIS_PACKAGE_NAME "${PROJECT_NAME} Installer")
  set(CPACK_NSIS_EXECUTABLES_DIRECTORY ".")
  set(CPACK_NSIS_MUI_ICON "${CMAKE_SOURCE_DIR}/cmake/cpack/NSIS/NSISInstallerIcon.ico")
  set(CPACK_NSIS_MUI_UNICON "${CPACK_NSIS_MUI_ICON}")
  set(CPACK_NSIS_INSTALLED_ICON_NAME "${CPACK_NSIS_MUI_ICON}")
  set(CPACK_NSIS_HELP_LINK "${LINKS_HELP}")
  set(CPACK_NSIS_URL_INFO_ABOUT "${PROJECT_HOMEPAGE_URL}")
  set(CPACK_NSIS_CONTACT "${LINKS_CONTACT}")

  # TODO: It seems that MUI on Msys2 needs windows native paths, but the images are not shown...
  file(TO_NATIVE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cpack/NSIS/NSISWelcomeImage.bmp" CPACK_NSIS_MUI_WELCOMEFINISHPAGE_BITMAP)
  set(CPACK_NSIS_MUI_UNWELCOMEFINISHPAGE_BITMAP "${CPACK_NSIS_MUI_WELCOMEFINISHPAGE_BITMAP}")
  file(TO_NATIVE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cpack/NSIS/NSISHeaderImage.bmp" CPACK_NSIS_MUI_HEADERIMAGE)

  # set(CPACK_NSIS_MUI_HEADERIMAGE "${CMAKE_SOURCE_DIR}/cmake/cpack/NSIS/NSISHeaderImage.bmp")

  set(CPACK_NSIS_COMPRESSOR "/SOLID /FINAL lzma")
  set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
  set(CPACK_NSIS_MODIFY_PATH OFF)
  set(CPACK_NSIS_MANIFEST_DPI_AWARE ON)
  set(CPACK_NSIS_BRANDING_TEXT "v${PROJECT_VERSION}")
  set(CPACK_NSIS_IGNORE_LICENSE_PAGE ON)
  set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES\\\\${APP_GLOBAL_PROJECT}")

  # Set the file extension for the document type.
  # set(EXECUTABLE_NAME "$<TARGET_FILE_NAME:${PROJECT_NAME}>")
  # set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "
  #   WriteRegStr HKCR \".${FILE_EXTENSION}\" \"\" \"${DOCUMENT_TYPE_IDENTIFIER}\"
  #   WriteRegStr HKCR \"${DOCUMENT_TYPE_IDENTIFIER}\" \"\" \"${DOCUMENT_NAME}\"
  #   WriteRegStr HKCR \"${DOCUMENT_TYPE_IDENTIFIER}\\DefaultIcon\" \"\" \"$INSTDIR\\${EXECUTABLE_NAME},1\"
  #   WriteRegStr HKCR \"${DOCUMENT_TYPE_IDENTIFIER}\\shell\\open\\command\" \"\" \"$INSTDIR\\${EXECUTABLE_NAME} \\\"%1\\\"\"
  #   DetailPrint \"Registry modified: file association added\"
  # ")
  # set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS "
  #   DeleteRegKey HKCR \".${FILE_EXTENSION}\"
  #   DeleteRegKey HKCR \"${DOCUMENT_TYPE_IDENTIFIER}\"
  # ")

  # Components.
  set(CPACK_COMPONENTS_ALL ${PROJECT_NAME})
endif()

include(CPack)
