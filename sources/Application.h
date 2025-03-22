// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <QApplication>

#include <oclero/QtAppInstanceManager.hpp>
#include <widgets/MainWindow.h>

#include <memory>

namespace oclero::qlementine {
class QlementineStyle;
}

namespace solarus::launcher {
class Controller;

// Must be done before creating a QApplication.
void configureQApplication();

class Application : public QApplication {
  Q_OBJECT

public:
  Application(int& argc, char** argv);
  ~Application() = default;

protected:
  bool event(QEvent* event) override;

private:
  oclero::QtAppInstanceManager _instanceManager{};
  oclero::qlementine::QlementineStyle* _style{ nullptr };
  Controller* _controller{ nullptr };
  std::unique_ptr<MainWindow> _mainWindow{ nullptr };
};
} // namespace solarus::launcher
