#include "editor_settings.h"
#include "editor_style.h"
#include <map>
#include <QGuiApplication>

namespace SolarusEditor {

struct ThemeInfo {
  Theme theme;   /**< A theme. */
  QString path;  /**< Path of the JSON file for this theme. */
};

namespace {

const std::map<Theme, ThemeInfo> themeInfo = {
  { Theme::LIGHT, { Theme::LIGHT, ":/themes/light.json" } },
  { Theme::DARK, { Theme::DARK, ":/themes/dark.json" } },
};

}  // Anonymous namespace.

/**
 * \brief Creates a style for the editor.
 * \param parent Parent object or \c nullptr.
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
 * \brief Returns the current theme of the editor.
 * \return The current theme (possibly \c Theme::AUTOMATIC).
 */
Theme EditorStyle::get_theme() const {
  return theme;
}

/**
 * \brief Sets the theme of the editor.
 * \param theme The theme to set (possibly \c Theme::AUTOMATIC).
 */
void EditorStyle::set_theme(Theme theme) {
  this->theme = theme;

  Theme actual_theme = (theme == Theme::AUTOMATIC) ? get_os_theme() : theme;
  if (actual_theme != this->actual_theme) {
    this->actual_theme = actual_theme;
    setThemeJsonPath(themeInfo.at(actual_theme).path);
  }
}

/**
 * \brief Returns the light or dark mode setting from the operating system.
 * \return \c Theme::LIGHT or \c Theme::DARK.
 */
Theme EditorStyle::get_os_theme() {

  // TODO Qt6 return QGuiApplication::styleHints()->colorScheme() == Qt::ColorScheme::Dark ? Theme::DARK : Theme::LIGHT;
  return Theme::DARK;
}


}  // namespace Solarus Editor
