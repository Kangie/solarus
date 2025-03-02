// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <QStatusBar>
#include <QPointer>

class QPushButton;
class QLabel;

namespace solarus::launcher {
class Controller;

class StatusBar : public QStatusBar {
  Q_OBJECT

public:
  explicit StatusBar(Controller* controller, QWidget* parent = nullptr);
  virtual ~StatusBar() = default;

private:
  void setupUi();

private:
  QPointer<Controller> _controller;
  struct {
    QPushButton* updateButton;
    QLabel* questCountLabel;
  } _ui;
};
} // namespace solarus::launcher
