// SPDX-License-Identifier: GPL-3.0-or-later

#include <QApplication>

#include <oclero/qlementine.hpp>
#include <oclero/qlementine/icons/QlementineIcons.hpp>

#include "MainWindow.h"

#include <QIcon>

void setAppIcon() {
  static constexpr std::array<QIcon::Mode, 4> modes{
    QIcon::Mode::Normal,
    QIcon::Mode::Disabled,
    QIcon::Mode::Active,
    QIcon::Mode::Selected,
  };
  static constexpr std::array<int, 12> dimensions{ 16, 20, 24, 32, 40, 48, 64, 96, 128, 256, 512, 1024 };
  static constexpr const char* path_base(":/solarus/launcher/resources/icon/solarus_launcher_icon_");
  static constexpr const char* path_ext(".png");

  QIcon app_icon;
  for (const auto dimension : dimensions) {
    const auto path = path_base + QString::number(dimension) + path_ext;
    QPixmap pixmap(path);
    for (const auto mode : modes) {
      app_icon.addPixmap(pixmap, mode, QIcon::State::On);
      app_icon.addPixmap(pixmap, mode, QIcon::State::Off);
    }
  }
  QGuiApplication::setWindowIcon(app_icon);
}

int main(int argc, char* argv[]) {
  QGuiApplication::setApplicationName("Solarus Launcher");
  QGuiApplication::setApplicationDisplayName("Solarus Launcher");
  QGuiApplication::setOrganizationName("Solarus Labs");
  QGuiApplication::setOrganizationDomain("solarus-games.org");
  QGuiApplication::setApplicationVersion("2.0.0");
  QGuiApplication::setDesktopFileName("Solarus Launcher");

  QApplication app(argc, argv);
  app.setQuitOnLastWindowClosed(true);
  setAppIcon();

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
