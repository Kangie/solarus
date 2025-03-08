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
#include <QTranslator>

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
static QString themeName(const QString themeId) {
  if (themeId == "Dark") {
    return QApplication::translate("SolarusLauncher", "Dark");
  } else if (themeId == "Light") {
    return QApplication::translate("SolarusLauncher", "Light");
  } else {
    return themeId;
  }
}
} // namespace i18n

namespace {
QString findBestLanguage(const QString& desiredLanguage, const QStringList& availableLanguages) {
  if (availableLanguages.size() > 0) {
    if (!desiredLanguage.isEmpty()) {
      for (const auto& lang : {
             // User's language in settings.
             desiredLanguage,
             // User's system language.
             QLocale().name(),
             // Fallback to English (US).
             QLocale(QLocale::English, QLocale::UnitedStates).name(),
           }) {
        const auto index = availableLanguages.indexOf(desiredLanguage);
        if (index != -1) {
          return desiredLanguage;
        }
      }
    }

    // Fallback: use first available language.
    return availableLanguages.front();
  }

  return QString{};
}
} // namespace

Controller::Controller(QObject* parent)
  : QObject(parent)
  , _preferences(new Preferences(this))
  , _model(new QuestListModel(this))
  , _runner(new QuestRunner(this))
  , _updater(new BasicUpdater(this)) {
  setupThemeManager();
  loadLanguages();

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

void Controller::loadLanguages() {
  constexpr auto sourceDirPath = ":/i18n/";
  constexpr auto fileName = "solarus-launcher";
  constexpr auto separator = "_";

  constexpr auto filterFlags = QDir::Filter::NoDotAndDotDot | QDir::Filter::Files | QDir::Filter::Readable;
  constexpr auto sortFlags = QDir::SortFlag::Name;
  const auto sourceDirectory = QDir(sourceDirPath);
  const auto filePrefix = QString(fileName) + separator;
  const auto entries = sourceDirectory.entryInfoList({ QStringLiteral("*.qm") }, filterFlags, sortFlags);
  for (const auto& entry : std::as_const(entries)) {
    if (!entry.baseName().startsWith(QStringLiteral("qt"))) {
      const auto baseName = entry.baseName();
      const auto hasPrefix = !filePrefix.isEmpty() && baseName.startsWith(filePrefix);
      const auto& languageName = hasPrefix ? baseName.mid(filePrefix.length()) : baseName;
      _languages.append(languageName);
    }
  }

  // Find best language.
  const auto userLang = findBestLanguage(_preferences->appLanguage(), _languages);
  _translator = new QTranslator(this);
  if (_translator->load(QLocale(userLang), sourceDirectory.absolutePath() + "/" + fileName, separator, sourceDirPath)) {
    qApp->installTranslator(_translator);
  }

  // const auto locale = QLocale::system();
  // QLocale::setDefault(locale);
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
  _updater->checkForUpdates(PROJECT_LINKS_UPDATE_ENDPOINT);
}

const QStringList& Controller::languages() const {
  return _languages;
}

QString Controller::themeName(const QString& themeId) {
  return i18n::themeName(themeId);
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
