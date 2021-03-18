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
#include "editor_exception.h"
#include "file_tools.h"
#include "new_quest_mode_traits.h"
#include <QFile>
#include <QFileDialog>

namespace SolarusEditor {

/**
 * @brief Constructor for the NewQuestDialog.
 */
NewQuestDialog::NewQuestDialog(
    const QString& directory,
    QWidget* parent) :
  QDialog(parent) {

  ui.setupUi(this);

  set_directory(directory);
  update_path();
  update_error();

  connect(ui.directory_browse_button, &QPushButton::clicked,
          this, &NewQuestDialog::browse_directories);
  connect(ui.directory_line_edit, &QLineEdit::textChanged,
          this, &NewQuestDialog::update_path);
  connect(ui.file_line_edit, &QLineEdit::textChanged,
          this, &NewQuestDialog::update_path);
  connect(ui.directory_line_edit, &QLineEdit::textChanged,
          this, &NewQuestDialog::update_error);
  connect(ui.file_line_edit, &QLineEdit::textChanged,
          this, &NewQuestDialog::update_error);
  connect(ui.name_line_edit, &QLineEdit::textEdited,
          this, &NewQuestDialog::update_file);
  connect(ui.file_line_edit, &QLineEdit::textEdited,
          this, &NewQuestDialog::desync_file);

  ui.path_value->installEventFilter(this);
}

/**
 * @brief Get the NewQuestMode set by the user.
 */
NewQuestMode NewQuestDialog::get_new_quest_mode() const {

  if (ui.cr_button->isChecked()) {
    return NewQuestMode::COPY_INITIAL_QUEST;
  } else if (ui.bq_button->isChecked()) {
    return NewQuestMode::BLANK_QUEST;
  } else {
    throw EditorException(QApplication::tr(
        "New quest dialog got into a bad state."));
  }
}

/**
 * @brief Get the path name of the quest.
 */
QString NewQuestDialog::get_quest_path() const {

  return ui.path_value->text();
}

/**
 * @brief Get the name of the quest the user has entered.
 */
QString NewQuestDialog::get_quest_name() const {

  return ui.name_line_edit->text();
}

/**
 * @brief Filter an event for an object that this is an event-filter for.
 *
 * Do not use this, its set-up to filter events for an internal object.
 * @param watched The object whose events are being filtered.
 * @param event The event that might be filtered.
 * @return Wheither the event should be filtered out or not.
 */
bool NewQuestDialog::eventFilter(QObject* watched, QEvent* event) {

  if (QEvent::Resize == event->type()) {
    update_path();
  }

  return QDialog::eventFilter(watched, event);
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
void NewQuestDialog::update_path() {

  QDir directory(get_directory());
  const QString& path = directory.absoluteFilePath(get_file());
  GuiTools::set_elided_text(*ui.path_value, path, Qt::ElideMiddle);
}

/**
 * @brief Check for errors and display a description of one found.
 */
void NewQuestDialog::update_error() {

  const QString& error_message = check_for_errors();
  ui.warning_value->setText(error_message);
  QPushButton * ok = ui.buttonBox->button(QDialogButtonBox::Ok);
  ok->setEnabled(error_message.isEmpty());
}

/**
 * @brief Use the quest name to update the file name.
 */
void NewQuestDialog::update_file() {

  ui.file_line_edit->setText(FileTools::to_file_name(get_quest_name()));
}

/**
 * @brief Stop auto-updating the file name based on the quest name.
 */
void NewQuestDialog::desync_file() {

  disconnect(ui.name_line_edit, &QLineEdit::textEdited,
             this, &NewQuestDialog::update_file);
  disconnect(ui.file_line_edit, &QLineEdit::textEdited,
             this, &NewQuestDialog::desync_file);
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
 * @brief Get the name of the quest file (a directory).
 */
QString NewQuestDialog::get_file() const {

  return ui.file_line_edit->text();
}

/**
 * @brief Set the file name.
 * @param file The new value for the file name.
 */
void NewQuestDialog::set_file(const QString& file) {

  ui.file_line_edit->setText(file);
}

/**
 * @brief Check if a new quest could be created with the current settings.
 * @return A string describing why a quest could not be created or an empty
 *   string if one could be.
 */
QString NewQuestDialog::check_for_errors() const {

  if (!QFile::exists(get_directory())) {
    return QApplication::tr("Cannot create a quest in missing directory.");
  }
  if (get_quest_name().isEmpty()) {
    return QApplication::tr("Cannot create an empty quest name.");
  }
  const QString& quest_path = get_quest_path();
  if (QFile::exists(quest_path)
      && QFile::exists(quest_path + QStringLiteral("/data"))) {
    return QApplication::tr("Cannot create an existing quest.");
  }
  return QString();
}

}
