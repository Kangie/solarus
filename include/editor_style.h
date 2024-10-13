/*
 * Copyright (C) 2014-2024 Christopho, Solarus - http://www.solarus-games.org
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
#pragma once

#include <oclero/qlementine.hpp>

using oclero::qlementine::QlementineStyle;

namespace SolarusEditor {

/**
 * @brief Possible mode choices for the editor.
 */
enum class Mode {
  AUTOMATIC,  /**< Detect automatically from OS settings. */
  LIGHT,      /**< Light mode. */
  DARK        /**< Dark mode. */
};

/**
 * @brief A Qlementine theme plus some Solarus Editor specific info.
 */
struct ModeInfo {
  Mode mode;                    /**< A mode choice. */
  QString path;                 /**< Path of the JSON file for this theme. */

  // Text editor colors.
  QColor lua_keyword_color;     /**< Syntax color for Lua keywords. */
  QColor literal_string_color;  /**< Syntax color for literal strings. */
  QColor comment_color;         /**< Syntax color for comments. */
  QColor current_line_background_color;
                                /**< Color for the current line background. */
  QColor log_debug_color;       /**< Text color for debug log level. */
  QColor log_info_color;        /**< Text color for info log level. */
  QColor log_warning_color;     /**< Text color for warning log level. */
  QColor log_error_color;       /**< Text color for error log level. */
};

/**
 * @brief Qt style of Solarus Editor.
 */
class EditorStyle: public QlementineStyle {
  Q_OBJECT

public:
  using AutoIconColor = oclero::qlementine::AutoIconColor;
  using MouseState = oclero::qlementine::MouseState;
  using ColorRole = oclero::qlementine::ColorRole;
  using Status = oclero::qlementine::Status;

  explicit EditorStyle(QObject* parent = nullptr);

  Mode get_mode() const;
  void set_mode(Mode mode);
  Mode get_actual_mode() const;
  static const ModeInfo& get_mode_info();

  static Mode get_os_mode();

signals:
  void actual_mode_changed(Mode mode);

protected:
  Status widgetStatus(QWidget const* widget) const override;
  QColor const& textFieldBackgroundColor(MouseState const mouse, Status const status) const override;

private:
  Mode mode = Mode::AUTOMATIC;         /**< Theme selected by the user. */
  Mode actual_mode = Mode::AUTOMATIC;  /**< Automatic replaced by the final one. */
};

}  // namespace Solarus Editor
