// SPDX-License-Identifier: GPL-3.0-or-later

#include <QApplication>

#include <oclero/qlementine.hpp>
#include <oclero/qlementine/icons/QlementineIcons.hpp>

#include "MainWindow.h"

#include <solarus/core/Arguments.h>
#include <solarus/core/Debug.h>
#include <solarus/core/MainLoop.h>

#include <string>
#include <iostream>

int runGUI(int argc, char* argv[]) {
  QGuiApplication::setApplicationName("Solarus Launcher");
  QGuiApplication::setApplicationDisplayName("Solarus Launcher");
  QGuiApplication::setOrganizationName("Solarus Labs");
  QGuiApplication::setOrganizationDomain("solarus-games.org");
  QGuiApplication::setApplicationVersion("2.0.0");
  QGuiApplication::setDesktopFileName("Solarus Launcher");

  QApplication app(argc, argv);
  app.setQuitOnLastWindowClosed(true);
  solarus::launcher::MainWindow::setAppIcon();

  // Custom style that supports theming.
  auto* style = new oclero::qlementine::QlementineStyle(&app);
  style->setAnimationsEnabled(true);
  style->setAutoIconColor(oclero::qlementine::AutoIconColor::TextColor);
  style->setIconPathGetter(oclero::qlementine::icons::fromFreeDesktop);
  QApplication::setStyle(style);

  // Custom icon theme.
  oclero::qlementine::icons::initializeIconTheme();
  QIcon::setThemeName("qlementine");

  // Qlementine theme manager.
  auto window = std::make_unique<solarus::launcher::MainWindow>();
  window->show();

  return app.exec();
}

int runCLI(int argc, char* argv[]) {
  Solarus::Debug::set_abort_on_die(true);
  Solarus::Debug::set_show_popup_on_die(false);

  // Run the Solarus main loop.
  const Solarus::Arguments args(argc, argv);
  Solarus::MainLoop(args).run();

  return EXIT_SUCCESS;
}

int printHelp(int argc, char* argv[]) {
  const auto binary_name = std::string{ (argc > 0) ? argv[0] : "solarus-launcher" };
  std::cout << "Usage:\n" << binary_name << " [--version] [--help] [<path/to/quest.solarus>]" << std::endl;
  return EXIT_SUCCESS;
}

int main(int argc, char** argv) {
  if (argc > 1) {
    const auto arg1 = std::string{ argv[1] };
    if (arg1 == "--help" || arg1 == "-h") {
      return printHelp(argc, argv);
    } else if (arg1 == "--version" || arg1 == "-v") {
      std::cout << "2.0.0" << std::endl;
      return EXIT_SUCCESS;
    } else {
      return runCLI(argc, argv);
    }
  } else {
    return runGUI(argc, argv);
  }
}
