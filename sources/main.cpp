// SPDX-License-Identifier: GPL-3.0-or-later
#include <Application.h>

#include <solarus/core/Arguments.h>
#include <solarus/core/Debug.h>
#include <solarus/core/MainLoop.h>

#include <string>
#include <iostream>

int runGUI(int argc, char* argv[]) {
  // Run the QApplication event loop.
  solarus::launcher::configureQApplication();
  solarus::launcher::Application app(argc, argv);

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

int printVersion() {
  std::cout << PROJECT_VERSION << std::endl;
  return EXIT_SUCCESS;
}

int main(int argc, char** argv) {
  if (argc > 1) {
    const auto arg1 = std::string{ argv[1] };
    if (arg1 == "--help" || arg1 == "-h") {
      return printHelp(argc, argv);
    } else if (arg1 == "--version" || arg1 == "-v") {
      return printVersion();
    } else {
      return runCLI(argc, argv);
    }
  } else {
    return runGUI(argc, argv);
  }
}
