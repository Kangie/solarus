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
#include "widgets/shader_previewer.h"
#include "shader_model.h"

namespace SolarusEditor {

/**
 * @brief Creates a shader previewer.
 * @param parent The parent object or nullptr.
 */
ShaderPreviewer::ShaderPreviewer(QWidget *parent) :
  QWidget(parent),
  model(nullptr),
  preview_mode(ShaderPreviewMode::SIDE_BY_SIDE) {

}

/**
 * @brief Sets the shader model.
 * @param model The shader model, or nullptr to remove any model.
 * This class does not take ownership on the model.
 * The model can be deleted safely.
 */
void ShaderPreviewer::set_model(ShaderModel* model) {

  if (this->model != nullptr) {
    this->model->disconnect(this);
    this->model = nullptr;
  }

  this->model = model;

  if (model != nullptr) {
    // TODO set up any connections to the model here.
  }
}

/**
 * @brief Returns the current preview mode.
 * @return The preview mode.
 */
ShaderPreviewMode ShaderPreviewer::get_preview_mode() const {
  return preview_mode;
}

/**
 * @brief Changes the preview mode.
 * @param preview_mode The new mode to set.
 */
void ShaderPreviewer::set_preview_mode(ShaderPreviewMode preview_mode) {
  this->preview_mode = preview_mode;
  // TODO
}

}
