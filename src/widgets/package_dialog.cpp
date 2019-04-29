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
#include "widgets/package_dialog.h"
#include "quest.h"
#include "ui_package_dialog.h"

#include <QFileDialog>

/* In terms of implementation, this class wraps for states and handles the
 * transitions
 *
 * 0. selection: Choose the package location and name.
 *    You can cancel the operation (close) or go ahead to 1.
 * 1. ongoing: Tells you the operation is in progress.
 *    You can cancel the operation, it goes to 2 on success
 * 2. complete: Just a little message and a close button.
 *    Optionally there is an auto-close feature.
 * 3. failed: The packaging failed, error message should be displayed.
 *    After looking at the message close the dialog.
 *
 * For simplicity we use the widget pointers instead of the index to refer to
 * them. (Except that we start at index 0: selection.)
 */

namespace SolarusEditor {

PackageDialog::PackageDialog(Quest const& quest, QWidget *parent) :
    QDialog(parent),
    ui(new Ui::PackageDialog),
    process(),
    quest(quest),
    save_path(),
    auto_close(false)
{
    ui->setupUi(this);
    process.setReadChannel(QProcess::StandardOutput);

    connect(ui->selection_ok, &QPushButton::clicked,
            this, &PackageDialog::processStart);
    connect(ui->selection_auto, &QCheckBox::stateChanged,
            this, &PackageDialog::setAutoClose);
    connect(ui->selection_browse, &QPushButton::clicked,
            this, &PackageDialog::startFileSelection);
    connect(&process,
            QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, &PackageDialog::processFinished);
    connect(&process, &QProcess::readyReadStandardOutput,
            this, &PackageDialog::handleProcessStandardOutput);

    setSavePath(quest.get_root_path() + "/" + quest.get_name() + ".solarus");
}

PackageDialog::~PackageDialog()
{
    delete ui;
}

void PackageDialog::setAutoClose(int new_auto_close)
{
    auto_close = new_auto_close;
}

void PackageDialog::setSavePath(QString const& new_save_path)
{
    save_path = new_save_path;
    ui->selection_file->setText(save_path);
}

void PackageDialog::processStart()
{
    QString const& root_path = quest.get_root_path();
    QString relative_path = quest.get_data_path().remove(root_path + "/");

    process.setWorkingDirectory(root_path);
    process.start("zip", QStringList() << "-r" << save_path << relative_path);

    ui->stackedWidget->setCurrentWidget(ui->ongoing);
    ui->ongoing_output->setPlainText(tr("Starting...\n"));
}

void PackageDialog::processFinished(int code, QProcess::ExitStatus status)
{
    if (QProcess::CrashExit == status || 0 != code) {
        ui->failed_output->setPlainText(
            QString(process.readAllStandardError()));
        ui->failed_code->setText(
            QProcess::CrashExit == status
                ? tr("Crashed") : QString::number(code));
        ui->stackedWidget->setCurrentWidget(ui->failed);
    } else if (auto_close) {
        close();
    } else {
        ui->stackedWidget->setCurrentWidget(ui->completed);
    }
}

void PackageDialog::startFileSelection()
{
    setSavePath(QFileDialog::getSaveFileName(
        this, tr("Solarus Package Location:"), save_path,
        tr("Solarus Packages (*.solarus)")));
}

void PackageDialog::handleProcessStandardOutput()
{
    while (process.canReadLine()) {
        QByteArray const& line = process.readLine();
        ui->ongoing_output->moveCursor(QTextCursor::End);
        ui->ongoing_output->insertPlainText(QString(line));
    }
}

}
