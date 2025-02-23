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
#include "editor_exception.h"
#include "file_tools.h"
#include <QFile>
#include <QFileDialog>
#include <QMessageBox>

namespace SolarusEditor {

/**
 * @brief Constructor for the NewQuestDialog.
 * @param directory The default parent directory for the new quest.
 */
NewQuestDialog::NewQuestDialog(
    const QString& directory,
    QWidget* parent,
    Qt::WindowFlags flags) :
  QWizard(parent, flags) {

  ui.setupUi(this);

  addPage(new NewQuestDialogTitlePage);
  addPage(new NewQuestDialogDirectoryPage(directory));
  addPage(new NewQuestDialogContentsPage);
}

/**
 * @brief Get the path name of the quest.
 */
QString NewQuestDialog::get_quest_directory() const {

  return field("quest_directory").toString();
}

/**
 * @brief Get the title of the quest the user has entered.
 */
QString NewQuestDialog::get_quest_title() const {

  return field("quest_title").toString();
}

/**
 * @brief Get the NewQuestMode set by the user.
 */
NewQuestMode NewQuestDialog::get_new_quest_mode() const {

  if (field("use_community_resources").toBool()) {
    return NewQuestMode::COPY_INITIAL_QUEST;
  } else {
    return NewQuestMode::BLANK_QUEST;
  }
}

/**
 * @brief Constructor for the NewQuestDialogTitlePage.
 */
NewQuestDialogTitlePage::NewQuestDialogTitlePage(QWidget* parent) :
  QWizardPage(parent) {

  ui.setupUi(this);

  registerField("quest_title*", ui.quest_title_edit);
}

/**
 * @brief Constructor for the NewQuestDialogDirectoryPage.
 * @param directory The default parent directory for the new quest.
 */
NewQuestDialogDirectoryPage::NewQuestDialogDirectoryPage(
    const QString& directory,
    QWidget* parent) :
  QWizardPage(parent), directory(directory) {

  ui.setupUi(this);

  registerField("quest_directory", ui.quest_directory_edit);

  connect(ui.browse_button, &QPushButton::clicked,
          this, &NewQuestDialogDirectoryPage::browse_directories);
  connect(ui.quest_directory_edit, &QLineEdit::textChanged,
          this, &NewQuestDialogDirectoryPage::update_is_complete);
}

/**
 * @brief Ready the page when it is switched to.
 */
void NewQuestDialogDirectoryPage::initializePage() {

  QDir parent_dir(directory);
  QString quest_name = field("quest_title").toString();
  QString quest_file = FileTools::to_file_name(quest_name);
  QString quest_path = parent_dir.absoluteFilePath(quest_file);
  ui.quest_directory_edit->setText(quest_path);
}

/**
 * @brief Called when the user tries to complete this page.
 */
bool NewQuestDialogDirectoryPage::validatePage() {

  QDir quest_directory(field("quest_directory").toString());
  if (quest_directory.exists() && !quest_directory.isEmpty()) {
    QMessageBox confirm(
      QMessageBox::Warning,
      tr("Directory not empty"),
      tr("The quest directory is not empty, are you sure you wish to continue?"),
      QMessageBox::Ok | QMessageBox::Cancel,
      nullptr
    );
    int standard_button = confirm.exec();
    return (standard_button == QMessageBox::Ok);
  }
  return true;
}

/**
 * @brief See if the page can be completed in its current state.
 */
bool NewQuestDialogDirectoryPage::isComplete() const {

  return ui.error_label->text().isEmpty();
}

/**
 * @brief Use a file dialog to select a new directory.
 */
void NewQuestDialogDirectoryPage::browse_directories() {

  const QString& quest_path = QFileDialog::getExistingDirectory(
      this,
      tr("Select quest directory"),
      ui.quest_directory_edit->text(),
#ifdef SOLARUSEDITOR_NO_NATIVE_DIALOGS
      QFileDialog::ShowDirsOnly | QFileDialog::DontUseNativeDialog);
#else
      QFileDialog::ShowDirsOnly);
#endif

  if (quest_path.isEmpty()) {
    return;
  }

  ui.quest_directory_edit->setText(quest_path);
}

/**
 * @brief Update the status of isComplete and the error message.
 */
void NewQuestDialogDirectoryPage::update_is_complete() {

  QDir quest_dir(ui.quest_directory_edit->text());
  if (quest_dir.exists()) {
    if (quest_dir.exists(QStringLiteral("data"))) {
      ui.error_label->setText(tr("A quest already exists in this directory."));
    } else {
      ui.error_label->setText("");
    }
  } else {
    if (!quest_dir.cdUp()) {
      ui.error_label->setText(tr("Parent directory does not exist."));
    } else {
      ui.error_label->setText("");
    }
  }
  emit completeChanged();
}

/**
 * @brief Constructor for the NewQuestDialogContentsPage.
 */
NewQuestDialogContentsPage::NewQuestDialogContentsPage(QWidget* parent) :
  QWizardPage(parent) {

  ui.setupUi(this);

  registerField("use_community_resources", ui.cr_button);
}

}
