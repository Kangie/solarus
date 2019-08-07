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
#ifndef SOLARUSEDITOR_ABOUT_DIALOG_H
#define SOLARUSEDITOR_ABOUT_DIALOG_H

#include "ui_about_dialog.h"
#include <QDialog>

namespace SolarusEditor {

namespace Ui {
class AboutDialog;
}

/**
 * @brief Dialog for information about the application.
 *
 * This dialog shows the application name, version, description, and
 */
class AboutDialog : public QDialog {
  Q_OBJECT

public:

  explicit AboutDialog(QWidget* parent = nullptr);

private:

  Ui::AboutDialog ui;     /**< The widgets. */
};

}

#endif
