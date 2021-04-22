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
#ifndef SOLARUSEDITOR_NEW_QUEST_DIALOG_H
#define SOLARUSEDITOR_NEW_QUEST_DIALOG_H

#include "ui_new_quest_dialog.h"
#include "ui_new_quest_dialog_contents_page.h"
#include "ui_new_quest_dialog_directory_page.h"
#include "ui_new_quest_dialog_name_page.h"
#include "new_quest_builder.h"
#include <QWizard>

namespace SolarusEditor {

using NewQuestMode = NewQuestBuilder::NewQuestMode;

/**
 * @brief A dialog used to create a new quest in the editor.
 */
class NewQuestDialog final : public QWizard {

public:

  explicit NewQuestDialog(
    const QString& directory = QString(),
    QWidget* parent = nullptr,
    Qt::WindowFlags flags = Qt::WindowFlags());

  NewQuestMode get_new_quest_mode() const;
  QString get_quest_directory() const;
  QString get_quest_name() const;

private:

  Ui::NewQuestDialog ui; ///< The widgets.
};

/**
 * @brief New quest dialog page that asks for the name of the quest.
 */
class NewQuestDialogNamePage : public QWizardPage {

public:

  explicit NewQuestDialogNamePage(QWidget* parent = nullptr);

private:

  Ui::NewQuestDialogNamePage ui;
};

/**
 * @brief New quest dialog page that asks for the quest directory.
 */
class NewQuestDialogDirectoryPage : public QWizardPage {
  Q_OBJECT

public:

  explicit NewQuestDialogDirectoryPage(
    const QString& directory,
    QWidget* parent = nullptr);

  void initializePage() override;
  bool validatePage() override;
  bool isComplete() const override;

private slots:

  void browse_directories();
  void update_is_complete();

private:

  Ui::NewQuestDialogDirectoryPage ui;

  const QString directory;
};

/**
 * @brief New quest dialog page that asks for the initial quest contents.
 */
class NewQuestDialogContentsPage : public QWizardPage {

public:

  explicit NewQuestDialogContentsPage(QWidget* parent = nullptr);

private:

  Ui::NewQuestDialogContentsPage ui;
};

}

#endif
