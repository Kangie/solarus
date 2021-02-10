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
#include <QDialog>

namespace SolarusEditor {

using NewQuestMode = NewQuestBuilder::NewQuestMode;

/**
 * @brief A dialog used to create a new quest in the editor.
 */
class NewQuestDialog final : public QDialog {
  Q_OBJECT

public:

  explicit NewQuestDialog(
    const QString& directory = QString(),
    QWidget* parent = nullptr);

  QString get_quest_path() const;
  NewQuestMode get_new_quest_mode() const;

public slots:

  void done(int result) override;

private slots:

  void browse_directories();
  void set_description_label(int index);

private:

  QString get_directory() const;
  void set_directory(const QString& directory);
  QString get_quest_name() const;

  Ui::NewQuestDialog ui; ///< The widgets.

};

}

#endif
