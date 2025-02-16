// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <QWidget>

class QListView;
class QToolBar;
class QToolButton;
class QStatusBar;
class QLabel;
class QMenuBar;
class QAction;

namespace oclero::qlementine {
class LineEdit;
class Switch;
class ThemeManager;
class Label;
class Expander;
} // namespace oclero::qlementine

namespace solarus::launcher {
class QuestListModel;
class QuestRunner;
class QuestPropertiesPanel;

class MainWindow : public QWidget {
  Q_OBJECT

public:
  explicit MainWindow(QWidget* parent = nullptr);
  virtual ~MainWindow() = default;

  static void setAppIcon();

private:
  void setupThemeManager();
  void setupUi();
  void setupMenuBar();
  void openAddQuestDialog();
  void openAddFolderDialog();

private:
  QuestListModel* _model;
  QuestRunner* _runner;
  struct {
    QMenuBar* menuBar{ nullptr };
    QToolBar* toolBar{ nullptr };
    QToolButton* addQuestButton{ nullptr };
    QToolButton* removeQuestButton{ nullptr };
    QToolButton* playStopQuestButton{ nullptr };
    QToolButton* togglePanelButton{ nullptr };
    oclero::qlementine::LineEdit* searchLineEdit{ nullptr };
    oclero::qlementine::Switch* themeSwitch{ nullptr };
    QListView* listView{ nullptr };
    QStatusBar* statusBar{ nullptr };
    oclero::qlementine::Label* questCountLabel{ nullptr };
    QuestPropertiesPanel* propertiesPanel{ nullptr };
    oclero::qlementine::Expander* propertiesPanelExpander{ nullptr };
  } _ui;
  oclero::qlementine::ThemeManager* _themeManager{ nullptr };
};
} // namespace solarus::launcher
