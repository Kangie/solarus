// SPDX-License-Identifier: GPL-3.0-or-later

#include "MainWindow.h"

#include "QuestListModel.h"
#include "QuestListItemDelegate.h"
#include "AboutWindow.h"
#include "Utils.h"
#include "QuestRunner.h"

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
#include <QFileDialog>
#include <QStandardPaths>
#include <QTimer>
#include <QMessageBox>
#include <QMouseEvent>
#include <QSignalBlocker>
#include <QFormLayout>
#include <QScrollArea>

#include <oclero/qlementine/icons/Icons16.hpp>
#include <oclero/qlementine.hpp>
#include <oclero/qlementine/widgets/LineEdit.hpp>
#include <oclero/qlementine/widgets/IconWidget.hpp>
#include <oclero/qlementine/widgets/Switch.hpp>
#include <oclero/qlementine/widgets/Label.hpp>
#include <oclero/qlementine/style/ThemeManager.hpp>
#include <oclero/qlementine/utils/WidgetUtils.hpp>
#include <oclero/qlementine/widgets/Expander.hpp>

namespace solarus::launcher {
namespace i18n {
static QString addQuest() {
  return QApplication::translate("SolarusLauncher", "Add Quest");
}
static QString addQuestFolder() {
  return QApplication::translate("SolarusLauncher", "Add Quest Folder");
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
static QString showQuestInfo() {
  return QApplication::translate("SolarusLauncher", "Show Quest Information");
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
static QString questsFound(int count) {
  return QApplication::translate("SolarusLauncher", "%n quest(s) found", "", count);
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
static QString solarusQuests() {
  return QApplication::translate("SolarusLauncher", "Solarus Quests");
}
} // namespace i18n

class CustomListView : public QListView {
  using QListView::QListView;

protected:
  void mousePressEvent(QMouseEvent* event) override {
    const auto index = indexAt(event->pos());
    if (!index.isValid()) {
      event->ignore();
      if (focusPolicy() & Qt::FocusPolicy::ClickFocus) {
        setFocus(Qt::FocusReason::MouseFocusReason);
      }
      return;
    }
    // if (index.isValid()) {
    //   const auto flags = index.flags();
    //   if (flags.testFlag(Qt::ItemFlag::ItemIsSelectable) && flags.testFlag(Qt::ItemFlag::ItemIsEnabled)) {
    //     if (auto* selectionModel = this->selectionModel()) {
    //       const auto selectedIndexes = selectionModel->selectedIndexes();
    //       {
    //         QSignalBlocker _(this);
    //         QListView::mousePressEvent(event);
    //       }
    //       emit pressed(index);
    //       {
    //         QSignalBlocker _(this);
    //         for (auto& selectedIndex : selectedIndexes) {
    //           selectionModel->select(selectedIndex, QItemSelectionModel::SelectCurrent);
    //         }
    //       }
    //     }
    //     return;
    //   }
    // } else {
    //   // Ignore clicks on empty areas.
    //   event->ignore();
    //   if (focusPolicy() & Qt::FocusPolicy::ClickFocus) {
    //     setFocus(Qt::FocusReason::MouseFocusReason);
    //   }
    //   return;
    // }

    QListView::mousePressEvent(event);
  }

  void mouseReleaseEvent(QMouseEvent* event) override {
    const auto index = indexAt(event->pos());
    if (index.isValid()) {
      const auto unselect_shortcut = event->modifiers() == Qt::ControlModifier;
      if (unselect_shortcut) {
        // Ignore CTRL+click.
        event->ignore();
        return;
      }
    } else {
      // Ignore clicks on empty areas.
      event->ignore();
      if (focusPolicy() & Qt::FocusPolicy::ClickFocus) {
        setFocus(Qt::FocusReason::MouseFocusReason);
      }
      return;
    }

    QListView::mouseReleaseEvent(event);
  }

  void mouseMoveEvent(QMouseEvent* event) override {
    if (event->buttons() != Qt::NoButton) {
      // Ignore clicks on empty areas.
      event->ignore();
      return;
    }
    QListView::mouseMoveEvent(event);
  }
};

class QuestPropertiesPanel : public QScrollArea {
public:
  QuestPropertiesPanel(QWidget* parent)
    : QScrollArea(parent) {
    setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);

    auto* content = new QWidget(this);
    auto* layout = new QFormLayout(content);
    layout->setRowWrapPolicy(QFormLayout::RowWrapPolicy::DontWrapRows);
    content->setLayout(layout);
    setWidget(content);
    setWidgetResizable(true);

    {
      _titleLabel = new QLabel(content);
      _titleLabel->setWordWrap(true);
      layout->addRow("<b>Title</b>", _titleLabel);
    }
    {
      _authorLabel = new QLabel(content);
      _authorLabel->setWordWrap(true);
      layout->addRow("<b>Author</b>", _authorLabel);
    }
    {
      _initialReleaseDateLabel = new QLabel(content);
      layout->addRow("<b>Initial Release Date</b>", _initialReleaseDateLabel);
    }

    setFixedWidth(220);
    updateUi();
  }

  void setQuest(const QuestData& quest) {
    _quest = quest;
    updateUi();
  }

private:
  void updateUi() {
    // TODO
    _titleLabel->setText(_quest.title);
    _authorLabel->setText(_quest.authors.join(", "));
  }

  QuestData _quest;
  QLabel* _titleLabel{ nullptr };
  QLabel* _authorLabel{ nullptr };
  QLabel* _initialReleaseDateLabel{ nullptr };
  QLabel* _latestReleaseDateLabel{ nullptr };
  QLabel* _descriptionLabel{ nullptr };
  QLabel* _versionLabel{ nullptr };
  QLabel* _engineVersionLabel{ nullptr };
  QLabel* _licensesLabel{ nullptr };
  QLabel* _languagesLabel{ nullptr };
  QLabel* _playersLabel{ nullptr };
  QLabel* _genresLabel{ nullptr };
  QLabel* _websiteLabel{ nullptr };
  QLabel* _ageLabel{ nullptr };
};

MainWindow::MainWindow(QWidget* parent)
  : QWidget(parent) {
  setMinimumSize(640, 400);
  oclero::qlementine::centerWidget(this);
  ensurePolished();

  _runner = new QuestRunner(this);
  _model = new QuestListModel(this);

  setupThemeManager();
  setWindowTitle("Solarus Launcher");
  setupMenuBar();
  setupUi();

  // TMP
  _model->addQuestFolder("/Users/oclero/Documents/Solarus/Quests");
}

void MainWindow::setAppIcon() {
  static constexpr std::array<QIcon::Mode, 4> modes{
    QIcon::Mode::Normal,
    QIcon::Mode::Disabled,
    QIcon::Mode::Active,
    QIcon::Mode::Selected,
  };
  static constexpr std::array<int, 12> dimensions{ 16, 20, 24, 32, 40, 48, 64, 96, 128, 256, 512, 1024 };
  static constexpr const char* path_base(":/solarus/launcher/resources/icon/solarus_launcher_icon_");
  static constexpr const char* path_ext(".png");

  QIcon app_icon;
  for (const auto dimension : dimensions) {
    const auto path = path_base + QString::number(dimension) + path_ext;
    QPixmap pixmap(path);
    for (const auto mode : modes) {
      app_icon.addPixmap(pixmap, mode, QIcon::State::On);
      app_icon.addPixmap(pixmap, mode, QIcon::State::Off);
    }
  }
  QGuiApplication::setWindowIcon(app_icon);
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

      QObject::connect(_ui.addQuestButton, &QPushButton::clicked, this, [this]() {
        openAddQuestDialog();
      });

      {
        auto* subMenu = new QMenu(i18n::addQuest(), _ui.addQuestButton);
        _ui.addQuestButton->setMenu(subMenu);
        _ui.addQuestButton->setPopupMode(QToolButton::ToolButtonPopupMode::MenuButtonPopup);

        auto* addQuestAction = subMenu->addAction(makeIcon(Icons16::Action_PlusCircle), i18n::addQuestAction());
        QObject::connect(addQuestAction, &QAction::triggered, this, [this]() {
          openAddQuestDialog();
        });

        auto* addFolderAction = subMenu->addAction(makeIcon(Icons16::Action_AddFolder), i18n::addQuestFolderAction());
        QObject::connect(addFolderAction, &QAction::triggered, this, [this]() {
          openAddFolderDialog();
        });
      }
    }

    _ui.removeQuestButton = new QToolButton(_ui.toolBar);
    {
      _ui.removeQuestButton->setText(i18n::removeQuest());
      _ui.removeQuestButton->setIcon(makeIcon(Icons16::Action_Trash));
      _ui.removeQuestButton->setToolTip(i18n::removeQuest());
      _ui.removeQuestButton->setCheckable(false);
      _ui.removeQuestButton->setChecked(false);
      _ui.removeQuestButton->setToolButtonStyle(Qt::ToolButtonStyle::ToolButtonIconOnly);
      _ui.removeQuestButton->setFocusPolicy(Qt::NoFocus);
      _ui.toolBar->addWidget(_ui.removeQuestButton);
      _ui.removeQuestButton->setEnabled(false);

      QObject::connect(_ui.removeQuestButton, &QPushButton::clicked, this, [this]() {
        const auto index = _ui.listView->currentIndex();
        if (index.isValid()) {
          const auto questFilePath = _model->questFilePath(index);
          /*uto* messageBox = new QMessageBox(QMessageBox::Icon::Question,
                                 "Remove Quest",
                                 "Do you want to remove this quest?",
                                 QMessageBox::Button::No | QMessageBox::Button::Yes,
                                 this);
          messageBox->setAttribute(Qt::WidgetAttribute::WA_DeleteOnClose);
          const auto result = messageBox->exec();
          if (result == QMessageBox::Button::Yes) {
            _model->removeQuest(questFilePath);
          }*/

          _model->removeQuest(questFilePath);
        }
      });
    }

    _ui.toolBar->addSeparator();

    _ui.playStopQuestButton = new QToolButton(_ui.toolBar);
    {
      _ui.playStopQuestButton->setCheckable(false);
      _ui.playStopQuestButton->setChecked(false);
      _ui.playStopQuestButton->setToolButtonStyle(Qt::ToolButtonStyle::ToolButtonTextBesideIcon);
      _ui.playStopQuestButton->setFocusPolicy(Qt::NoFocus);
      _ui.toolBar->addWidget(_ui.playStopQuestButton);

      QObject::connect(_ui.playStopQuestButton, &QPushButton::clicked, this, [this]() {
        if (_runner->state() == QuestRunner::State::Stopped) {
          const auto index = _ui.listView->currentIndex();
          if (index.isValid()) {
            const auto questFilePath = _model->questFilePath(index);
            _runner->start(questFilePath);
          }
        } else {
          _runner->stop();
        }
      });

      const auto updatePlayStopButton = [this]() {
        switch (_runner->state()) {
          case QuestRunner::State::Stopped:
            _ui.playStopQuestButton->setText(i18n::play());
            _ui.playStopQuestButton->setToolTip(i18n::playQuest());
            _ui.playStopQuestButton->setIcon(makeIcon(Icons16::Media_Play));
            _ui.playStopQuestButton->setEnabled(true);
            break;
          case QuestRunner::State::Running:
            _ui.playStopQuestButton->setText(i18n::stop());
            _ui.playStopQuestButton->setToolTip(i18n::stopQuest());
            _ui.playStopQuestButton->setIcon(makeIcon(Icons16::Media_Stop));
            _ui.playStopQuestButton->setEnabled(true);
            break;
          case QuestRunner::State::Starting:
            _ui.playStopQuestButton->setEnabled(false);
          default:
            break;
        }
      };
      updatePlayStopButton();
      QObject::connect(_runner, &QuestRunner::stateChanged, this, updatePlayStopButton);
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
      const auto shortcut =
        QKeySequence(QKeySequence::StandardKey::Find).toString(QKeySequence::SequenceFormat::NativeText);
      _ui.searchLineEdit->setPlaceholderText(QString("%1 (%2)").arg(i18n::search(), shortcut));
      _ui.searchLineEdit->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
      _ui.searchLineEdit->setFixedWidth(150);
      _ui.searchLineEdit->setClearButtonEnabled(true);
      _ui.searchLineEdit->setFocusPolicy(Qt::FocusPolicy::ClickFocus);
      _ui.searchLineEdit->setIcon(makeIcon(Icons16::Navigation_Search));
      _ui.toolBar->addWidget(_ui.searchLineEdit);

      QObject::connect(_ui.searchLineEdit, &QLineEdit::textEdited, this, [this]() {
        // TODO
      });
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

    _ui.toolBar->addSeparator();

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

      QObject::connect(_ui.togglePanelButton, &QPushButton::clicked, this, [this](bool checked) {
        _ui.propertiesPanelExpander->setExpanded(checked);
      });
    }
  }

  auto* rowLayout = new QHBoxLayout();
  rowLayout->setSpacing(0);
  rowLayout->setContentsMargins(0, 0, 0, 0);

  _ui.listView = new CustomListView(this);
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
    _ui.listView->setUniformItemSizes(true);

    auto* listDelegate = new QuestListItemDelegate(_ui.listView);
    _ui.listView->setItemDelegate(listDelegate);

    _ui.listView->setModel(_model);
    auto* selectionModel = _ui.listView->selectionModel();


    const auto updateUi = [this]() {
      const auto current = _ui.listView->currentIndex();
      const auto hasCurrent = current.isValid();
      _ui.removeQuestButton->setEnabled(hasCurrent);

      const auto questData = _model->questDataAt(current);
      _ui.propertiesPanel->setQuest(questData);
    };

    QObject::connect(_ui.listView, &QListView::pressed, this, updateUi);

    QObject::connect(selectionModel, &QItemSelectionModel::currentRowChanged, this, updateUi);

    // QObject::connect(_ui.listView, &QListView::doubleClicked, this, [this](const QModelIndex& index) {
    //   const auto filePath = _model->questFilePath(index);
    //   _runner->start(filePath);
    // });

    _ui.listView->setContextMenuPolicy(Qt::ContextMenuPolicy::CustomContextMenu);


    QObject::connect(_ui.listView, &QListView::customContextMenuRequested, this, [this](const QPoint& pos) {
      const auto index = _ui.listView->indexAt(pos);
      if (index.isValid()) {
        QMenu menu(_ui.listView);

        {
          auto* playAction = new QAction(makeIcon(Icons16::Media_Play), i18n::playQuest(), &menu);
          playAction->setShortcutVisibleInContextMenu(true);
          playAction->setShortcut(QKeySequence(Qt::Key_Return));
          menu.addAction(playAction);
          QObject::connect(playAction, &QAction::triggered, this, [this, index]() {
            const auto questPath = _model->questFilePath(index);
            _runner->start(questPath);
          });
        }
        {
          auto* infoAction = new QAction(makeIcon(Icons16::Misc_Info), i18n::showQuestInfo(), &menu);
          infoAction->setShortcutVisibleInContextMenu(true);
          menu.addAction(infoAction);
          QObject::connect(infoAction, &QAction::triggered, this, [this, index]() {
            // TODO
          });
        }
        menu.addSeparator();
        {
          auto* removeAction = new QAction(makeIcon(Icons16::Action_Trash), i18n::removeQuest(), &menu);
          removeAction->setShortcutVisibleInContextMenu(true);
          removeAction->setShortcut(QKeySequence::StandardKey::Delete);
          menu.addAction(removeAction);
          QObject::connect(removeAction, &QAction::triggered, this, [this, index]() {
            _model->removeQuest(index);
          });
        }

        const auto globalPos = _ui.listView->mapToGlobal(pos);
        menu.exec(globalPos);
      }
    });
  }

  _ui.propertiesPanelExpander = new oclero::qlementine::Expander(this);
  {
    _ui.propertiesPanelExpander->setOrientation(Qt::Horizontal);
    _ui.propertiesPanelExpander->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Expanding);
    auto* expanderContent = new QWidget(_ui.propertiesPanelExpander);
    expanderContent->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
    auto* expanderLayout = new QHBoxLayout(expanderContent);
    expanderContent->setLayout(expanderLayout);
    expanderLayout->setContentsMargins(0, 0, 0, 0);
    expanderLayout->setSpacing(0);

    expanderLayout->addWidget(oclero::qlementine::makeVerticalLine(this));
    _ui.propertiesPanel = new QuestPropertiesPanel(expanderContent);
    expanderLayout->addWidget(_ui.propertiesPanel);

    _ui.propertiesPanelExpander->setContent(expanderContent);
    _ui.propertiesPanelExpander->setExpanded(true);

    const auto syncButton = [this]() {
      const auto expanded = _ui.propertiesPanelExpander->expanded();
      QSignalBlocker _(_ui.togglePanelButton);
      _ui.togglePanelButton->setChecked(expanded);
    };
    syncButton();
    QObject::connect(_ui.propertiesPanelExpander, &oclero::qlementine::Expander::expandedChanged, this, syncButton);
  }

  rowLayout->addWidget(_ui.listView);
  rowLayout->addWidget(_ui.propertiesPanelExpander);

  _ui.statusBar = new QStatusBar(this);
  {
    _ui.statusBar->setSizeGripEnabled(false);
    _ui.statusBar->setContentsMargins(16, 0, 16, 0);
    {
      _ui.questCountLabel = new oclero::qlementine::Label(_ui.statusBar);
      {
        _ui.questCountLabel->setRole(oclero::qlementine::TextRole::Caption);
        _ui.questCountLabel->setText(i18n::noQuestFound());
        _ui.questCountLabel->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);

        QObject::connect(_model, &QuestListModel::rowCountChanged, this, [this]() {
          const auto count = _model->rowCount({});
          _ui.questCountLabel->setText(count > 0 ? i18n::questsFound(count) : i18n::noQuestFound());
        });
      }
      _ui.statusBar->addPermanentWidget(_ui.questCountLabel);
    }
  }

  windowLayout->setMenuBar(_ui.menuBar);
  windowLayout->addWidget(_ui.toolBar);
  windowLayout->addLayout(rowLayout);
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
    fileMenu->addAction(
      makeIcon(Icons16::Action_Trash, macOS), i18n::removeQuest(), QKeySequence::StandardKey::Delete, []() {});
    fileMenu->addSeparator();

    fileMenu->addAction(makeIcon(Icons16::Media_Play, macOS), i18n::playQuest(), QKeySequence{ Qt::Key_Return }, []() {
      // TODO
    });
    fileMenu->addAction(makeIcon(Icons16::File_FolderOpen, macOS), i18n::showContaingFolder(), QKeySequence{}, []() {
      // TODO
    });
    fileMenu->addAction(
      makeIcon(Icons16::Navigation_Search, macOS), i18n::search(), QKeySequence::StandardKey::Find, [this]() {
        _ui.searchLineEdit->setFocus(Qt::MenuBarFocusReason);
      });
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
          _themeManager->setCurrentTheme(name);
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

void MainWindow::openAddQuestDialog() {
  QTimer::singleShot(0, this, [this]() {
    const auto defaultDir = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    const auto filePath = QFileDialog::getOpenFileName(
      this, i18n::addQuest(), defaultDir, QString("%1 (*.solarus)").arg(i18n::solarusQuests()));
    if (!filePath.isEmpty()) {
      _model->addQuest(filePath);
    }
  });
}

void MainWindow::openAddFolderDialog() {
  QTimer::singleShot(0, this, [this]() {
    const auto defaultDir = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    const auto dirPath = QFileDialog::getExistingDirectory(this, i18n::addQuestFolder(), defaultDir);
    if (!dirPath.isEmpty()) {
      _model->addQuestFolder(dirPath);
    }
  });
}
} // namespace solarus::launcher
