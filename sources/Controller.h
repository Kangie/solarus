// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <QObject>
#include <QStringList>

class QTranslator;

namespace oclero::qlementine {
class ThemeManager;
} // namespace oclero::qlementine

namespace solarus::launcher {
class Preferences;
class QuestListModel;
class QuestRunner;
class BasicUpdater;

class Controller : public QObject {
  Q_OBJECT

public:
  explicit Controller(QObject* parent = nullptr);
  virtual ~Controller() = default;

  void openAddQuestDialog();
  void openAddFolderDialog();
  void openPreferencesDialog();
  void openAboutDialog();
  void openContactPage();
  void openSourceCodePage();
  void openQuestPropertiesPanel();

  void removeQuest(const QModelIndex& index);
  void removeCurrentQuest();

  void playQuest(const QModelIndex& index);
  void playCurrentQuest();
  void playStopQuest();

  void openQuestFolder(const QModelIndex& index);
  void openCurrentQuestFolder();

  void checkForUpdates();

  const QStringList& languages() const;
  static QString themeName(const QString& themeName);

  Q_SIGNAL void focusOnListViewRequested(Qt::FocusReason reason);

  Preferences* preferences();
  QuestListModel* model();
  QuestRunner* runner();
  BasicUpdater* updater();
  oclero::qlementine::ThemeManager* themeManager();

private:
  void setupThemeManager();
  void loadLanguages();

private:
  Preferences* _preferences{ nullptr };
  QuestListModel* _model{ nullptr };
  QuestRunner* _runner{ nullptr };
  BasicUpdater* _updater{ nullptr };
  oclero::qlementine::ThemeManager* _themeManager{ nullptr };
  QStringList _languages;
  QTranslator* _translator;
};
} // namespace solarus::launcher
