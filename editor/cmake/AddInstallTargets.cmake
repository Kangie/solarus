# Set files to install
install(TARGETS solarus-editor
  RUNTIME DESTINATION ${SOLARUS_INSTALL_BINDIR}
)

if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  # macOS app bundle.
  install(DIRECTORY "${CMAKE_SOURCE_DIR}/assets/"
    DESTINATION "$<TARGET_FILE_NAME:${PROJECT_NAME}>.app/Contents/Resources/assets"
    COMPONENT ${PROJECT_NAME}
    PATTERN ".DS_Store" EXCLUDE
  )
else()
  # Other Unix platforms.
  install(DIRECTORY "${CMAKE_SOURCE_DIR}/assets/"
    DESTINATION "${SOLARUS_INSTALL_DATADIR}/assets"
    COMPONENT ${PROJECT_NAME}
    PATTERN ".DS_Store" EXCLUDE
  )
endif()

install(FILES ${SOLARUSEDITOR_TRANSLATIONS_QM}
  DESTINATION "${SOLARUS_INSTALL_DATADIR}/translations"
)
