# Main executable.
add_executable(solarus-quest-editor
  ${solarus_quest_editor_SOURCES}
  ${solarus_quest_editor_FORMS_HEADERS}
  ${solarus_quest_editor_RESOURCES_RCC}
  ${solarus_quest_editor_TRANSLATIONS_QM}
)

target_link_libraries(solarus-quest-editor
  Qt6::Widgets
  Qt6::OpenGL
  Qt6::OpenGLWidgets
  "${SOLARUS_LIBRARIES}"
  "${SDL2_LIBRARY}"
  "${SDL2_IMAGE_LIBRARY}"
  "${SDL2_TTF_LIBRARY}"
  "${OPENAL_LIBRARY}"
  "${LUA_LIBRARY}"
  "${DL_LIBRARY}"
  "${PHYSFS_LIBRARY}"
  "${VORBISFILE_LIBRARY}"
  "${OGG_LIBRARY}"
  "${MODPLUG_LIBRARY}"
  qlementine
)
