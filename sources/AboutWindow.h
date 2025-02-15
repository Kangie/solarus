// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <QDialog>

namespace solarus::launcher {
class AboutWindow : public QDialog {
  Q_OBJECT

public:
  explicit AboutWindow(QWidget* parent = nullptr);
  virtual ~AboutWindow() = default;

private:
  void setupUi();

private:
};
} // namespace solarus::launcher
