message(STATUS "Using Qt ${Qt6_VERSION}")
if (Qt6_VERSION VERSION_LESS 6.7)
  qt_standard_project_setup()
else()
  qt_standard_project_setup(
    I18N_TRANSLATED_LANGUAGES en_US fr_FR
    I18N_SOURCE_LANGUAGE en_US
  )
endif()

# Get all sources.
file(GLOB_RECURSE SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/sources/*.cpp"
  "${CMAKE_CURRENT_SOURCE_DIR}/sources/*.h"
)

# Target.
qt_add_executable(${PROJECT_NAME} MANUAL_FINALIZATION
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

# Qt6 automatically uses the project name as the prefix for the translation files.
# It is possibble to use a custom prefix, but to keep things simple,
# we will use the built-in Qt6 translation system.
set(QM_PREFIX "${PROJECT_NAME}")
if (Qt6_VERSION VERSION_LESS 6.7)
  qt_add_translations(${PROJECT_NAME}
    TS_FILES
      ${CMAKE_CURRENT_SOURCE_DIR}/i18n/${QM_PREFIX}_en_US.ts
      ${CMAKE_CURRENT_SOURCE_DIR}/i18n/${QM_PREFIX}_fr_FR.ts
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

target_compile_definitions(${PROJECT_NAME} PRIVATE
  PROJECT_VERSION="${PROJECT_VERSION}"
  PROJECT_VERSION_MAJOR=${PROJECT_VERSION_MAJOR}
  PROJECT_VERSION_MINOR=${PROJECT_VERSION_MINOR}
  PROJECT_VERSION_PATCH=${PROJECT_VERSION_PATCH}
  PROJECT_APP_EXECUTABLE_NAME="${SOLARUSLAUNCHER_EXECUTABLE_NAME}"
  PROJECT_QM_PREFIX="${QM_PREFIX}"
  PROJECT_DISPLAY_NAME="${SOLARUSLAUNCHER_DISPLAY_NAME}"
  PROJECT_APP_COPYRIGHT="${SOLARUSLAUNCHER_COPYRIGHT}"
  PROJECT_APP_ORGANISATION="${SOLARUSLAUNCHER_ORGANISATION}"
  PROJECT_APP_ORGANISATION_DOMAIN="${SOLARUSLAUNCHER_ORGANISATION_DOMAIN}"
  PROJECT_HOMEPAGE_URL="${PROJECT_HOMEPAGE_URL}"
  PROJECT_APP_IDENTIFIER="${SOLARUSLAUNCHER_APP_IDENTIFIER}"
  PROJECT_LINKS_X="${LINKS_X}"
  PROJECT_LINKS_MASTODON="${LINKS_MASTODON}"
  PROJECT_LINKS_YOUTUBE="${LINKS_YOUTUBE}"
  PROJECT_LINKS_DISCORD="${LINKS_DISCORD}"
  PROJECT_LINKS_SOURCE_CODE="${LINKS_SOURCE_CODE}"
  PROJECT_LINKS_CONTACT="${LINKS_CONTACT}"
  PROJECT_LINKS_RELEASES="${LINKS_RELEASES}"
  PROJECT_LINKS_UPDATE_ENDPOINT="${LINKS_UPDATE_ENDPOINT}"
  PROJECT_DOCUMENT_EXTENSION="${SOLARUSLAUNCHER_DOCUMENT_EXTENSION}"
)

set(COMPONENT_NAME "${PROJECT_NAME}")
