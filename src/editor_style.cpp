#include "editor_settings.h"
#include "editor_style.h"
#include <map>
#include <QApplication>

namespace SolarusEditor {

namespace {

const std::map<Theme, ThemeInfo> theme_info = {
    {
        Theme::LIGHT,
        {
            Theme::LIGHT,
            ":/themes/light.json",
            Qt::darkRed,                     // Lua keyword.
            Qt::blue,                        // Literal string.
            Qt::darkGreen,                   // Comment.
            QColor(Qt::yellow).lighter(160)  // Current line.
        }
    },
    {
        Theme::DARK,
        {
            Theme::DARK,
            ":/themes/dark.json",
            QColor(255, 128, 128),  // Lua keyword.
            Qt::cyan,               // Literal string.
            QColor(128, 255, 128),  // Comment.
            QColor(64, 64, 0)       // Current line.
        }
    },
};

}  // Anonymous namespace.

/**
 * @brief Creates a style for the editor.
 * @param parent Parent object or @c nullptr.
 */
EditorStyle::EditorStyle(QObject *parent):
  QlementineStyle(parent) {

  EditorSettings settings;
  const QString& theme_name = settings.get_value_string(EditorSettings::theme);
  Theme theme = Theme::AUTOMATIC;
  if (theme_name == "light") {
    theme = Theme::LIGHT;
  } else if (theme_name == "dark") {
    theme = Theme::DARK;
  }
  set_theme(theme);
}

/**
 * @brief Returns the current theme of the editor.
 * @return The current theme (possibly @c Theme::AUTOMATIC).
 */
Theme EditorStyle::get_theme() const {
  return theme;
}

/**
 * @brief Sets the theme of the editor.
 * @param theme The theme to set (possibly @c Theme::AUTOMATIC).
 */
void EditorStyle::set_theme(Theme theme) {
  this->theme = theme;

  Theme actual_theme = (theme == Theme::AUTOMATIC) ? get_os_theme() : theme;
  if (actual_theme != this->actual_theme) {
    this->actual_theme = actual_theme;
    setThemeJsonPath(theme_info.at(actual_theme).path);
    emit actual_theme_changed(theme);
  }
}

/**
 * @brief Returns the final theme, i.e. with automatic replaced by the actual one.
 * @return The actual theme.
 */
Theme EditorStyle::get_actual_theme() const {
  return actual_theme;
}

/**
 * @brief Returns details of the actual current theme.
 */
const ThemeInfo& EditorStyle::get_theme_info() {
  const EditorStyle* style = qobject_cast<const EditorStyle*>(qApp->style());
  if (style == nullptr) {
    return theme_info.at(Theme::LIGHT);
  }
  return theme_info.at(style->get_actual_theme());
}

/**
 * @brief Returns the light or dark mode setting from the operating system.
 * @return @c Theme::LIGHT or @c Theme::DARK.
 */
Theme EditorStyle::get_os_theme() {

  // TODO Qt6 return QGuiApplication::styleHints()->colorScheme() == Qt::ColorScheme::Dark ? Theme::DARK : Theme::LIGHT;
  return Theme::DARK;
}


}  // namespace Solarus Editor
