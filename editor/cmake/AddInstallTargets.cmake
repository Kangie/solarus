# Set files to install
install(TARGETS solarus-editor
  RUNTIME DESTINATION ${SOLARUS_INSTALL_BINDIR}
)
install(DIRECTORY "${CMAKE_SOURCE_DIR}/assets/"
  DESTINATION "${SOLARUS_INSTALL_DATADIR}/assets"
)
install(FILES ${solarus_quest_editor_TRANSLATIONS_QM}
  DESTINATION "${SOLARUS_INSTALL_DATADIR}/translations"
)
