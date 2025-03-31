# TODO check if it works.
install(FILES solarus.xml DESTINATION share/mime/packages)
install(FILES ${APP_IDENTIFIER}.desktop DESTINATION share/applications)
install(CODE "execute_process(COMMAND update-mime-database WORKING_DIRECTORY /usr/share/mime)")
install(CODE "execute_process(COMMAND update-desktop-database WORKING_DIRECTORY /usr/share/applications)")
install(CODE "execute_process(COMMAND xdg-mime default WORKING_DIRECTORY ${APP_IDENTIFIER}.desktop application/x-solarus)")
