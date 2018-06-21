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
#ifndef SOLARUSEDITOR_SHADER_PREVIEWER_H
#define SOLARUSEDITOR_SHADER_PREVIEWER_H

#include "shader_preview_mode.h"
#include <QPointer>
#include <QWidget>

namespace SolarusEditor {

class ShaderModel;

/**
 * @brief A widget to preview shaders.
 */
class ShaderPreviewer : public QWidget {
  Q_OBJECT

public:

  ShaderPreviewer(QWidget* parent = nullptr);

  void set_model(ShaderModel* model);

  ShaderPreviewMode get_preview_mode() const;
  void set_preview_mode(ShaderPreviewMode preview_mode);

private:

  QPointer<ShaderModel> model;     /**< The shader model. */
  ShaderPreviewMode preview_mode;  /**< Display mode of the preview. */

};

}

#endif
