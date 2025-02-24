cmake_minimum_required(VERSION 3.19.0)

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
find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Svg)
qt_standard_project_setup()

# Dependencies.
include(FetchContent)

# Qlementine Icons: an SVG icon library made for Qt.
FetchContent_Declare(qlementine_icons
  GIT_REPOSITORY "https://github.com/oclero/qlementine-icons.git"
  GIT_TAG 2e09b37ed13d5d9fce7e5d5e2c0c96727e0dc9b0 #v1.6.0
)
FetchContent_MakeAvailable(qlementine_icons)
set_target_properties(qlementine_icons
  PROPERTIES
    FOLDER dependencies
)

# Qlementine: the QStyle library to have a modern look n' feel.
FetchContent_Declare(qlementine
  GIT_REPOSITORY "https://github.com/oclero/qlementine.git"
  GIT_TAG 468ba5795809b140c4c2981c68009ab24d506d3e #v1.0.2
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
  set(SOLARUS_DEPLOYMENT ${CMAKE_OSX_DEPLOYMENT_TARGET})
  set(SOLARUS_ARCH ${CMAKE_HOST_SYSTEM_PROCESSOR})
  FetchContent_Declare(solarus
    GIT_REPOSITORY "https://gitlab.com/solarus-games/solarus.git"
    GIT_TAG 6c314e665af9e927c9d83a1661389f8a34a2d671 #new-launcher
  )
  FetchContent_MakeAvailable(solarus)
  set_target_properties(solarus
    PROPERTIES
      FOLDER dependencies
  )
else()
  # Ensure that Solarus is found, one way or another.
  find_package(Solarus REQUIRED)
endif()

# Icon.
set(MACOSX_BUNDLE_ICON_FILE solarus_launcher_icon.icns)
set(APP_ICON_MACOS "${CMAKE_CURRENT_SOURCE_DIR}/resources/icon/solarus_launcher_icon.icns")
set_source_files_properties(${APP_ICON_MACOS} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")

# Target.
qt_add_executable(${PROJECT_NAME} MANUAL_FINALIZATION
  ${APP_ICON_MACOS}
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/AboutWindow.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/AboutWindow.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/Common.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/Console.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/Console.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/main.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/MainWindow.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/MainWindow.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/MessageBox.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/MessageBox.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/Preferences.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/Preferences.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/PreferencesWindow.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/PreferencesWindow.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/QuestData.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/QuestListItemDelegate.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/QuestListItemDelegate.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/QuestListModel.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/QuestListModel.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/QuestRunner.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/QuestRunner.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/Utils.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/Utils.h
)
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME ${APP_NAME})

qt_add_resources(${PROJECT_NAME} "resources"
  PREFIX "/solarus/launcher/"
  FILES
    resources/themes/dark.json
    resources/themes/light.json
    resources/icon/solarus_launcher_icon.icns
    resources/icon/solarus_launcher_icon.ico
    resources/icon/solarus_launcher_icon.svg
    resources/icon/solarus_launcher_icon_1024.png
    resources/icon/solarus_launcher_icon_128.png
    resources/icon/solarus_launcher_icon_16.png
    resources/icon/solarus_launcher_icon_20.png
    resources/icon/solarus_launcher_icon_24.png
    resources/icon/solarus_launcher_icon_256.png
    resources/icon/solarus_launcher_icon_32.png
    resources/icon/solarus_launcher_icon_40.png
    resources/icon/solarus_launcher_icon_48.png
    resources/icon/solarus_launcher_icon_512.png
    resources/icon/solarus_launcher_icon_64.png
    resources/icon/solarus_launcher_icon_96.png
    resources/icon/solarus_launcher_icon_symbolic.svg
    resources/icon/solarus_quest_icon.icns
    resources/icon/solarus_quest_icon.ico
)

target_link_libraries(${PROJECT_NAME}
  PRIVATE
    Qt6::Widgets
    Qt6::Svg
    qlementine
    oclero::qlementine_icons
    solarus
)

set_target_properties(${PROJECT_NAME} PROPERTIES
  ${BUNDLE_ID_OPTION}
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
)

set(EXECUTABLE_PATH "$<TARGET_FILE_NAME:${PROJECT_NAME}>.app")
qt_generate_deploy_script(
    TARGET ${PROJECT_NAME}
    OUTPUT_SCRIPT DEPLOY_SCRIPT
    CONTENT "
qt_deploy_runtime_dependencies(
    EXECUTABLE \"${EXECUTABLE_PATH}\"
    DEPLOY_TOOL_OPTIONS \"${DEPLOY_TOOL_OPTIONS_ARG}\"
    GENERATE_QT_CONF
    VERBOSE
    NO_APP_STORE_COMPLIANCE
)")

include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
  BUNDLE DESTINATION .
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
install(SCRIPT "${DEPLOY_SCRIPT}")

qt_finalize_executable(${PROJECT_NAME})

# Packaging.
include(CPack)
if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(CPACK_GENERATOR "DragNDrop")
  set(CPACK_PACKAGE_FILE_NAME "${APP_NAME} Installer") # The name of the generated package
  set(CPACK_BUNDLE_NAME "${APP_NAME}") # The name of the app bundle
endif()
