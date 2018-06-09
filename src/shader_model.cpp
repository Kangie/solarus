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
#include "editor_exception.h"
#include "quest.h"
#include "shader_model.h"

namespace SolarusEditor {

/**
 * @brief Creates a shader model.
 * @param quest The quest.
 * @param shader_id Id of the shader to represent
 * @param parent Parent object or nullptr.
 */
ShaderModel::ShaderModel(
    const Quest& quest,
    const QString& shader_id,
    QObject* parent) :
  QObject(parent),
  quest(quest),
  shader_id(shader_id) {

}

/**
 * @brief Saves the sprite to its data file.
 * @throws EditorException If the file could not be saved.
 */
void ShaderModel::save() const {

  QString path = quest.get_sprite_path(shader_id);

  if (!shader.export_to_file(path.toStdString())) {
    throw EditorException(tr("Cannot save shader '%1'").arg(path));
  }
}

}
