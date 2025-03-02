// SPDX-License-Identifier: GPL-3.0-or-later
#include <Controller.h>

#include <Preferences.h>
#include <quests/QuestRunner.h>
#include <quests/QuestListModel.h>
#include <widgets/MessageBox.h>
#include <widgets/PreferencesWindow.h>
#include <Utils.h>
#include <BasicUpdater.h>

#include <oclero/qlementine/style/QlementineStyle.hpp>
#include <oclero/qlementine/style/ThemeManager.hpp>
#include <oclero/qlementine/widgets/AboutDialog.hpp>

#include <QTimer>
#include <QStandardPaths>
#include <QFileDialog>
#include <QApplication>
#include <QDesktopServices>

namespace solarus::launcher {
namespace i18n {
static QString addQuest() {
  return QApplication::translate("SolarusLauncher", "Add Quest");
}
static QString addQuestFolder() {
  return QApplication::translate("SolarusLauncher", "Add Quest Folder");
}
static QString questRemovalConfirmation() {
  return QApplication::translate("SolarusLauncher", "Do you want to remove this Solarus Quest?");
}
static QString questRemovalDescription() {
  return QApplication::translate(
    "SolarusLauncher", "The quest will be removed from Solarus Launcher index, but will be kept on disk.");
}
static QString aboutWindowTitle(const QString& appName) {
  return QApplication::translate("SolarusLauncher", "About %1").arg(appName);
}
static QString allRightsReserved() {
  return QApplication::translate("SolarusLauncher", "All rights reserved.");
}
static QString appDescription() {
  return QApplication::translate("SolarusLauncher", "A graphical user interface to launch and manage Solarus quests.");
}
static QString license() {
  return QApplication::translate("SolarusLauncher", "Licensed under GPL v3 and CC-BY-SA 4.0.");
}
static QString solarusQuests() {
  return QApplication::translate("SolarusLauncher", "Solarus Quests");
}
} // namespace i18n

Controller::Controller(QObject* parent)
  : QObject(parent)
  , _preferences(new Preferences(this))
  , _model(new QuestListModel(this))
  , _runner(new QuestRunner(this))
  , _updater(new BasicUpdater(this)) {
  setupThemeManager();
  // TMP
  _model->addQuestFolder("/Users/oclero/Documents/Solarus/Quests");
}

void Controller::setupThemeManager() {
  auto* qlementine = qobject_cast<oclero::qlementine::QlementineStyle*>(qApp->style());
  _themeManager = new oclero::qlementine::ThemeManager(qlementine, this);
  _themeManager->loadDirectory(":/solarus/launcher/resources/themes");

  const auto theme = _preferences->appTheme();
  _themeManager->setCurrentTheme(theme);

  QObject::connect(_preferences, &Preferences::appThemeChanged, this, [this]() {
    const auto theme = _preferences->appTheme();
    _themeManager->setCurrentTheme(theme);
  });
  QObject::connect(_themeManager, &oclero::qlementine::ThemeManager::currentThemeChanged, this, [this]() {
    const auto theme = _themeManager->currentTheme();
    _preferences->setAppTheme(theme);
  });
}

void Controller::openAddQuestDialog() {
  QTimer::singleShot(0, this, [this]() {
    const auto defaultDir = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    const auto filePath = QFileDialog::getOpenFileName(
      qApp->activeWindow(), i18n::addQuest(), defaultDir, QString("%1 (*.solarus)").arg(i18n::solarusQuests()));
    if (!filePath.isEmpty()) {
      _model->addQuest(filePath);
    }
  });
}

void Controller::openAddFolderDialog() {
  QTimer::singleShot(0, this, [this]() {
    const auto defaultDir = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    const auto dirPath = QFileDialog::getExistingDirectory(qApp->activeWindow(), i18n::addQuestFolder(), defaultDir);
    if (!dirPath.isEmpty()) {
      _model->addQuestFolder(dirPath);
    }
  });
}

void Controller::removeQuest(const QModelIndex& index) {
  if (index.isValid()) {
    const auto questFilePath = _model->questFilePath(index);
    auto* msgBox = new MessageBox(qApp->activeWindow());
    msgBox->setType(MessageBox::Type::Warning);
    msgBox->setTitle(i18n::questRemovalConfirmation());
    msgBox->setText(i18n::questRemovalDescription() + QString("<br/><br/><b>%1</b>").arg(questFilePath));
    msgBox->setButtons(MessageBox::Button::Cancel | MessageBox::Button::Yes);
    msgBox->setButtonIcon(MessageBox::Button::Yes, makeIcon(Icons16::Action_Trash));
    QObject::connect(msgBox, &MessageBox::finished, this, [this, questFilePath](int result) {
      const auto button = MessageBox::buttonResult(result);
      if (button == MessageBox::Yes) {
        _model->removeQuest(questFilePath);
      }
    });
    msgBox->show();
  }
}

void Controller::removeCurrentQuest() {
  const auto index = _model->currentQuest();
  removeQuest(index);
}

void Controller::playQuest(const QModelIndex& index) {
  if (index.isValid()) {
    const auto questFilePath = _model->questFilePath(index);
    _runner->start(questFilePath);
  }
}

void Controller::playCurrentQuest() {
  const auto index = _model->currentQuest();
  playQuest(index);
}

void Controller::openQuestFolder(const QModelIndex& index) {
  if (index.isValid()) {
    const auto questFilePath = _model->questFilePath(index);
    const auto questFileInfo = QFileInfo(questFilePath);
    const auto questDirUrl = QUrl::fromLocalFile(questFileInfo.absoluteDir().absolutePath());
    QDesktopServices::openUrl(questDirUrl);
  }
}

void Controller::openCurrentQuestFolder() {
  const auto index = _model->currentQuest();
  openQuestFolder(index);
}

void Controller::openPreferencesDialog() {
  auto* window = new PreferencesWindow(this, qApp->activeWindow());
  window->show();
}

void Controller::openAboutDialog() {
  auto* dialog = new oclero::qlementine::AboutDialog(qApp->activeWindow());
  dialog->setWindowTitle(i18n::aboutWindowTitle(QApplication::applicationDisplayName()));
  dialog->setWebsiteUrl(PROJECT_HOMEPAGE_URL);
  dialog->setDescription(i18n::appDescription());
  dialog->setLicense(i18n::license());
  dialog->setCopyright(QString("%1 %2").arg(PROJECT_APP_COPYRIGHT, i18n::allRightsReserved()));
  for (const auto [tooltip, url, icon] : {
         std::make_tuple("X", PROJECT_LINKS_X, Icons16::Brand_X),
         std::make_tuple("Mastodon", PROJECT_LINKS_MASTODON, Icons16::Brand_MastodonFill),
         std::make_tuple("YouTube", PROJECT_LINKS_YOUTUBE, Icons16::Brand_YoutubeFill),
         std::make_tuple("GitLab", PROJECT_LINKS_SOURCE_CODE, Icons16::Brand_GitlabFill),
       }) {
    dialog->addSocialMediaLink(tooltip, url, makeIcon(icon));
  }
  dialog->show();
}

void Controller::playStopQuest() {
  if (_runner->state() == QuestRunner::State::Stopped) {
    const auto index = _model->currentQuest();
    if (index.isValid()) {
      const auto questFilePath = _model->questFilePath(index);
      _runner->start(questFilePath);
    }
  } else {
    _runner->stop();
  }
}

void Controller::openContactPage() {
  QDesktopServices::openUrl(QUrl(PROJECT_LINKS_CONTACT));
}

void Controller::openSourceCodePage() {
  QDesktopServices::openUrl(QUrl(PROJECT_LINKS_SOURCE_CODE));
}

void Controller::checkForUpdates() {
  _updater->checkForUpdates("https://gitlab.com/api/v4/projects/6933864/releases/v1.1.2"
    //"https://gitlab.com/api/v4/projects/6933864/releases/permalink/latest",
    //PROJECT_LINKS_UPDATE_ENDPOINT
  );
}

Preferences* Controller::preferences() {
  return _preferences;
}

QuestListModel* Controller::model() {
  return _model;
}

QuestRunner* Controller::runner() {
  return _runner;
}

BasicUpdater* Controller::updater() {
  return _updater;
}

oclero::qlementine::ThemeManager* Controller::themeManager() {
  return _themeManager;
}
} // namespace solarus::launcher
