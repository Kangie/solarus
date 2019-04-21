/*
 * Copyright (C) 2014-2019 Christopho, Solarus - http://www.solarus-games.org
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
#ifndef SOLARUSEDITOR_PACKAGE_DIALOG_H
#define SOLARUSEDITOR_PACKAGE_DIALOG_H

#include <QDialog>
#include <QProcess>
#include <QString>

namespace Ui {
class PackageDialog;
}

namespace SolarusEditor {

class Quest;

class PackageDialog : public QDialog
{
    Q_OBJECT

public:
    explicit PackageDialog(Quest const& quest, QWidget *parent = 0);
    ~PackageDialog();

private slots:
    void setAutoClose(int new_auto_close);
    void setSavePath(QString const& save_path);
    void startProcess();
    void processFinished(int code, QProcess::ExitStatus status);
    void startFileSelection();
    void handleProcessStandardOutput();

private:
    ::Ui::PackageDialog *ui;
    QProcess process;
    Quest const& quest;
    QString save_path;
    bool auto_close;
};

}

#endif // SOLARUSEDITOR_PACKAGE_DIALOG_H
