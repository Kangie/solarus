// SPDX-License-Identifier: GPL-3.0-or-later
#include <widgets/StatusBar.h>

#include <quests/QuestListModel.h>
#include <Utils.h>
#include <BasicUpdater.h>
#include <Controller.h>

#include <QApplication>
#include <QPushButton>
#include <QHBoxLayout>
#include <QLabel>
#include <QDesktopServices>

#include <oclero/qlementine/widgets/IconWidget.hpp>

namespace solarus::launcher {
namespace i18n {
static QString noQuestFound() {
  return QApplication::translate("SolarusLauncher", "No Quest added");
}
static QString questsFound(int count) {
  return QApplication::translate("SolarusLauncher", "%n Quest(s) added", "", count);
}
static QString updateAvailable() {
  return QApplication::translate("SolarusLauncher", "Update Available");
}
static QString noUpdateAvailable() {
  return QApplication::translate("SolarusLauncher", "No Update Available");
}
static QString versionComparison() {
  return QApplication::translate("SolarusLauncher", "You have %1, %2 is available.");
}
static QString checkingForUpdates() {
  return QApplication::translate("SolarusLauncher", "Checking for updates…");
}
static QString failedToCheckMessage(int errorCode) {
  return QApplication::translate("SolarusLauncher", "Failed to check for updates. Error code: %1").arg(errorCode);
}
} // namespace i18n

StatusBar::StatusBar(Controller* controller, QWidget* parent)
  : QStatusBar(parent)
  , _controller(controller) {
  setupUi();
}

void StatusBar::setupUi() {
  setFixedHeight(28);
  setSizeGripEnabled(false);
  setContentsMargins(16, 0, 16, 0);
  {
    _ui.updateButton = new QPushButton(this);
    {
      _ui.updateButton->setText(i18n::updateAvailable());
      _ui.updateButton->setAutoDefault(false);
      _ui.updateButton->setDefault(true);
      _ui.updateButton->setFixedHeight(20);
      _ui.updateButton->setIcon(makeIcon(Icons16::Action_Update));
      _ui.updateButton->setVisible(false);
    }

    QObject::connect(_controller->updater(), &BasicUpdater::checkStarted, this, [this]() {
      _ui.updateButton->setVisible(false);
      clearMessage();
      showMessage(i18n::checkingForUpdates(), 0);
      _ui.updateButton->disconnect();
    });

    QObject::connect(
      _controller->updater(), &BasicUpdater::checkFinished, this, [this](const BasicUpdater::Result& result) {
        clearMessage();

        switch (result.status) {
          case BasicUpdater::Status::UpdateAvailable:
            _ui.updateButton->setVisible(true);
            _ui.updateButton->setToolTip(i18n::versionComparison().arg(result.currentVersion, result.newVersion));
            QObject::connect(_ui.updateButton, &QPushButton::clicked, this, [this, result]() {
              QDesktopServices::openUrl(result.newVersionDownloadUrl);
            });
            break;
          case BasicUpdater::Status::NoUpdate:
            _ui.updateButton->setVisible(false);
            showMessage(i18n::noUpdateAvailable(), 3000);
            break;
          case BasicUpdater::Status::Error:
            _ui.updateButton->setVisible(false);
            showMessage(i18n::failedToCheckMessage(result.errorCode), 3000);
            break;
          default:
            break;
        }
      });

    auto* questCountContainer = new QWidget(this);
    {
      questCountContainer->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
      auto* questCountLayout = new QHBoxLayout(questCountContainer);
      questCountLayout->setContentsMargins(0, 0, 0, 0);
      questCountLayout->setSpacing(8);

      auto* iconWidget = new oclero::qlementine::IconWidget(questCountContainer);
      {
        const auto updateIcon = [this, iconWidget]() {
          const auto count = _controller->model()->rowCount({});
          iconWidget->setIcon(makeIcon(count > 0 ? Icons16::Misc_Library : Icons16::Misc_Warning));
        };
        updateIcon();
        QObject::connect(_controller->model(), &QuestListModel::rowCountChanged, this, updateIcon);
      }
      questCountLayout->addWidget(iconWidget);

      auto* questCountLabel = new QLabel(this);
      {
        questCountLabel->setText(i18n::noQuestFound());
        questCountLabel->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);

        const auto updateText = [this, questCountLabel]() {
          const auto count = _controller->model()->rowCount({});
          questCountLabel->setText(count > 0 ? i18n::questsFound(count) : i18n::noQuestFound());
        };
        updateText();
        QObject::connect(_controller->model(), &QuestListModel::rowCountChanged, this, updateText);
      }
      questCountLayout->addWidget(questCountLabel);

      if (const auto* qlementine = qobject_cast<oclero::qlementine::QlementineStyle*>(style())) {
        const auto updatePalette = [qlementine, iconWidget, questCountLabel]() {
          const auto palette = qlementine->paletteForTextRole(oclero::qlementine::TextRole::Caption);
          iconWidget->setPalette(palette);
          questCountLabel->setPalette(palette);
        };
        updatePalette();
        QObject::connect(qlementine, &oclero::qlementine::QlementineStyle::themeChanged, this, [updatePalette]() {
          updatePalette();
        });
      }
    }

    addPermanentWidget(_ui.updateButton);
    addWidget(questCountContainer);
  }
}
} // namespace solarus::launcher
