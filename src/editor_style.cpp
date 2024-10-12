#include "editor_settings.h"
#include "editor_style.h"
#include <map>
#include <QApplication>

namespace SolarusEditor {

namespace {

const std::map<Mode, ModeInfo> mode_info = {
    {
        Mode::LIGHT,
        {
            Mode::LIGHT,
            ":/themes/light.json",
            Qt::darkRed,                      // Lua keyword.
            Qt::blue,                         // Literal string.
            Qt::darkGreen,                    // Comment.
            QColor(Qt::yellow).lighter(160),  // Current line.
            QColor("#909090"),                // Debug log text.
            QColor("#0000ff"),                // Info log text.
            QColor("#b05000"),                // Warning log text.
            Qt::red,                          // Error log text.
        }
    },
    {
        Mode::DARK,
        {
            Mode::DARK,
            ":/themes/dark.json",
            QColor(255, 128, 128),  // Lua keyword.
            Qt::cyan,               // Literal string.
            QColor(128, 255, 128),  // Comment.
            QColor(64, 64, 0),      // Current line.
            QColor("#909090"),      // Debug log text.
            QColor("#4ab9e9"),      // Info log text.
            QColor("#ffcd1e"),      // Warning log text.
            QColor("#ef5151"),      // Error log text.
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
  Mode mode = Mode::AUTOMATIC;
  if (theme_name == "light") {
    mode = Mode::LIGHT;
  } else if (theme_name == "dark") {
    mode = Mode::DARK;
  }
  set_mode(mode);
}

/**
 * @brief Returns the current mode of the editor.
 * @return The current mode (possibly @c Mode::AUTOMATIC).
 */
Mode EditorStyle::get_mode() const {
  return mode;
}

/**
 * @brief Sets the mode of the editor.
 * @param mode The mode to set (possibly @c Mode::AUTOMATIC).
 */
void EditorStyle::set_mode(Mode mode) {
  this->mode = mode;

  Mode actual_mode = (mode == Mode::AUTOMATIC) ? get_os_mode() : mode;
  if (actual_mode != this->actual_mode) {
    this->actual_mode = actual_mode;
    setThemeJsonPath(mode_info.at(actual_mode).path);
    emit actual_mode_changed(actual_mode);
  }
}

/**
 * @brief Returns the final mode, i.e. with automatic replaced by the actual one.
 * @return The actual mode.
 */
Mode EditorStyle::get_actual_mode() const {
  return actual_mode;
}

/**
 * @brief Returns details of the actual current mode.
 */
const ModeInfo& EditorStyle::get_mode_info() {
  const EditorStyle* style = qobject_cast<const EditorStyle*>(qApp->style());
  if (style == nullptr) {
    return mode_info.at(Mode::LIGHT);
  }
  return mode_info.at(style->get_actual_mode());
}

/**
 * @brief Returns the light or dark mode setting from the operating system.
 * @return @c Mode::LIGHT or @c Mode::DARK.
 */
Mode EditorStyle::get_os_mode() {

  // TODO Qt6 return QGuiApplication::styleHints()->colorScheme() == Qt::ColorScheme::Dark ? Theme::DARK : Theme::LIGHT;
  return Mode::DARK;
}

}  // namespace Solarus Editor
