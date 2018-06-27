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
#include "solarus/graphics/VertexArray.h"
#include "quest.h"

#include <QLabel>  // TODO remove

namespace SolarusEditor {

/**
 * @brief Creates a shader previewer.
 * @param parent The parent object or nullptr.
 */
ShaderPreviewer::ShaderPreviewer(QWidget *parent) :
  QOpenGLWidget(parent),
  program(this),
  model(nullptr),
  preview_mode(ShaderPreviewMode::SIDE_BY_SIDE)
{

  //test_label->setText("Preview");
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
    connect(model,&ShaderModel::fragment_file_changed,this,&ShaderPreviewer::on_fragment_file_changed);
    connect(model,&ShaderModel::vertex_file_changed,this,&ShaderPreviewer::on_vertex_file_changed);

    //setup_framebuffers(model->);
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
}

void ShaderPreviewer::setup_framebuffers(const QSize& output_size) {
  makeCurrent();
  if(input_fb){
    delete input_fb;
  }
  if(output_fb) {
    delete output_fb;
  }
  input_fb = new QOpenGLFramebufferObject(model->get_quest().get_properties().get_normal_quest_size());
  output_fb = new QOpenGLFramebufferObject(output_size);
}

void ShaderPreviewer::render_fbs() {

}

void ShaderPreviewer::render_swipe(float factor) {

}

void ShaderPreviewer::paintGL() {
  switch (preview_mode) {
  case ShaderPreviewMode::INPUT:
    render_swipe(1.f);
    break;
  case ShaderPreviewMode::OUTPUT:
    render_swipe(0.f);
    break;
  case ShaderPreviewMode::SIDE_BY_SIDE:
    break;
  case ShaderPreviewMode::SWIPE:
    render_swipe(0.5f); //TODO pass actual factor
    break;
  default:
    break;
  }
}

void ShaderPreviewer::initializeGL() {
  //Setup quad
  vertex_buffer = new QOpenGLBuffer();
  if(!vertex_buffer->create()) {
    qDebug() << "Failed to create glbuffer!"; //TODO fail gracefully
  }
  Solarus::VertexArray array;
  array.add_quad(Solarus::Rectangle(0,0,1,1),
                 Solarus::Rectangle(0,1,1,-1),
                 Solarus::Color::white);
  vertex_buffer->allocate(array.data(),array.vertex_count()*sizeof(Solarus::Vertex));
}

void ShaderPreviewer::resizeGL(int w, int h) {

}

void ShaderPreviewer::on_source_changed() {
  //program.addShaderFromSourceCode()
}

void ShaderPreviewer::on_vertex_file_changed(const QString &filename) {

}

void ShaderPreviewer::on_fragment_file_changed(const QString &filename) {

}

/**
 * @brief Changes the image to be displayed in the preview widget.
 * @param image The new image to show.
 */
void ShaderPreviewer::set_preview_image(QImage image) {
  // TODO
}

}
