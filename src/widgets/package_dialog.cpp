#include "include/widgets/package_dialog.h"
#include "ui_package_dialog.h"

PackageDialog::PackageDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::PackageDialog)
{
    ui->setupUi(this);
}

PackageDialog::~PackageDialog()
{
    delete ui;
}
