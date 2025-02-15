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
} // namespace oclero::qlementine

namespace solarus::launcher {
class QuestListModel;

class MainWindow : public QWidget {
  Q_OBJECT

public:
  explicit MainWindow(QWidget* parent = nullptr);
  virtual ~MainWindow() = default;

private:
  void setupThemeManager();
  void setupUi();
  void setupMenuBar();
  void setTheme(const QString& theme);

private:
  QuestListModel* _model;
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
    QLabel* questCountLabel{ nullptr };
  } _ui;
  oclero::qlementine::ThemeManager* _themeManager{ nullptr };
};
} // namespace solarus::launcher
