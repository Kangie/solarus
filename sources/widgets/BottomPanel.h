// SPDX-License-Identifier: GPL-3.0-or-later
#include <QWidget>
#include <QPointer>

namespace solarus::launcher {
class Console;
class Controller;

class BottomPanel : public QWidget {
  Q_OBJECT

public:
  explicit BottomPanel(Controller* controller, QWidget* parent = nullptr);
  virtual ~BottomPanel() = default;

private:
  void setupUi();

private:
  QPointer<Controller> _controller;
  struct {
    Console* console{ nullptr };
  } _ui;
};
} // namespace solarus::launcher
