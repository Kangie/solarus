/*
 * Copyright (C) 2014-2018 Christopho, Solarus - http://www.solarus-games.org
 *
 * Solarus Quest Editor is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Solarus Quest Editor is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include "widgets/about_dialog.h"
#include "widgets/gui_tools.h"
#include "dialogs_model.h"

#include <QApplication>
#include <QDesktopServices>

namespace SolarusEditor {

/**
 * @brief Creates an about dialog.
 * @param parent Parent object or nullptr.
 */
AboutDialog::AboutDialog(QWidget* parent) : QDialog(parent) {

  ui.setupUi(this);

  // App display name
  const auto app_display_name = QApplication::applicationDisplayName();
  setWindowTitle(tr("About %0").arg(app_display_name));
  ui.name_label->setText(app_display_name);

  // App version
  ui.version_label->setText(QApplication::applicationVersion());
}

/**
 * @brief Destructor for an about dialog.
 */
AboutDialog::~AboutDialog() {

}

void AboutDialog::on_website_label_linkActivated(const QString &link) {

  QDesktopServices::openUrl(QUrl(link));
}

void AboutDialog::on_license_label_linkActivated(const QString &link) {

  QDesktopServices::openUrl(QUrl(link));
}
}
