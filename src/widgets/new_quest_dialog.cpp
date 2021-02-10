/*
 * Copyright (C) 2020-2021 Christopho, Solarus - http://www.solarus-games.org
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
#include "widgets/new_quest_dialog.h"
#include "widgets/gui_tools.h"
#include "new_quest_mode_traits.h"
#include <QFile>
#include <QFileDialog>

namespace SolarusEditor {

/**
 * @brief Constructor for the NewQuestDialog.
 */
NewQuestDialog::NewQuestDialog(
    const QString& directory,
    QWidget* parent
    /*Qt::WindowFlags f = Qt::WindowFlags()*/) :
  QDialog(parent) {

  ui.setupUi(this);

  set_directory(directory);
  set_description_label(ui.initial_combo_box->currentIndex());

  connect(ui.directory_browse_button, &QPushButton::clicked,
          this, &NewQuestDialog::browse_directories);
  connect(ui.initial_combo_box, SIGNAL(currentIndexChanged(int)),
          this, SLOT(set_description_label(int)));
}


/**
 * @brief Get the path name of the quest.
 */
QString NewQuestDialog::get_quest_path() const {

  QDir directory(get_directory());
  return directory.absoluteFilePath(get_quest_name());
}

/**
 * @brief Get the NewQuestMode set by the user.
 */
NewQuestMode NewQuestDialog::get_new_quest_mode() const {

  return ui.initial_combo_box->get_selected_value();
}

/**
 * @brief Closes the dialog if the quest path appears to be valid.
 * @param result Result code of the dialog.
 */
void NewQuestDialog::done(int result) {

  if (result == QDialog::Accepted) {
    if (!QFile::exists(get_directory())) {
      GuiTools::error_dialog("Cannot create a quest in missing directory.");
      return;
    }
    if (get_quest_name().isEmpty()) {
      GuiTools::error_dialog("Cannot create an empty quest name.");
      return;
    }
    // Is there a helper for the data directory?
    const QString& quest_path = get_quest_path();
    if (QFile::exists(quest_path) && QFile::exists(quest_path + "/data")) {
      GuiTools::error_dialog("Cannot create an existing quest.");
      return;
    }
  }

  QDialog::done(result);
}

/**
 * @brief Use a file dialog to select a new directory.
 */
void NewQuestDialog::browse_directories() {

  const QString& quest_path = QFileDialog::getExistingDirectory(
      this,
      tr("Select quest directory"),
      get_directory(),
      QFileDialog::ShowDirsOnly);

  if (quest_path.isEmpty()) {
    return;
  }

  set_directory(quest_path);
}


/**
 * @brief Change the description to describe the option at index.
 */
void NewQuestDialog::set_description_label(int index) {

  ui.description_label->setText(
    NewQuestModeTraits::get_description(NewQuestMode(index)));
}

/**
 * @brief Get the name of the directory the quest will be in.
 *
 * Note that this above the quest directory so a path to the data directory
 * is "<directory>/<quest-name>/data".
 */
QString NewQuestDialog::get_directory() const {

  return ui.directory_line_edit->text();
}

/**
 * @brief Set the name of the directory the quest will be in.
 * @param directory The new value for the directory.
 *
 * See get_directory for details.
 */
void NewQuestDialog::set_directory(const QString& directory) {

  ui.directory_line_edit->setText(directory);
}

/**
 * @brief Get the name of the quest the user has entered.
 */
QString NewQuestDialog::get_quest_name() const {

  return ui.name_line_edit->text();
}

}
