/*
 * Copyright (C) 2014-2018 Christopho, Solarus - http://www.solarus-games.org
 *
 * Solarus Quest Editor is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Solarus Quest Editor is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include "widgets/gui_tools.h"
#include "widgets/shader_editor.h"
#include "editor_exception.h"
#include "quest.h"
#include "shader_model.h"
#include <QUndoStack>

namespace SolarusEditor {

/**
 * @brief Creates a shader editor.
 * @param quest The quest containing the file.
 * @param path Path of the sprite data file to open.
 * @param parent The parent object or nullptr.
 * @throws EditorException If the file could not be opened.
 */
ShaderEditor::ShaderEditor(Quest& quest, const QString& path, QWidget* parent) :
  Editor(quest, path, parent),
  model(nullptr),
  quest(quest) {

  ui.setupUi(this);

  // Get the shader.
  ResourceType resource_type;
  QString shader_id;
  quest.check_exists(path);
  if (!quest.is_resource_element(path, resource_type, shader_id) ||
      resource_type != ResourceType::SHADER) {
    throw EditorException(tr("File '%1' is not a shader").arg(path));
  }
  this->shader_id = shader_id;

  // Editor properties.
  set_title(tr("Shader %1").arg(get_file_name_without_extension()));
  set_icon(QIcon(":/images/icon_resource_shader.png"));
  set_close_confirm_message(
        tr("Shader '%1' has been modified. Save changes?").arg(shader_id));

  // Open the file.
  model = std::unique_ptr<ShaderModel>(new ShaderModel(quest, shader_id, this));
  get_undo_stack().setClean();

  // Prepare the GUI.
  ui.description_field->setAttribute(Qt::WA_LayoutUsesWidgetRect);
  ui.vertex_file_check_box->setAttribute(Qt::WA_LayoutUsesWidgetRect);
  ui.vertex_file_field->setAttribute(Qt::WA_LayoutUsesWidgetRect);
  ui.vertex_file_browse_button->setAttribute(Qt::WA_LayoutUsesWidgetRect);
  ui.vertex_file_edit_button->setAttribute(Qt::WA_LayoutUsesWidgetRect);
  ui.fragment_file_check_box->setAttribute(Qt::WA_LayoutUsesWidgetRect);
  ui.fragment_file_field->setAttribute(Qt::WA_LayoutUsesWidgetRect);
  ui.fragment_file_browse_button->setAttribute(Qt::WA_LayoutUsesWidgetRect);
  ui.fragment_file_edit_button->setAttribute(Qt::WA_LayoutUsesWidgetRect);
  ui.shader_properties_layout->setAlignment(ui.vertex_file_check_box, Qt::AlignVCenter);
  ui.shader_properties_layout->setAlignment(ui.fragment_file_check_box, Qt::AlignVCenter);
  const int side_width = 300;
  ui.splitter->setSizes({ side_width, width() - side_width });
  update();

  // Make connections.
  connect(&get_database(), &QuestDatabase::element_description_changed,
          this, &ShaderEditor::update_description_to_gui);
  connect(ui.description_field, &QLineEdit::editingFinished,
          this, &ShaderEditor::set_description_from_gui);

}

/**
 * @brief Destructor.
 */
ShaderEditor::~ShaderEditor() {

}


/**
 * @brief Returns the shader model being edited.
 * @return The shader model.
 */
ShaderModel& ShaderEditor::get_model() {
  return *model;
}

/**
 * @copydoc Editor::save
 */
void ShaderEditor::save() {

  model->save();
}

/**
 * @brief Updates everything in the GUI.
 */
void ShaderEditor::update() {

  update_shader_id_field();
  update_description_to_gui();
  update_vertex_file_field();
  update_fragment_file_field();
}

/**
 * @brief Updates the shader id displaying.
 */
void ShaderEditor::update_shader_id_field() {

  ui.shader_id_field->setText(shader_id);
}

/**
 * @brief Updates the content of the shader description text edit.
 */
void ShaderEditor::update_description_to_gui() {

  QString description = get_database().get_description(ResourceType::SHADER, shader_id);
  if (ui.description_field->text() != description) {
    ui.description_field->setText(description);
  }
}

/**
 * @brief Modifies the shader description in the quest database with
 * the new text entered by the user.
 *
 * If the new description is invalid, an error dialog is shown.
 */
void ShaderEditor::set_description_from_gui() {

  QString description = ui.description_field->text();
  if (description == get_database().get_description(ResourceType::SHADER, shader_id)) {
    return;
  }

  if (description.isEmpty()) {
    GuiTools::error_dialog(tr("Invalid description"));
    update_description_to_gui();
    return;
  }

  const bool was_blocked = blockSignals(true);
  try {
    get_database().set_description(ResourceType::SHADER, shader_id, description);
    get_database().save();
  }
  catch (const EditorException& ex) {
    ex.print_message();
  }
  update_description_to_gui();
  blockSignals(was_blocked);
}

/**
 * @brief Updates the vertex file field from the data.
 */
void ShaderEditor::update_vertex_file_field() {

  if (model == nullptr) {
    return;
  }
  const QString& vertex_file = model->get_vertex_file();
  ui.vertex_file_field->setText(vertex_file);
  ui.vertex_file_check_box->setChecked(!vertex_file.isEmpty());
  ui.vertex_file_field->setEnabled(!vertex_file.isEmpty());
  ui.vertex_file_edit_button->setEnabled(!vertex_file.isEmpty());
}

/**
 * @brief Updates the fragment file field from the data.
 */
void ShaderEditor::update_fragment_file_field() {

  if (model == nullptr) {
    return;
  }
  const QString& fragment_file = model->get_fragment_file();
  ui.fragment_file_field->setText(fragment_file);
  ui.fragment_file_check_box->setChecked(!fragment_file.isEmpty());
  ui.fragment_file_field->setEnabled(!fragment_file.isEmpty());
  ui.fragment_file_edit_button->setEnabled(!fragment_file.isEmpty());
}

}
