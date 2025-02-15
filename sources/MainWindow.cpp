// SPDX-License-Identifier: GPL-3.0-or-later

#include "MainWindow.h"

#include "QuestListModel.h"
#include "QuestListItemDelegate.h"
#include "AboutWindow.h"
#include "Utils.h"

#include <QPushButton>
#include <QVBoxLayout>
#include <QWidget>
#include <QListView>
#include <QToolBar>
#include <QToolButton>
#include <QApplication>
#include <QMenu>
#include <QStatusBar>
#include <QLineEdit>
#include <QLabel>
#include <QMenuBar>
#include <QActionGroup>

#include <oclero/qlementine/icons/Icons16.hpp>
#include <oclero/qlementine.hpp>
#include <oclero/qlementine/widgets/LineEdit.hpp>
#include <oclero/qlementine/widgets/IconWidget.hpp>
#include <oclero/qlementine/widgets/Switch.hpp>
#include <oclero/qlementine/style/ThemeManager.hpp>
#include <oclero/qlementine/utils/WidgetUtils.hpp>

namespace solarus::launcher {
namespace i18n {
static QString addQuest() {
  return QApplication::translate("SolarusLauncher", "Add Quest");
}
static QString addQuestAction() {
  return QApplication::translate("SolarusLauncher", "Add Quest...");
}
static QString addQuestFolderAction() {
  return QApplication::translate("SolarusLauncher", "Add Quests from Folder...");
}
static QString removeQuest() {
  return QApplication::translate("SolarusLauncher", "Remove Quest");
}
static QString play() {
  return QApplication::translate("SolarusLauncher", "Play");
}
static QString stop() {
  return QApplication::translate("SolarusLauncher", "Stop");
}
static QString playQuest() {
  return QApplication::translate("SolarusLauncher", "Play Quest");
}
static QString stopQuest() {
  return QApplication::translate("SolarusLauncher", "Stop Quesr");
}
static QString showHideQuestInformation() {
  return QApplication::translate("SolarusLauncher", "Show/Hide quest Information");
}
static QString search() {
  return QApplication::translate("SolarusLauncher", "Search...");
}
static QString noQuestFound() {
  return QApplication::translate("SolarusLauncher", "No quest found");
}
static QString preferences() {
  return QApplication::translate("SolarusLauncher", "Preferences...");
}
static QString quit() {
  return QApplication::translate("SolarusLauncher", "Quit");
}
static QString fileMenu() {
  return QApplication::translate("SolarusLauncher", "File");
}
static QString viewMenu() {
  return QApplication::translate("SolarusLauncher", "View");
}
static QString helpMenu() {
  return QApplication::translate("SolarusLauncher", "Help");
}
static QString contact() {
  return QApplication::translate("SolarusLauncher", "Contact");
}
static QString about() {
  return QApplication::translate("SolarusLauncher", "About...");
}
static QString switchTheme() {
  return QApplication::translate("SolarusLauncher", "Switch Theme");
}
static QString theme() {
  return QApplication::translate("SolarusLauncher", "Theme");
}
static QString questMenu() {
  return QApplication::translate("SolarusLauncher", "Quest");
}
static QString showContaingFolder() {
  return QApplication::translate("SolarusLauncher", "Show Containing Folder...");
}
} // namespace i18n

MainWindow::MainWindow(QWidget* parent)
  : QWidget(parent) {
  setMinimumSize(600, 400);
  oclero::qlementine::centerWidget(this);
  ensurePolished();

  setupThemeManager();
  setWindowTitle("Solarus Launcher");
  setupMenuBar();
  setupUi();

  _model = new QuestListModel(this);
  _ui.listView->setModel(_model);
}

void MainWindow::setupThemeManager() {
  auto* qlementineStyle = qobject_cast<oclero::qlementine::QlementineStyle*>(style());
  _themeManager = new oclero::qlementine::ThemeManager(qlementineStyle, this);
  _themeManager->loadDirectory(":/solarus/launcher/resources/themes");
  _themeManager->setCurrentTheme("Dark");
}

void MainWindow::setupUi() {
  auto* windowLayout = new QVBoxLayout(this);
  windowLayout->setContentsMargins(0, 0, 0, 0);
  windowLayout->setSpacing(0);
  setLayout(windowLayout);

  _ui.toolBar = new QToolBar(this);
  {
    const auto defaultIconSize = style()->pixelMetric(QStyle::PM_SmallIconSize);
    _ui.toolBar->setAllowedAreas(Qt::ToolBarArea::TopToolBarArea);
    _ui.toolBar->setMovable(false);
    _ui.toolBar->setFloatable(false);
    _ui.toolBar->setIconSize(QSize(defaultIconSize, defaultIconSize));
    _ui.toolBar->setBackgroundRole(QPalette::ColorRole::Window);
    _ui.toolBar->setAutoFillBackground(false);
    _ui.toolBar->setToolButtonStyle(Qt::ToolButtonStyle::ToolButtonFollowStyle);

    _ui.addQuestButton = new QToolButton(_ui.toolBar);
    {
      _ui.addQuestButton->setText(i18n::addQuest());
      _ui.addQuestButton->setIcon(makeIcon(Icons16::Action_PlusCircle));
      _ui.addQuestButton->setToolTip(i18n::addQuest());
      _ui.addQuestButton->setCheckable(false);
      _ui.addQuestButton->setChecked(false);
      _ui.addQuestButton->setToolButtonStyle(Qt::ToolButtonStyle::ToolButtonTextBesideIcon);
      _ui.addQuestButton->setFocusPolicy(Qt::NoFocus);
      _ui.toolBar->addWidget(_ui.addQuestButton);

      {
        auto* subMenu = new QMenu(i18n::addQuest(), _ui.addQuestButton);
        _ui.addQuestButton->setMenu(subMenu);
        subMenu->addAction(makeIcon(Icons16::Action_PlusCircle), i18n::addQuestAction());
        subMenu->addAction(makeIcon(Icons16::Action_AddFolder), i18n::addQuestFolderAction());
        _ui.addQuestButton->setMenu(subMenu);
        _ui.addQuestButton->setPopupMode(QToolButton::ToolButtonPopupMode::MenuButtonPopup);
      }
    }

    _ui.removeQuestButton = new QToolButton(_ui.toolBar);
    {
      _ui.removeQuestButton->setText(i18n::removeQuest());
      _ui.removeQuestButton->setIcon(makeIcon(Icons16::Action_MinusCircle));
      _ui.removeQuestButton->setToolTip(i18n::removeQuest());
      _ui.removeQuestButton->setCheckable(false);
      _ui.removeQuestButton->setChecked(false);
      _ui.removeQuestButton->setToolButtonStyle(Qt::ToolButtonStyle::ToolButtonIconOnly);
      _ui.removeQuestButton->setFocusPolicy(Qt::NoFocus);
      _ui.toolBar->addWidget(_ui.removeQuestButton);
    }

    _ui.toolBar->addSeparator();

    _ui.playStopQuestButton = new QToolButton(_ui.toolBar);
    {
      _ui.playStopQuestButton->setText(i18n::play());
      _ui.playStopQuestButton->setIcon(makeIcon(Icons16::Media_Play));
      _ui.playStopQuestButton->setToolTip(i18n::playQuest());
      _ui.playStopQuestButton->setCheckable(false);
      _ui.playStopQuestButton->setChecked(false);
      _ui.playStopQuestButton->setToolButtonStyle(Qt::ToolButtonStyle::ToolButtonTextBesideIcon);
      _ui.playStopQuestButton->setFocusPolicy(Qt::NoFocus);
      _ui.toolBar->addWidget(_ui.playStopQuestButton);
    }

    // Spacer.
    auto* spacerWidget = new QWidget(_ui.toolBar);
    {
      spacerWidget->setAttribute(Qt::WA_TransparentForMouseEvents);
      spacerWidget->setMinimumSize(0, 0);
      spacerWidget->setSizePolicy(QSizePolicy::MinimumExpanding, QSizePolicy::Ignored);
      spacerWidget->setUpdatesEnabled(false); // No paint events.
      _ui.toolBar->addWidget(spacerWidget);
    }

    _ui.searchLineEdit = new oclero::qlementine::LineEdit(_ui.toolBar);
    {
      _ui.searchLineEdit->setPlaceholderText(i18n::search());
      _ui.searchLineEdit->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
      _ui.searchLineEdit->setFixedWidth(180);
      _ui.searchLineEdit->setClearButtonEnabled(true);
      _ui.searchLineEdit->setFocusPolicy(Qt::FocusPolicy::ClickFocus);
      _ui.searchLineEdit->setIcon(makeIcon(Icons16::Navigation_Search));
      _ui.toolBar->addWidget(_ui.searchLineEdit);
    }

    auto* themeWidget = new QWidget(_ui.toolBar);
    {
      themeWidget->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
      _ui.toolBar->addWidget(themeWidget);

      auto* themeLayout = new QHBoxLayout(themeWidget);
      themeLayout->setSpacing(4);
      themeLayout->setContentsMargins(8, 0, 8, 0);
      themeWidget->setLayout(themeLayout);

      auto* lightIconWidget = new oclero::qlementine::IconWidget(makeIcon(Icons16::Misc_Sun), themeWidget);
      auto* darkIconWidget = new oclero::qlementine::IconWidget(makeIcon(Icons16::Misc_Moon), themeWidget);

      _ui.themeSwitch = new oclero::qlementine::Switch(themeWidget);
      _ui.themeSwitch->setFocusPolicy(Qt::FocusPolicy::NoFocus);
      _ui.themeSwitch->setToolTip(i18n::switchTheme());

      const auto updateThemeSwitch = [this]() {
        _ui.themeSwitch->blockSignals(true);
        _ui.themeSwitch->setChecked(_themeManager->currentTheme() == "Dark");
        _ui.themeSwitch->blockSignals(false);
      };
      QObject::connect(_ui.themeSwitch, &oclero::qlementine::Switch::clicked, this, [this](auto checked) {
        _themeManager->setCurrentTheme(checked ? "Dark" : "Light");
      });
      QObject::connect(_themeManager, &oclero::qlementine::ThemeManager::currentThemeChanged, this, updateThemeSwitch);

      themeLayout->addWidget(lightIconWidget);
      themeLayout->addWidget(_ui.themeSwitch);
      themeLayout->addWidget(darkIconWidget);

      updateThemeSwitch();
    }

    _ui.togglePanelButton = new QToolButton(_ui.toolBar);
    {
      _ui.togglePanelButton->setText(i18n::showHideQuestInformation());
      _ui.togglePanelButton->setIcon(makeIcon(Icons16::Navigation_UiPanelRight));
      _ui.togglePanelButton->setToolTip(i18n::showHideQuestInformation());
      _ui.togglePanelButton->setCheckable(true);
      _ui.togglePanelButton->setChecked(false);
      _ui.togglePanelButton->setToolButtonStyle(Qt::ToolButtonStyle::ToolButtonIconOnly);
      _ui.togglePanelButton->setFocusPolicy(Qt::NoFocus);
      _ui.toolBar->addWidget(_ui.togglePanelButton);
    }
  }

  _ui.listView = new QListView(this);
  {
    _ui.listView->ensurePolished();
    _ui.listView->setFlow(QListView::Flow::LeftToRight);
    _ui.listView->setSpacing(16);
    _ui.listView->setResizeMode(QListView::ResizeMode::Adjust);
    _ui.listView->setViewMode(QListView::ViewMode::IconMode);
    _ui.listView->setDragEnabled(false);
    _ui.listView->setItemAlignment(Qt::AlignCenter);
    _ui.listView->setMovement(QListView::Movement::Static);
    _ui.listView->setSelectionMode(QAbstractItemView::SelectionMode::SingleSelection);
    _ui.listView->setSelectionBehavior(QAbstractItemView::SelectionBehavior::SelectItems);
    _ui.listView->setWrapping(true);
    _ui.listView->setContentsMargins(0, 0, 0, 0);
    _ui.listView->setVerticalScrollMode(QAbstractItemView::ScrollMode::ScrollPerPixel);

    auto* listDelegate = new QuestListItemDelegate(_ui.listView);
    _ui.listView->setItemDelegate(listDelegate);
  }

  _ui.statusBar = new QStatusBar(this);
  {
    _ui.statusBar->setSizeGripEnabled(false);
    _ui.statusBar->setContentsMargins(16, 0, 16, 0);
    {
      _ui.questCountLabel = new QLabel(_ui.statusBar);
      {
        _ui.questCountLabel->setText(i18n::noQuestFound());
        _ui.questCountLabel->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
      }
      _ui.statusBar->addPermanentWidget(_ui.questCountLabel);
    }
  }

  windowLayout->setMenuBar(_ui.menuBar);
  windowLayout->addWidget(_ui.toolBar);
  windowLayout->addWidget(_ui.listView);
  windowLayout->addWidget(_ui.statusBar);
}

void MainWindow::setupMenuBar() {
  _ui.menuBar = new QMenuBar(this);
  _ui.menuBar->setNativeMenuBar(true);

  const auto macOS = QSysInfo::productType() == "macos";

  auto* fileMenu = _ui.menuBar->addMenu(i18n::fileMenu());
  {
    fileMenu->setSeparatorsCollapsible(true);

    fileMenu->addAction(
      makeIcon(Icons16::Action_PlusCircle, macOS), i18n::addQuestAction(), QKeySequence::StandardKey::New, []() {});
    fileMenu->addAction(makeIcon(Icons16::Action_AddFolder, macOS), i18n::addQuestFolderAction(),
      QKeySequence::StandardKey::Open, []() {});
    fileMenu->addSeparator();
    fileMenu->addAction(makeIcon(Icons16::Navigation_Settings, macOS), i18n::preferences(),
      QKeySequence::StandardKey::Preferences, []() {});
    fileMenu->addSeparator();
#ifdef Q_OS_WIN
    // QKeySequence::Quit is empty on Windows.
    const auto quitShortcut = QKeySequence(Qt::CTRL | Qt::Key_Q);
#else
    const auto quitShortcut = QKeySequence(QKeySequence::Quit);
#endif
    fileMenu->addAction(makeIcon(Icons16::Action_Close, macOS), i18n::quit(), quitShortcut, []() {
      qApp->quit();
    });
  }

  auto* questMenu = _ui.menuBar->addMenu(i18n::questMenu());
  {
    questMenu->addAction(makeIcon(Icons16::Media_Play, macOS), i18n::playQuest(), QKeySequence{ Qt::Key_Return }, []() {
      // TODO
    });
    questMenu->addSeparator();
    questMenu->addAction(makeIcon(Icons16::File_FolderOpen, macOS), i18n::showContaingFolder(), QKeySequence{}, []() {
      // TODO
    });
  }

  auto* viewMenu = _ui.menuBar->addMenu(i18n::viewMenu());
  {
    viewMenu->setSeparatorsCollapsible(true);

    auto* themeMenu = viewMenu->addMenu(i18n::theme());
    themeMenu->setIcon(makeIcon(Icons16::Misc_PaintPalette, macOS));

    auto* themeActionGroup = new QActionGroup(themeMenu);
    themeActionGroup->setExclusive(true);

    const auto& themes = _themeManager->themes();
    const auto currentTheme = _themeManager->currentTheme();

    for (const auto& theme : themes) {
      const auto name = theme.meta.name;
      const auto icon = name == "Dark" ? makeIcon(Icons16::Misc_Moon, macOS) : makeIcon(Icons16::Misc_Sun, macOS);
      auto* action = themeMenu->addAction(icon, name);
      action->setCheckable(true);
      themeActionGroup->addAction(action);
      action->setChecked(name == currentTheme);

      QObject::connect(action, &QAction::triggered, action, [this, name](auto checked) {
        if (checked) {
          setTheme(name);
        }
      });
      QObject::connect(
        _themeManager, &oclero::qlementine::ThemeManager::currentThemeChanged, action, [this, name, action]() {
          action->setChecked(name == _themeManager->currentTheme());
        });
    }

    themeMenu->addSeparator();
    themeMenu->addAction(
      makeIcon(Icons16::Action_Swap, macOS), i18n::switchTheme(), { Qt::CTRL | Qt::Key_T }, [this]() {
        _themeManager->setNextTheme();
      });
  }

  auto* helpMenu = _ui.menuBar->addMenu(i18n::helpMenu());
  {
    helpMenu->setSeparatorsCollapsible(true);
    helpMenu->addAction(makeIcon(Icons16::Misc_Mail, macOS), i18n::contact(), QKeySequence{}, []() {

    });
    helpMenu->addAction(makeIcon(Icons16::Misc_Info, macOS), i18n::about(), QKeySequence{}, [this]() {
      AboutWindow aboutWindow(this);
      aboutWindow.exec();
    });
  }
}

void MainWindow::setTheme(const QString& theme) {}
} // namespace solarus::launcher
