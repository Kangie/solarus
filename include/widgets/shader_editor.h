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
#ifndef SOLARUSEDITOR_SHADER_EDITOR_H
#define SOLARUSEDITOR_SHADER_EDITOR_H

#include "widgets/editor.h"
#include "ui_shader_editor.h"

namespace SolarusEditor {

class ShaderModel;

/**
 * \brief A widget to edit graphically a shader description file.
 */
class ShaderEditor : public Editor {
  Q_OBJECT

public:

  ShaderEditor(Quest& quest, const QString& path, QWidget* parent = nullptr);
  ~ShaderEditor();

  ShaderModel& get_model();

  void save() override;

private:

  void update();
  void update_shader_id_field();
  void update_description_to_gui();
  void set_description_from_gui();
  void update_vertex_file_field();
  void update_fragment_file_field();

  Ui::ShaderEditor ui;          /**< The shader editor widgets. */
  QString shader_id;            /**< Id of the shader being edited. */
  std::unique_ptr<ShaderModel>
      model;                    /**< Shader model being edited. */
  Quest& quest;                 /**< The quest. */

};

}

#endif
