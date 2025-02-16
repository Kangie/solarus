// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <QDialog>

namespace oclero::qlementine {
class ThemeManager;
} // namespace oclero::qlementine

namespace solarus::launcher {
class Preferences;

class PreferencesWindow : public QDialog {
  Q_OBJECT

public:
  explicit PreferencesWindow(
    Preferences& preferences, oclero::qlementine::ThemeManager& themeManager, QWidget* parent = nullptr);
  virtual ~PreferencesWindow() = default;

private:
  void setupUi();

  Preferences& _preferences;
  oclero::qlementine::ThemeManager& _themeManager;
};
} // namespace solarus::launcher
