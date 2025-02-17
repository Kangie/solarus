cmake_minimum_required(VERSION 3.19.0)

project("solarus-launcher"
  LANGUAGES CXX
  VERSION 2.0.0
  HOMEPAGE_URL "https://www.solarus-games.org"
  DESCRIPTION "Legacy Launcher for Solarus Quests"
)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY AUTOGEN_TARGETS_FOLDER CMakeAutogenTargets)

if(NOT CMAKE_OSX_DEPLOYMENT_TARGET)
  set(CMAKE_OSX_DEPLOYMENT_TARGET "13.6")
endif()
find_package(Qt6 REQUIRED COMPONENTS Core Gui Widgets Svg)
qt_standard_project_setup()

# Dependencies.
include(FetchContent)
FetchContent_Declare(qlementine_icons
  GIT_REPOSITORY "https://github.com/oclero/qlementine-icons.git"
  GIT_TAG 2e09b37ed13d5d9fce7e5d5e2c0c96727e0dc9b0 #v1.6.0
)
FetchContent_MakeAvailable(qlementine_icons)
set_target_properties(qlementine_icons
  PROPERTIES
    FOLDER dependencies
)

FetchContent_Declare(qlementine
  GIT_REPOSITORY "https://github.com/oclero/qlementine.git"
  GIT_TAG 2271bbb9ca076d916780fc7f51ef3b1859f22aaa #dev
)
FetchContent_MakeAvailable(qlementine)
set_target_properties(qlementine
  PROPERTIES
    FOLDER dependencies
)

set(SOLARUS_DEPLOYMENT ${CMAKE_OSX_DEPLOYMENT_TARGET})
set(SOLARUS_ARCH ${CMAKE_HOST_SYSTEM_PROCESSOR})
FetchContent_Declare(solarus
  GIT_REPOSITORY "https://gitlab.com/solarus-games/solarus.git"
  GIT_TAG 3d8f5e5a125f1f8e199b70280a0bd40db84f3d51 #new-launcher
)
FetchContent_MakeAvailable(solarus)
set_target_properties(solarus
  PROPERTIES
    FOLDER dependencies
)

# Icon.
set(MACOSX_BUNDLE_ICON_FILE solarus_launcher_icon.icns)
set(APP_ICON_MACOS "${CMAKE_CURRENT_SOURCE_DIR}/resources/icon/solarus_launcher_icon.icns")
set_source_files_properties(${APP_ICON_MACOS} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")

# Target.
qt_add_executable(solarus-launcher MANUAL_FINALIZATION
  ${APP_ICON_MACOS}
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/AboutWindow.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/AboutWindow.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/Common.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/main.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/MainWindow.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/MainWindow.h
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
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/QuestOutputHandler.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/QuestOutputHandler.h
  ${CMAKE_CURRENT_SOURCE_DIR}/sources/Utils.h
)
set_target_properties(solarus-launcher PROPERTIES OUTPUT_NAME "Solarus Launcher")

qt_add_resources(solarus-launcher "resources"
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

target_link_libraries(solarus-launcher
  PRIVATE
    Qt6::Widgets
    Qt6::Svg
    oclero::qlementine
    oclero::qlementine_icons
    solarus
)

string(TIMESTAMP PROJECT_BUILD_YEAR "%Y")
set_target_properties(solarus-launcher PROPERTIES
  ${BUNDLE_ID_OPTION}
  MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
  MACOSX_BUNDLE_BUNDLE_NAME "Solarus Launcher"
  MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
  MACOSX_BUNDLE_GUI_IDENTIFIER "org.solarus-games.solarus-launcher"
  MACOSX_BUNDLE_COPYRIGHT "© 2006-${PROJECT_BUILD_YEAR} Solarus Labs."
  MACOSX_BUNDLE TRUE
  WIN32_EXECUTABLE TRUE
  XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED OFF
  XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ""
  XCODE_ATTRIBUTE_CODE_SIGN_STYLE "Manual"
  XCODE_ATTRIBUTE_CODE_SIGN_INJECT_BASE_ENTITLEMENTS OFF
)

include(GNUInstallDirs)
install(TARGETS solarus-launcher
  BUNDLE DESTINATION .
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

qt_finalize_executable(solarus-launcher)
