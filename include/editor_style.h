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
 * Qlementine theme for the editor.
 */
enum class Theme {
  AUTOMATIC,  /**< Detect automatically from OS settings. */
  LIGHT,      /**< Light mode. */
  DARK        /**< Dark mode. */
};

/**
 * \brief Qt style of Solarus Editor.
 */
class EditorStyle: public QlementineStyle {
  Q_OBJECT

public:
  using AutoIconColor = oclero::qlementine::AutoIconColor;

  explicit EditorStyle(QObject *parent = nullptr);

  Theme get_theme() const;
  void set_theme(Theme theme);

  static Theme get_os_theme();

private:
  Theme theme = Theme::AUTOMATIC;  /**< Theme selected by the user. */
  Theme actual_theme = Theme::AUTOMATIC;  /**< Actual: automatic replaced by the real one. */
};

}  // namespace Solarus Editor
