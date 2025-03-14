cmake_minimum_required(VERSION 3.19.0)

# Get the number of CPU cores available for building.
find_program(NPROC_COMMAND nproc)
if (NPROC_COMMAND)
  execute_process(COMMAND nproc OUTPUT_VARIABLE NUM_CORES OUTPUT_STRIP_TRAILING_WHITESPACE)
  set(CMAKE_BUILD_PARALLEL_LEVEL ${NUM_CORES})
  message(STATUS "Building with ${NUM_CORES} parallel jobs")
endif()

project("solarus-launcher"
  LANGUAGES CXX
  VERSION 2.0.0
  HOMEPAGE_URL "https://www.solarus-games.org"
  DESCRIPTION "Legacy Launcher for Solarus Quests"
)

string(TIMESTAMP PROJECT_BUILD_YEAR "%Y")
set(APP_NAME "Solarus Launcher")
set(APP_COPYRIGHT "© 2006-${PROJECT_BUILD_YEAR} Solarus Labs.")
set(APP_IDENTIFIER "org.solarus-games.solarus-launcher")
set(APP_ORGANISATION "Solarus Labs")
set(APP_ORGANISATION_DOMAIN "solarus-games.org")
set(LINKS_X "https://x.com/solarusgames")
set(LINKS_MASTODON "https://mastodon.gamedev.place/@solarus")
set(LINKS_YOUTUBE "https://www.youtube.com/c/ChristophoZS")
set(LINKS_DISCORD "https://discord.gg/yYHjJHt")
set(LINKS_SOURCE_CODE "https://www.gitlab.com/solarus-games")
set(LINKS_CONTACT "https://www.solarus-games.org/about/contact")
set(LINKS_RELEASES "https://gitlab.com/api/v4/projects/solarus-games%2Fsolarus-launcher-legacy/releases")
set(LINKS_UPDATE_ENDPOINT "https://gitlab.com/api/v4/projects/solarus-games%2Fsolarus-launcher-legacy/releases/permalink/latest")

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
  GIT_TAG ef40cebe94064f91fcfa600600afe263266fa51e #v1.7.1
)
FetchContent_MakeAvailable(qlementine-icons)
set_target_properties(qlementine-icons
  PROPERTIES
    FOLDER dependencies
)

# Qlementine: the QStyle library to have a modern look n' feel.
FetchContent_Declare(qlementine
  GIT_REPOSITORY "https://github.com/oclero/qlementine.git"
  GIT_TAG 5f4ea6fd571f53f34e82a77062913a228910a5c5 #dev
)
FetchContent_MakeAvailable(qlementine)
set_target_properties(qlementine
  PROPERTIES
    FOLDER dependencies
)

# Solarus: the engine.
# If this flag is set, CMake will download Solarus from its git repository
# instead of using a locally pre-built version.
if(SOLARUS_FETCHCONTENT)
  message(STATUS "Solarus: Fetching from git repository")
  set(SOLARUS_DEPLOYMENT ${CMAKE_OSX_DEPLOYMENT_TARGET})
  set(SOLARUS_ARCH ${CMAKE_HOST_SYSTEM_PROCESSOR})
  FetchContent_Declare(solarus
    GIT_REPOSITORY "https://gitlab.com/solarus-games/solarus.git"
    GIT_TAG b0aeefdae8c80b3cf91614d68c4b264640c4265b #new-launcher
  )
  FetchContent_MakeAvailable(solarus)
  set_target_properties(solarus
    PROPERTIES
      FOLDER dependencies
  )
else()
  # Ensure that Solarus is found, one way or another.
  message(STATUS "Solarus: Using from system")
  find_package(Solarus REQUIRED)
endif()

# Icon.
set(MACOSX_BUNDLE_ICON_FILE solarus_launcher_icon.icns)
set(APP_ICON_MACOS "${CMAKE_CURRENT_SOURCE_DIR}/resources/icon/${MACOSX_BUNDLE_ICON_FILE}")
set_source_files_properties(${APP_ICON_MACOS} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")

file(GLOB_RECURSE SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/sources/*.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/sources/*.h"
)

# Target.
qt_add_executable(${PROJECT_NAME} MANUAL_FINALIZATION
  ${APP_ICON_MACOS}
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
    resources/icon/solarus_launcher_icon_16.png
    resources/icon/solarus_launcher_icon_20.png
    resources/icon/solarus_launcher_icon_32.png
    resources/icon/solarus_launcher_icon_40.png
    resources/icon/solarus_launcher_icon_48.png
    resources/icon/solarus_launcher_icon_64.png
    resources/icon/solarus_launcher_icon_96.png
    resources/icon/solarus_launcher_icon_128.png
    resources/icon/solarus_launcher_icon_256.png
    resources/icon/solarus_launcher_icon_512.png
    resources/icon/solarus_launcher_icon_1024.png
    resources/icon/solarus_launcher_icon.icns
    resources/icon/solarus_launcher_icon.ico
    resources/icon/solarus_launcher_icon.svg
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
)

set_target_properties(${PROJECT_NAME} PROPERTIES
  ${BUNDLE_ID_OPTION}
  OUTPUT_NAME ${APP_NAME}
  MACOSX_BUNDLE_ICON_FILE ${MACOSX_BUNDLE_ICON_FILE}
  MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
  MACOSX_BUNDLE_BUNDLE_NAME ${APP_NAME}
  MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
  MACOSX_BUNDLE_GUI_IDENTIFIER ${APP_IDENTIFIER}
  MACOSX_BUNDLE_COPYRIGHT ${APP_COPYRIGHT}
  MACOSX_BUNDLE TRUE
  WIN32_EXECUTABLE TRUE
  XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED OFF
  XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ""
  XCODE_ATTRIBUTE_CODE_SIGN_STYLE "Manual"
  XCODE_ATTRIBUTE_CODE_SIGN_INJECT_BASE_ENTITLEMENTS OFF
)

target_compile_definitions(${PROJECT_NAME} PRIVATE
  PROJECT_VERSION="${PROJECT_VERSION}"
  PROJECT_VERSION_MAJOR=${PROJECT_VERSION_MAJOR}
  PROJECT_VERSION_MINOR=${PROJECT_VERSION_MINOR}
  PROJECT_VERSION_PATCH=${PROJECT_VERSION_PATCH}
  PROJECT_APP_NAME="${APP_NAME}"
  PROJECT_APP_COPYRIGHT="${APP_COPYRIGHT}"
  PROJECT_APP_ORGANISATION="${APP_ORGANISATION}"
  PROJECT_APP_ORGANISATION_DOMAIN="${APP_ORGANISATION_DOMAIN}"
  PROJECT_HOMEPAGE_URL="${PROJECT_HOMEPAGE_URL}"
  PROJECT_LINKS_X="${LINKS_X}"
  PROJECT_LINKS_MASTODON="${LINKS_MASTODON}"
  PROJECT_LINKS_YOUTUBE="${LINKS_YOUTUBE}"
  PROJECT_LINKS_DISCORD="${LINKS_DISCORD}"
  PROJECT_LINKS_SOURCE_CODE="${LINKS_SOURCE_CODE}"
  PROJECT_LINKS_CONTACT="${LINKS_CONTACT}"
  PROJECT_LINKS_RELEASES="${LINKS_RELEASES}"
  PROJECT_LINKS_UPDATE_ENDPOINT="${LINKS_UPDATE_ENDPOINT}"
)

set(EXECUTABLE_PATH "$<TARGET_FILE:${PROJECT_NAME}>")
# set(DEPLOY_TOOL_OPTIONS_ARG "-codesign=${CODESIGNING_NAME}") # tmp
qt_generate_deploy_script(
    TARGET ${PROJECT_NAME}
    OUTPUT_SCRIPT DEPLOY_SCRIPT
    CONTENT "
qt_deploy_runtime_dependencies(
    EXECUTABLE \"${EXECUTABLE_PATH}\"
    BIN_DIR .
    DEPLOY_TOOL_OPTIONS \"${DEPLOY_TOOL_OPTIONS_ARG}\"
    GENERATE_QT_CONF
    VERBOSE
    NO_APP_STORE_COMPLIANCE
)")

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
  BUNDLE DESTINATION . COMPONENT ${PROJECT_NAME}
  LIBRARY DESTINATION $<TARGET_FILE_NAME:${PROJECT_NAME}>.app/Contents/Frameworks COMPONENT ${PROJECT_NAME}
  #RUNTIME DESTINATION $<TARGET_FILE_NAME:${PROJECT_NAME}>.app/Contents/MacOS COMPONENT ${PROJECT_NAME}
)
install(SCRIPT "${DEPLOY_SCRIPT}" COMPONENT ${PROJECT_NAME})

qt_finalize_executable(${PROJECT_NAME})

# Packaging.
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(BUNDLE_NAME "${APP_NAME}.app")
  configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/cpack/DragNDrop/DMGSetup.applescript.in
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/cpack/DragNDrop/DMGSetup.applescript
    @ONLY
  )
  set(CPACK_GENERATOR "DragNDrop")
  set(CPACK_PACKAGE_VENDOR "${APP_ORGANISATION}")
  set(CPACK_PACKAGE_FILE_NAME "${APP_NAME} Installer")
  set(CPACK_PACKAGE_ICON "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cpack/DragNDrop/DMGVolumeIcon.icns")
  set(CPACK_BUNDLE_NAME "${APP_NAME}")
  set(CPACK_DMG_VOLUME_NAME "${APP_NAME} Installer")
  set(CPACK_DMG_BACKGROUND_IMAGE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cpack/DragNDrop/DMGBackground@2x.png")
  set(CPACK_DMG_DS_STORE_SETUP_SCRIPT "${CMAKE_CURRENT_BINARY_DIR}/cmake/cpack/DragNDrop/DMGSetup.applescript")
  set(CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_CURRENT_BINARY_DIR};${PROJECT_NAME};${PROJECT_NAME};/")
  set(CPACK_COMPONENTS_ALL ${PROJECT_NAME})
endif()
include(CPack)
