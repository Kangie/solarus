# Set files to install
install(TARGETS solarus-quest-editor
  RUNTIME DESTINATION ${SOLARUS_INSTALL_BINDIR}
)
install(DIRECTORY "${CMAKE_SOURCE_DIR}/assets/"
  DESTINATION "${SOLARUS_INSTALL_DATADIR}/assets"
)
