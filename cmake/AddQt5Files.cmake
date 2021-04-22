# Add the three types of Qt5 files.

# UI files.
set(solarus_quest_editor_FORMS
  src/widgets/about_dialog.ui
  src/widgets/change_border_set_id_dialog.ui
  src/widgets/change_dialog_id_dialog.ui
  src/widgets/change_file_info_dialog.ui
  src/widgets/change_resource_id_dialog.ui
  src/widgets/change_source_image_dialog.ui
  src/widgets/change_string_key_dialog.ui
  src/widgets/dialogs_editor.ui
  src/widgets/edit_entity_dialog.ui
  src/widgets/external_script_dialog.ui
  src/widgets/find_text_dialog.ui
  src/widgets/import_dialog.ui
  src/widgets/input_dialog_with_check_box.ui
  src/widgets/main_window.ui
  src/widgets/map_editor.ui
  src/widgets/new_entity_user_property_dialog.ui
  src/widgets/new_quest_dialog.ui
  src/widgets/new_quest_dialog_contents_page.ui
  src/widgets/new_quest_dialog_directory_page.ui
  src/widgets/new_quest_dialog_name_page.ui
  src/widgets/new_resource_element_dialog.ui
  src/widgets/new_string_dialog.ui
  src/widgets/package_dialog.ui
  src/widgets/pattern_picker_dialog.ui
  src/widgets/quest_properties_editor.ui
  src/widgets/settings_dialog.ui
  src/widgets/shader_editor.ui
  src/widgets/sprite_editor.ui
  src/widgets/sprite_previewer.ui
  src/widgets/strings_editor.ui
  src/widgets/tileset_editor.ui
)

# Generate .h from .ui.
qt5_wrap_ui(solarus_quest_editor_FORMS_HEADERS
  ${solarus_quest_editor_FORMS}
)

# Resources.
set(solarus_quest_editor_RESOURCES
  resources/images.qrc
  resources/initial_files.qrc
  resources/quest_converter.qrc
)

# Compile resource files.
qt5_add_resources(solarus_quest_editor_RESOURCES_RCC
  ${solarus_quest_editor_RESOURCES}
)

# Translations.
set(solarus_quest_editor_TRANSLATIONS
  translations/solarus_editor_es.ts
  translations/solarus_editor_fr.ts
)
qt5_add_translation(solarus_quest_editor_TRANSLATIONS_QM
  ${solarus_quest_editor_TRANSLATIONS}
)
