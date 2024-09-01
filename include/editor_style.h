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
 * @brief Possible theme choices for the editor.
 */
enum class Theme {
  AUTOMATIC,  /**< Detect automatically from OS settings. */
  LIGHT,      /**< Light mode. */
  DARK        /**< Dark mode. */
};

/**
 * @brief A Qlementine theme plus some Solarus Editor specific info.
 */
struct ThemeInfo {
  Theme theme;                  /**< A theme. */
  QString path;                 /**< Path of the JSON file for this theme. */

  // Text editor colors.
  QColor lua_keyword_color;     /**< Syntax color for Lua keywords. */
  QColor literal_string_color;  /**< Syntax color for literal strings. */
  QColor comment_color;         /**< Syntax color for comments. */
  QColor current_line_background_color;
                                /**< Color for the current line background. */
};

/**
 * @brief Qt style of Solarus Editor.
 */
class EditorStyle: public QlementineStyle {
  Q_OBJECT

public:
  using AutoIconColor = oclero::qlementine::AutoIconColor;

  explicit EditorStyle(QObject* parent = nullptr);

  Theme get_theme() const;
  void set_theme(Theme theme);
  Theme get_actual_theme() const;
  static const ThemeInfo& get_theme_info();

  static Theme get_os_theme();

signals:
  void actual_theme_changed(Theme theme);

private:
  Theme theme = Theme::AUTOMATIC;         /**< Theme selected by the user. */
  Theme actual_theme = Theme::AUTOMATIC;  /**< Automatic replaced by the final one. */
};

}  // namespace Solarus Editor
