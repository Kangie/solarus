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
#include <QOpenGLVertexArrayObject>
#include <QOpenGLFramebufferObject>
#include <QOpenGLTexture>
#include <QOpenGLWidget>
#include <QFileSystemWatcher>
#include <QMatrix4x4>

class QLabel;  // TODO remove

namespace SolarusEditor {

class ShaderModel;

/**
 * @brief A widget to preview shaders.
 */
class ShaderPreviewer : public QOpenGLWidget {
  Q_OBJECT

public:

  ShaderPreviewer(QWidget* parent = nullptr);

  void set_model(ShaderModel* model);

  ShaderPreviewMode get_preview_mode() const;
  void set_preview_mode(ShaderPreviewMode preview_mode);
  void setup_framebuffers(const QSize& output_size);

  void render_swipe(float factor);

  void set_preview_image(QImage image);

  //Opengl events
  virtual void paintGL() override;
  virtual void initializeGL() override;
  virtual void resizeGL(int w, int h) override;

public slots:
 void on_source_changed();
 void on_vertex_file_changed(const QString& filename);
 void on_fragment_file_changed(const QString &filename);

private:
  QOpenGLFramebufferObject* input_fb; /**< Framebuffer to chich the input is drawn */
  QOpenGLFramebufferObject* output_fb;/**< Framebuffer to which the output is drawn */
  QOpenGLVertexArrayObject* quad;     /**< quad array */
  QOpenGLTexture* input_texture;      /**< Texture of the input*/
  QPointer<ShaderModel> model;        /**< The shader model. */
  ShaderPreviewMode preview_mode;     /**< Display mode of the preview. */
  QFileSystemWatcher* source_watcher; /**< Watcher to catch source modifications */
  QMatrix4x4 ortho;                   /**< */
  QMatrix4x4 view;
};

}

#endif
