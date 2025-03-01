// SPDX-License-Identifier: GPL-3.0-or-later
#include <widgets/MainWindow.h>

#include <widgets/Console.h>
#include <widgets/MessageBox.h>
#include <widgets/PreferencesWindow.h>

#include <quests/QuestListModel.h>
#include <quests/QuestListItemDelegate.h>
#include <quests/QuestRunner.h>

#include <BasicUpdater.h>
#include <Utils.h>
#include <Preferences.h>

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
#include <QDesktopServices>
#include <QUrl>
#include <QSortFilterProxyModel>
#include <QPlainTextEdit>
#include <QPainter>
#include <QSplitter>
#include <QTableWidget>
#include <QHeaderView>

#include <oclero/qlementine/icons/Icons16.hpp>
#include <oclero/qlementine.hpp>
#include <oclero/qlementine/widgets/LineEdit.hpp>
#include <oclero/qlementine/widgets/IconWidget.hpp>
#include <oclero/qlementine/widgets/Switch.hpp>
#include <oclero/qlementine/widgets/Label.hpp>
#include <oclero/qlementine/style/ThemeManager.hpp>
#include <oclero/qlementine/utils/WidgetUtils.hpp>
#include <oclero/qlementine/widgets/Expander.hpp>
#include <oclero/qlementine/widgets/AboutDialog.hpp>

namespace solarus::launcher {
namespace i18n {
static QString addQuest() {
  return QApplication::translate("SolarusLauncher", "Add Quest");
}
static QString addQuestFolder() {
  return QApplication::translate("SolarusLauncher", "Add Quest Folder");
}
static QString addQuestAction() {
  return QApplication::translate("SolarusLauncher", "Add Quest…");
}
static QString addQuestFolderAction() {
  return QApplication::translate("SolarusLauncher", "Add Folder…");
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
  return QApplication::translate("SolarusLauncher", "Stop Quest");
}
static QString showHideQuestInformation() {
  return QApplication::translate("SolarusLauncher", "Show/Hide Quest Information");
}
static QString showHideConsole() {
  return QApplication::translate("SolarusLauncher", "Show/Hide Quest Console");
}
static QString search() {
  return QApplication::translate("SolarusLauncher", "Search…");
}
static QString noQuestFound() {
  return QApplication::translate("SolarusLauncher", "No Quest added");
}
static QString questsFound(int count) {
  return QApplication::translate("SolarusLauncher", "%n Quest(s) added", "", count);
}
static QString preferences() {
  return QApplication::translate("SolarusLauncher", "Preferences…");
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
static QString sourceCode() {
  return QApplication::translate("SolarusLauncher", "Source Code");
}
static QString about() {
  return QApplication::translate("SolarusLauncher", "About…");
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
  return QApplication::translate("SolarusLauncher", "Open Containing Folder");
}
static QString solarusQuests() {
  return QApplication::translate("SolarusLauncher", "Solarus Quests");
}
static QString playingLabel() {
  return QApplication::translate("SolarusLauncher", "Playing:");
}
static QString closeConsole() {
  return QApplication::translate("SolarusLauncher", "Close console");
}
static QString clearConsole() {
  return QApplication::translate("SolarusLauncher", "Clear console");
}
static QString noQuestPlaying() {
  return QApplication::translate("SolarusLauncher", "No quest playing");
}
static QString questRemovalConfirmation() {
  return QApplication::translate("SolarusLauncher", "Do you want to remove this Solarus Quest?");
}
static QString questRemovalDescription() {
  return QApplication::translate(
    "SolarusLauncher", "The quest will be removed from Solarus Launcher index, but will be kept on disk.");
}
static QString updateAvailable() {
  return QApplication::translate( "SolarusLauncher", "Update Available");
}
static QString versionComparison() {
  return QApplication::translate( "SolarusLauncher", "You have %1, %2 is available.");
}
static QString checkForUpdates() {
  return QApplication::translate( "SolarusLauncher", "Check for Updates");
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

class QuestPropsModel : public QAbstractTableModel {
public:
  using QAbstractTableModel::QAbstractTableModel;

  enum TableColumn {
    Value,
    ColumnCount,
  };

  enum TableRow {
    Title,
    Description,
    Authors,
    InitialReleaseDate,
    LatestReleaseDate,
    Version,
    EngineVersion,
    Licenses,
    Languages,
    Players,
    Genres,
    Website,
    Age,
    Controls,
    RowCount,
  };

public:
  QuestData quest;

  void setQuest(const QuestData& quest) {
    this->quest = quest;
    const auto index1 = index(TableRow(), TableColumn::Value);
    const auto index2 = index(TableRow::RowCount - 1, TableColumn::Value);
    emit dataChanged(index1, index2);
  }

  int rowCount(const QModelIndex& parent) const override {
    return TableRow::RowCount;
  }

  int columnCount(const QModelIndex& parent) const override {
    return TableColumn::ColumnCount;
  }

  QVariant data(const QModelIndex& index, int role) const override {
    switch (role) {
      case Qt::ItemDataRole::DisplayRole:
        switch (index.column()) {
          case TableColumn::Value:
            return rowValue(index.row());
          default:
            break;
        }
      default:
        break;
    }

    return {};
  }

  QString rowLabel(int row) const {
    static const QMap<TableRow, QString> labels{
      { TableRow::Title, "Title" },
      { TableRow::Authors, "Author(s)" },
      { TableRow::InitialReleaseDate, "Release Date" },
      { TableRow::LatestReleaseDate, "Latest Update" },
      { TableRow::Description, "Description" },
      { TableRow::Version, "Version" },
      { TableRow::EngineVersion, "Solarus Version" },
      { TableRow::Licenses, "License(s)" },
      { TableRow::Languages, "Language(s)" },
      { TableRow::Players, "Players" },
      { TableRow::Genres, "Genre(s)" },
      { TableRow::Website, "Website" },
      { TableRow::Age, "Age" },
      { TableRow::Controls, "Controls" },
    };

    if (row >= TableRow() && row < TableRow::RowCount) {
      return labels.value(static_cast<TableRow>(row), QString());
    } else {
      return QString();
    }
  }

  QString rowValue(int row) const {
    switch (row) {
      case TableRow::Title:
        return quest.title;
      case TableRow::Authors:
        return quest.authors.join(", ");
      case TableRow::InitialReleaseDate:
        return quest.initialReleaseDate.toString(Qt::DateFormat::ISODateWithMs);
      case TableRow::LatestReleaseDate:
        return quest.latestReleaseDate.toString(Qt::DateFormat::ISODateWithMs);
      case TableRow::Description:
        return quest.description;
      case TableRow::Version:
        return quest.version.toString();
      case TableRow::EngineVersion:
        return quest.engineVersion.toString();
      case TableRow::Licenses:
        return quest.licenses.join(", ");
      case TableRow::Languages:
        return quest.languages.join(", ");
      case TableRow::Players:
        return quest.maxPlayers == quest.minPlayers ? QString::number(quest.maxPlayers)
                                                    : QString("%1-%2").arg(quest.minPlayers, quest.maxPlayers);
      case TableRow::Genres:
        return quest.genres.join(", ");
      case TableRow::Website:
        return QString("<a href=\"%1\">%1</a>").arg(quest.website.toString());
      case TableRow::Age:
        return QString();
      case TableRow::Controls:
        return QString();
      default:
        return QString();
    }
  }

  QVariant headerData(int section, Qt::Orientation orientation, int role) const override {
    if (role == Qt::ItemDataRole::DisplayRole && orientation == Qt::Orientation::Vertical) {
      return rowLabel(section);
    }
    return {};
  }
};

class QuestPropertiesPanel : public QWidget {
public:
  QuestPropertiesPanel(QWidget* parent)
    : QWidget(parent) {
    setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
    setFixedWidth(300);

    auto* layout = new QVBoxLayout(this);
    layout->setSpacing(0);
    layout->setContentsMargins(0, 0, 0, 0);

    constexpr auto thumbnailRatio = 360. / 700.;
    const auto thumbnailWidth = width();
    _thumbnailLabel = new QLabel(this);
    _thumbnailLabel->setFixedSize(thumbnailWidth, thumbnailWidth * thumbnailRatio);
    _thumbnailLabel->setScaledContents(true);
    layout->addWidget(_thumbnailLabel);
    layout->setAlignment(_thumbnailLabel, Qt::AlignHCenter);

    _tableView = new QTableView(this);
    _tableView->setSortingEnabled(false);
    _tableView->setCornerButtonEnabled(false);
    _tableView->horizontalHeader()->hide();
    _tableView->verticalHeader()->show();
    _tableView->setGridStyle(Qt::PenStyle::NoPen);
    _tableView->setWordWrap(true);
    _tableView->setModel(&_tableModel);
    _tableView->setSelectionMode(QAbstractItemView::SelectionMode::NoSelection);
    _tableView->setSelectionBehavior(QAbstractItemView::SelectionBehavior::SelectRows);
    _tableView->setDragEnabled(false);
    _tableView->setVerticalScrollMode(QAbstractItemView::ScrollMode::ScrollPerPixel);
    _tableView->setFrameStyle(QFrame::NoFrame);
    _tableView->setTextElideMode(Qt::TextElideMode::ElideNone);
    _tableView->setLineWidth(0);
    _tableView->setAlternatingRowColors(true);
    layout->addWidget(_tableView);
  }

  void setQuest(const QuestData& quest) {
    _tableModel.setQuest(quest);
    _thumbnailLabel->setPixmap(_tableModel.quest.thumbnail);

    if (auto* hHeader = _tableView->horizontalHeader()) {
      // hHeader->setSectionResizeMode(QuestPropsModel::TableColumn::Label, QHeaderView::ResizeToContents);
      hHeader->setSectionResizeMode(QuestPropsModel::TableColumn::Value, QHeaderView::Stretch);
    }
    if (auto* vHeader = _tableView->verticalHeader()) {
      vHeader->setSectionResizeMode(QHeaderView::ResizeMode::ResizeToContents);
    }

    // _tableView->resizeRowToContents(QuestPropsModel::TableRow::Title);
    _tableView->resizeRowsToContents();
  }

private:
  QLabel* _thumbnailLabel{ nullptr };
  QTableView* _tableView{ nullptr };
  QuestPropsModel _tableModel;
};

class PlainTextEditBackground : public QWidget {
  using QWidget::QWidget;

protected:
  void paintEvent(QPaintEvent*) override {
    const auto* style = qobject_cast<oclero::qlementine::QlementineStyle*>(this->style());
    const auto& bgColor = style ? style->theme().backgroundColorWorkspace : palette().base();
    QPainter p(this);
    p.fillRect(rect(), bgColor);
  }
};

class CustomSplitterHandle : public QSplitterHandle {
  using QSplitterHandle::QSplitterHandle;

public:
  std::function<void()> onMouseReleased;

protected:
  void mouseReleaseEvent(QMouseEvent* event) override {
    QSplitterHandle::mouseReleaseEvent(event);
    if (onMouseReleased) {
      onMouseReleased();
    }
  }
};

class CustomSplitter : public QSplitter {
  using QSplitter::QSplitter;

public:
  std::function<void()> onHandleMouseReleased;

protected:
  QSplitterHandle* createHandle() override {
    auto* handle = new CustomSplitterHandle(orientation(), this);
    handle->onMouseReleased = onHandleMouseReleased;
    return handle;
  }
};

MainWindow::MainWindow(QWidget* parent)
  : QWidget(parent)
  , _preferences(new Preferences(this))
  , _runner(new QuestRunner(this))
  , _model(new QuestListModel(this)) {
  _proxyModel = new QSortFilterProxyModel(_model);
  _proxyModel->setSourceModel(_model);
  _proxyModel->setFilterCaseSensitivity(Qt::CaseInsensitive);
  _proxyModel->setSortRole(Qt::DisplayRole);
  _proxyModel->setDynamicSortFilter(true);
  _proxyModel->sort(0, Qt::AscendingOrder);

  ensurePolished();
  setMinimumSize(640, 320);
  oclero::qlementine::centerWidget(this);
  restoreGeometry(_preferences->windowGeometry());

  setupThemeManager();
  setWindowTitle(QApplication::applicationDisplayName());
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
        addQuestAction->setShortcut(QKeySequence::StandardKey::New);
        QObject::connect(addQuestAction, &QAction::triggered, this, [this]() {
          openAddQuestDialog();
        });

        auto* addFolderAction = subMenu->addAction(makeIcon(Icons16::Action_AddFolder), i18n::addQuestFolderAction());
        addFolderAction->setShortcut(QKeySequence::StandardKey::Open);
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
        removeCurrentQuest();
      });
    }

    _ui.toolBar->addSeparator();

    _ui.playStopQuestButton = new QToolButton(_ui.toolBar);
    {
      _ui.playStopQuestButton->setCheckable(false);
      _ui.playStopQuestButton->setChecked(false);
      _ui.playStopQuestButton->setToolButtonStyle(Qt::ToolButtonStyle::ToolButtonTextBesideIcon);
      _ui.playStopQuestButton->setFocusPolicy(Qt::NoFocus);

      // Ensure the button's width does not change.
      _ui.playStopQuestButton->ensurePolished();
      _ui.playStopQuestButton->setIcon(makeIcon(Icons16::Media_Play));
      _ui.playStopQuestButton->setText(i18n::play());
      const auto w1 = _ui.playStopQuestButton->sizeHint().width();
      _ui.playStopQuestButton->setText(i18n::stop());
      const auto w2 = _ui.playStopQuestButton->sizeHint().width();
      const auto w = std::max(w1, w2);
      _ui.playStopQuestButton->setFixedWidth(w);

      _ui.toolBar->addWidget(_ui.playStopQuestButton);

      QObject::connect(_ui.playStopQuestButton, &QPushButton::clicked, this, [this]() {
        playStopQuest();
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

      QObject::connect(_ui.searchLineEdit, &QLineEdit::textEdited, this, [this](const QString& text) {
        _proxyModel->setFilterFixedString(text);
      });

      auto* cancelAction = _ui.searchLineEdit->addAction({}, QKeySequence::StandardKey::Cancel);
      QObject::connect(cancelAction, &QAction::triggered, this, [this]() {
        _ui.searchLineEdit->clear();
        emit _ui.searchLineEdit->textEdited(_ui.searchLineEdit->text());
        _ui.listView->setFocus(Qt::FocusReason::ShortcutFocusReason);
      });

      QObject::connect(_ui.searchLineEdit, &QLineEdit::returnPressed, this, [this]() {
        _ui.listView->setFocus(Qt::FocusReason::ShortcutFocusReason);
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
        QSignalBlocker _(_ui.themeSwitch);
        _ui.themeSwitch->setChecked(_preferences->appTheme() == "Dark");
      };
      QObject::connect(_ui.themeSwitch, &oclero::qlementine::Switch::clicked, this, [this](auto checked) {
        _preferences->setAppTheme(checked ? "Dark" : "Light");
      });
      QObject::connect(_preferences, &Preferences::appThemeChanged, this, updateThemeSwitch);

      themeLayout->addWidget(lightIconWidget);
      themeLayout->addWidget(_ui.themeSwitch);
      themeLayout->addWidget(darkIconWidget);

      updateThemeSwitch();
    }

    _ui.toolBar->addSeparator();

    _ui.toggleConsoleButton = new QToolButton(_ui.toolBar);
    {
      _ui.toggleConsoleButton->setText(i18n::showHideConsole());
      _ui.toggleConsoleButton->setIcon(makeIcon(Icons16::Navigation_UiPanelBottom));
      _ui.toggleConsoleButton->setToolTip(i18n::showHideConsole());
      _ui.toggleConsoleButton->setCheckable(true);
      _ui.toggleConsoleButton->setChecked(_preferences->appConsoleVisible());
      _ui.toggleConsoleButton->setToolButtonStyle(Qt::ToolButtonStyle::ToolButtonIconOnly);
      _ui.toggleConsoleButton->setFocusPolicy(Qt::NoFocus);
      _ui.toolBar->addWidget(_ui.toggleConsoleButton);

      QObject::connect(_ui.toggleConsoleButton, &QPushButton::clicked, this, [this](bool checked) {
        _preferences->setAppConsoleVisible(checked);
      });

      QObject::connect(_preferences, &Preferences::appConsoleVisibleChanged, this, [this]() {
        QSignalBlocker _(_ui.toggleConsoleButton);
        _ui.toggleConsoleButton->setChecked(_preferences->appConsoleVisible());
      });
    }

    _ui.togglePanelButton = new QToolButton(_ui.toolBar);
    {
      _ui.togglePanelButton->setText(i18n::showHideQuestInformation());
      _ui.togglePanelButton->setIcon(makeIcon(Icons16::Navigation_UiPanelRight));
      _ui.togglePanelButton->setToolTip(i18n::showHideQuestInformation());
      _ui.togglePanelButton->setCheckable(true);
      _ui.togglePanelButton->setChecked(_preferences->appPropertiesPanelVisible());
      _ui.togglePanelButton->setToolButtonStyle(Qt::ToolButtonStyle::ToolButtonIconOnly);
      _ui.togglePanelButton->setFocusPolicy(Qt::NoFocus);
      _ui.toolBar->addWidget(_ui.togglePanelButton);

      QObject::connect(_ui.togglePanelButton, &QPushButton::clicked, this, [this](bool checked) {
        _preferences->setAppPropertiesPanelVisible(checked);
      });

      QObject::connect(_preferences, &Preferences::appPropertiesPanelVisibleChanged, this, [this]() {
        QSignalBlocker _(_ui.togglePanelButton);
        _ui.togglePanelButton->setChecked(_preferences->appPropertiesPanelVisible());
      });
    }
  }

  auto* topWidget = new QWidget(this);
  {
    auto* topWidgetLayout = new QHBoxLayout(topWidget);
    topWidget->setLayout(topWidgetLayout);
    topWidgetLayout->setSpacing(0);
    topWidgetLayout->setContentsMargins(0, 0, 0, 0);

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

      _ui.listView->setModel(_proxyModel);
      auto* selectionModel = _ui.listView->selectionModel();

      const auto updateUi = [this]() {
        const auto current = _ui.listView->currentIndex();
        const auto hasCurrent = current.isValid();
        _ui.removeQuestButton->setEnabled(hasCurrent);

        _ui.playStopQuestButton->setEnabled(hasCurrent || _runner->state() == QuestRunner::State::Running);

        const auto questData = _model->questDataAt(current);
        _ui.propertiesPanel->setQuest(questData);
      };

      QObject::connect(_ui.listView, &QListView::pressed, this, updateUi);

      QObject::connect(selectionModel, &QItemSelectionModel::currentRowChanged, this, updateUi);

      QObject::connect(_ui.listView, &QListView::doubleClicked, this, [this](const QModelIndex& index) {
        playQuest(index);
      });

      _ui.listView->setContextMenuPolicy(Qt::ContextMenuPolicy::CustomContextMenu);


      QObject::connect(_ui.listView, &QListView::customContextMenuRequested, this, [this](const QPoint& pos) {
        const auto index = _ui.listView->indexAt(pos);
        if (index.isValid()) {
          QMenu menu(_ui.listView);

          {
            auto* playAction = new QAction(makeIcon(Icons16::Media_Play), i18n::playQuest(), &menu);
            playAction->setShortcut(QKeySequence(Qt::Key_F5));
            menu.addAction(playAction);
            QObject::connect(playAction, &QAction::triggered, this, [this, index]() {
              playQuest(index);
            });
          }
          {
            auto* infoAction = new QAction(makeIcon(Icons16::Misc_Info), i18n::showQuestInfo(), &menu);
            menu.addAction(infoAction);
            QObject::connect(infoAction, &QAction::triggered, this, [this, index]() {
              _ui.listView->setCurrentIndex(index);
              _preferences->setAppPropertiesPanelVisible(true);
            });
          }
          {
            auto* folderAction = new QAction(makeIcon(Icons16::File_FolderOpen), i18n::showContaingFolder(), &menu);
            menu.addAction(folderAction);
            QObject::connect(folderAction, &QAction::triggered, this, [this, index]() {
              openQuestFolder(index);
            });
          }
          menu.addSeparator();
          {
            auto* removeAction = new QAction(makeIcon(Icons16::Action_Trash), i18n::removeQuest(), &menu);
#ifdef __APPLE__
            removeAction->setShortcut(Qt::Key_Backspace);
#else
            removeAction->setShortcut(QKeySequence::StandardKey::Delete);
#endif
            menu.addAction(removeAction);
            QObject::connect(removeAction, &QAction::triggered, this, [this, index]() {
              removeQuest(index);
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
      _ui.propertiesPanelExpander->setExpanded(_preferences->appPropertiesPanelVisible());

      QObject::connect(_ui.propertiesPanelExpander, &oclero::qlementine::Expander::expandedChanged, this, [this]() {
        _preferences->setAppPropertiesPanelVisible(_ui.propertiesPanelExpander->expanded());
      });

      QObject::connect(_preferences, &Preferences::appPropertiesPanelVisibleChanged, this, [this]() {
        _ui.propertiesPanelExpander->setExpanded(_preferences->appPropertiesPanelVisible());
      });
    }

    topWidgetLayout->addWidget(_ui.listView);
    topWidgetLayout->addWidget(_ui.propertiesPanelExpander);
  }

  auto* bottomWidget = new QWidget(this);
  {
    auto* bottomWidgetLayout = new QVBoxLayout(bottomWidget);
    bottomWidget->setLayout(bottomWidgetLayout);
    bottomWidgetLayout->setSpacing(0);
    bottomWidgetLayout->setContentsMargins(0, 0, 0, 0);

    {
      auto* consoleToolBar = new QFrame(bottomWidget);
      bottomWidgetLayout->addWidget(consoleToolBar);

      auto* consoleToolBarLayout = new QHBoxLayout(consoleToolBar);
      consoleToolBarLayout->setContentsMargins(12, 2, 4, 2);
      consoleToolBar->setLayout(consoleToolBarLayout);

      auto* iconWidget = new oclero::qlementine::IconWidget(consoleToolBar);
      consoleToolBarLayout->addWidget(iconWidget);

      auto* playingLayout = new QHBoxLayout();
      playingLayout->setContentsMargins(0, 0, 0, 0);
      playingLayout->setSpacing(4);
      consoleToolBarLayout->addLayout(playingLayout);

      auto* playingLabel = new QLabel(consoleToolBar);
      playingLabel->setText(QString("<b>%1</b>").arg(i18n::playingLabel()));
      playingLayout->addWidget(playingLabel);

      auto* consoleTitleLabel = new QLabel(consoleToolBar);
      consoleToolBarLayout->addWidget(consoleTitleLabel);
      playingLayout->addWidget(consoleTitleLabel);

      if (const auto* qlementineStyle = qobject_cast<oclero::qlementine::QlementineStyle*>(style())) {
        const auto updatePalette = [qlementineStyle, playingLabel, consoleTitleLabel, iconWidget]() {
          const auto palette = qlementineStyle->paletteForTextRole(oclero::qlementine::TextRole::Caption);
          playingLabel->setPalette(palette);
          consoleTitleLabel->setPalette(palette);
          iconWidget->setPalette(palette);
        };
        updatePalette();
        QObject::connect(qlementineStyle, &oclero::qlementine::QlementineStyle::themeChanged, this, [updatePalette]() {
          updatePalette();
        });
      }

      const auto updateQuestToolBar = [this, playingLabel, consoleTitleLabel, iconWidget]() {
        const auto path = _runner->questFilePath();
        const auto hasQuest = !path.isEmpty();
        consoleTitleLabel->setText(hasQuest ? path : i18n::noQuestPlaying());
        playingLabel->setVisible(hasQuest);
        iconWidget->setIcon(makeIcon(hasQuest ? Icons16::Software_CommandLine : Icons16::Misc_Info));
      };
      updateQuestToolBar();

      QObject::connect(_runner, &QuestRunner::questChanged, this, updateQuestToolBar);

      consoleToolBarLayout->addStretch();

      auto* clearConsoleButton = new QPushButton(consoleToolBar);
      clearConsoleButton->setToolTip(i18n::clearConsole());
      clearConsoleButton->setFocusPolicy(Qt::NoFocus);
      clearConsoleButton->setIconSize(QSize(12, 12));
      clearConsoleButton->setFixedSize(18, 18);
      clearConsoleButton->setFlat(true);
      clearConsoleButton->setIcon(makeIcon(Icons16::Action_Trash));
      consoleToolBarLayout->addWidget(clearConsoleButton);

      QObject::connect(clearConsoleButton, &QPushButton::clicked, this, [this]() {
        _ui.console->clear();
      });

      auto* closeButton = new QPushButton(consoleToolBar);
      closeButton->setToolTip(i18n::closeConsole());
      closeButton->setFocusPolicy(Qt::NoFocus);
      closeButton->setIconSize(QSize(12, 12));
      closeButton->setFixedSize(18, 18);
      closeButton->setFlat(true);
      closeButton->setIcon(makeIcon(Icons16::Action_Close));
      consoleToolBarLayout->addWidget(closeButton);

      QObject::connect(closeButton, &QPushButton::clicked, this, [this]() {
        _preferences->setAppConsoleVisible(false);
      });
    }

    {
      auto* line = oclero::qlementine::makeHorizontalLine(bottomWidget);
      bottomWidgetLayout->addWidget(line);
    }

    {
      auto* consoleContainer = new PlainTextEditBackground(this);
      bottomWidgetLayout->addWidget(consoleContainer);

      consoleContainer->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Expanding);
      auto* consoleContainerLayout = new QVBoxLayout(consoleContainer);
      consoleContainerLayout->setContentsMargins(0, 0, 0, 0);
      consoleContainer->setLayout(consoleContainerLayout);
      consoleContainerLayout->setSpacing(0);

      _ui.console = new Console(consoleContainer);
      _ui.console->setMinimumHeight(100);
      _ui.console->set_quest_runner(_runner);
      consoleContainerLayout->addWidget(_ui.console);
    }
  }

  auto* customSplitter = new CustomSplitter(this);
  customSplitter->onHandleMouseReleased = [this, bottomWidget]() {
    if (_ui.consoleSplitter->sizes().at(1) == 0) {
      bottomWidget->setVisible(false);
      _preferences->setAppConsoleVisible(false);
    } else {
      bottomWidget->setVisible(true);
      _preferences->setAppConsoleVisible(true);
    }

    _preferences->setWindowSplitterState(_ui.consoleSplitter->saveState());
  };
  _ui.consoleSplitter = customSplitter;
  _ui.consoleSplitter->setOrientation(Qt::Vertical);
  _ui.consoleSplitter->addWidget(topWidget);
  _ui.consoleSplitter->addWidget(bottomWidget);
  _ui.consoleSplitter->setCollapsible(0, false);
  _ui.consoleSplitter->setHandleWidth(2);

  QObject::connect(_preferences, &Preferences::appConsoleVisibleChanged, this, [this, bottomWidget]() {
    const auto bottomVisible = _preferences->appConsoleVisible();
    if (bottomVisible) {
      bottomWidget->show();
      _ui.consoleSplitter->setSizes({ _ui.consoleSplitter->sizes().at(0), 100 });
    } else {
      bottomWidget->hide();
      _ui.consoleSplitter->setSizes({ _ui.consoleSplitter->sizes().at(0), 0 });
    }

    bottomWidget->setVisible(bottomVisible);
  });

  // Restore geometry from settings.
  _ui.consoleSplitter->restoreState(_preferences->windowSplitterState());
  if (_ui.consoleSplitter->sizes().at(1) == 0) {
    bottomWidget->setVisible(false);
  } else {
    bottomWidget->setVisible(true);
  }

  _ui.statusBar = new QStatusBar(this);
  {
    _ui.statusBar->setFixedHeight(28);
    _ui.statusBar->setSizeGripEnabled(false);
    _ui.statusBar->setContentsMargins(16, 0, 16, 0);
    {
      _ui.updateButton = new QPushButton(_ui.statusBar);
      {
        _ui.updateButton->setText(i18n::updateAvailable());
        _ui.updateButton->setAutoDefault(false);
        _ui.updateButton->setDefault(true);
        _ui.updateButton->setFixedHeight(20);
        _ui.updateButton->setIcon(makeIcon(Icons16::Action_Update));
        _ui.updateButton->setVisible(false);
        _ui.statusBar->addPermanentWidget(_ui.updateButton);
      }

      auto* questCountContainer = new QWidget(_ui.statusBar);
      questCountContainer->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
      auto* questCountLayout = new QHBoxLayout(questCountContainer);
      questCountLayout->setContentsMargins(0, 0, 0, 0);
      questCountLayout->setSpacing(8);

      auto* iconWidget = new oclero::qlementine::IconWidget(questCountContainer);
      {
        const auto updateIcon = [this, iconWidget](){
          const auto count = _model->rowCount({});
          iconWidget->setIcon(makeIcon(count > 0 ? Icons16::Misc_Library : Icons16::Misc_Warning));
        };
        updateIcon();
        QObject::connect(_model, &QuestListModel::rowCountChanged, this, updateIcon);
      }
      questCountLayout->addWidget(iconWidget);

      auto* questCountLabel = new QLabel(_ui.statusBar);
      {
        // questCountLabel->setRole(oclero::qlementine::TextRole::Caption);
        questCountLabel->setText(i18n::noQuestFound());
        questCountLabel->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);

        QObject::connect(_model, &QuestListModel::rowCountChanged, this, [this, questCountLabel]() {
          const auto count = _model->rowCount({});
          questCountLabel->setText(count > 0 ? i18n::questsFound(count) : i18n::noQuestFound());
        });
      }
      questCountLayout->addWidget(questCountLabel);

      if (const auto* qlementineStyle = qobject_cast<oclero::qlementine::QlementineStyle*>(style())) {
        const auto updatePalette = [qlementineStyle, iconWidget, questCountLabel]() {
          const auto palette = qlementineStyle->paletteForTextRole(oclero::qlementine::TextRole::Caption);
          iconWidget->setPalette(palette);
          questCountLabel->setPalette(palette);
        };
        updatePalette();
        QObject::connect(qlementineStyle, &oclero::qlementine::QlementineStyle::themeChanged, this, [updatePalette]() {
          updatePalette();
        });
      }

      _ui.statusBar->addWidget(questCountContainer);

    }
  }

  windowLayout->setMenuBar(_ui.menuBar);
  windowLayout->addWidget(_ui.toolBar);
  windowLayout->addWidget(_ui.consoleSplitter);
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
      makeIcon(Icons16::Action_PlusCircle, macOS), i18n::addQuestAction(), QKeySequence::StandardKey::New, [this]() {
        openAddQuestDialog();
      });

    fileMenu->addAction(makeIcon(Icons16::Action_AddFolder, macOS), i18n::addQuestFolderAction(),
      QKeySequence::StandardKey::Open, [this]() {
        openAddFolderDialog();
      });

#ifdef __APPLE__
    const auto removeQuestShortcut = QKeySequence(Qt::Key_Backspace);
#else
    const auto removeQuestShortcut = QKeySequence(QKeySequence::StandardKey::Delete);
#endif

    fileMenu->addAction(makeIcon(Icons16::Action_Trash, macOS), i18n::removeQuest(), removeQuestShortcut, [this]() {
      removeCurrentQuest();
    });

    fileMenu->addSeparator();

    fileMenu->addAction(makeIcon(Icons16::Media_Play, macOS), i18n::playQuest(), QKeySequence{ Qt::Key_F5 }, [this]() {
      playCurrentQuest();
    });

    fileMenu->addAction(
      makeIcon(Icons16::File_FolderOpen, macOS), i18n::showContaingFolder(), QKeySequence{}, [this]() {
        openCurrentQuestFolder();
      });

    fileMenu->addAction(
      makeIcon(Icons16::Navigation_Search, macOS), i18n::search(), QKeySequence::StandardKey::Find, [this]() {
        _ui.searchLineEdit->setFocus(Qt::MenuBarFocusReason);
      });

    fileMenu->addSeparator();

    fileMenu->addAction(makeIcon(Icons16::Navigation_Settings, macOS), i18n::preferences(),
      QKeySequence::StandardKey::Preferences, [this]() {
        openPreferencesDialog();
      });

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

      QObject::connect(action, &QAction::triggered, this, [this, name](auto checked) {
        _themeManager->setCurrentTheme(name);
      });
      QObject::connect(_preferences, &Preferences::appThemeChanged, this, [this, name, action]() {
        QSignalBlocker _(action);
        action->setChecked(name == _preferences->appTheme());
      });
    }

    viewMenu->addAction(makeIcon(Icons16::Action_Swap, macOS), i18n::switchTheme(), { Qt::CTRL | Qt::Key_T }, [this]() {
      _themeManager->setNextTheme();
    });

    viewMenu->addSeparator();

    {
      auto* action = viewMenu->addAction(makeIcon(Icons16::Navigation_UiPanelBottom, macOS), i18n::showHideConsole(),
        { Qt::Key_F12 }, [this](bool checked) {
          _preferences->setAppConsoleVisible(checked);
        });
      action->setCheckable(true);
      action->setChecked(_preferences->appConsoleVisible());

      QObject::connect(_preferences, &Preferences::appConsoleVisibleChanged, this, [this, action]() {
        QSignalBlocker _(action);
        action->setChecked(_preferences->appConsoleVisible());
      });
    }

    {
      auto* action = viewMenu->addAction(makeIcon(Icons16::Navigation_UiPanelRight, macOS),
        i18n::showHideQuestInformation(), { Qt::Key_F10 }, [this](bool checked) {
          _preferences->setAppPropertiesPanelVisible(checked);
        });
      action->setCheckable(true);
      action->setChecked(_preferences->appPropertiesPanelVisible());

      QObject::connect(_preferences, &Preferences::appPropertiesPanelVisibleChanged, this, [this, action]() {
        QSignalBlocker _(action);
        action->setChecked(_preferences->appPropertiesPanelVisible());
      });
    }
  }

  auto* helpMenu = _ui.menuBar->addMenu(i18n::helpMenu());
  {
    helpMenu->setSeparatorsCollapsible(true);

    helpMenu->addAction(makeIcon(Icons16::Misc_Mail, macOS), i18n::contact(), QKeySequence{}, [this]() {
      openContactPage();
    });
    helpMenu->addAction(makeIcon(Icons16::File_FileScript, macOS), i18n::sourceCode(), QKeySequence{}, [this]() {
      openSourceCodePage();
    });

    helpMenu->addSeparator();

    _ui.checkForUpdateAction = helpMenu->addAction(makeIcon(Icons16::Action_Update, macOS), i18n::checkForUpdates(), QKeySequence{}, [this]() {
      checkForUpdates();
    });
    _ui.checkForUpdateAction->setMenuRole(QAction::MenuRole::ApplicationSpecificRole);

    helpMenu->addAction(makeIcon(Icons16::Misc_Info, macOS), i18n::about(), QKeySequence{}, [this]() {
      openAboutDialog();
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

void MainWindow::removeQuest(const QModelIndex& index) {
  if (index.isValid()) {
    const auto questFilePath = _model->questFilePath(index);
    auto* msgBox = new MessageBox(this);
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

void MainWindow::removeCurrentQuest() {
  const auto index = _ui.listView->currentIndex();
  removeQuest(index);
}

void MainWindow::playQuest(const QModelIndex& index) {
  if (index.isValid()) {
    const auto questFilePath = _model->questFilePath(index);
    _runner->start(questFilePath);
  }
}

void MainWindow::playCurrentQuest() {
  // TODO
}

void MainWindow::openQuestFolder(const QModelIndex& index) {
  if (index.isValid()) {
    const auto questFilePath = _model->questFilePath(index);
    const auto questFileInfo = QFileInfo(questFilePath);
    const auto questDirUrl = QUrl::fromLocalFile(questFileInfo.absoluteDir().absolutePath());
    QDesktopServices::openUrl(questDirUrl);
  }
}

void MainWindow::openCurrentQuestFolder() {
  const auto index = _ui.listView->currentIndex();
  openQuestFolder(index);
}

void MainWindow::openPreferencesDialog() {
  PreferencesWindow window(*_preferences, *_themeManager, this);
  window.exec();
}

void MainWindow::openAboutDialog() {
  auto* dialog = new oclero::qlementine::AboutDialog(this);
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

void MainWindow::playStopQuest() {
  if (_runner->state() == QuestRunner::State::Stopped) {
    const auto index = _ui.listView->currentIndex();
    if (index.isValid()) {
      const auto questFilePath = _model->questFilePath(index);
      _runner->start(questFilePath);
    }
  } else {
    _runner->stop();
  }
}

void MainWindow::openContactPage() {
  QDesktopServices::openUrl(QUrl(PROJECT_LINKS_CONTACT));
}

void MainWindow::openSourceCodePage() {
  QDesktopServices::openUrl(QUrl(PROJECT_LINKS_SOURCE_CODE));
}

void MainWindow::checkForUpdates() {
  _ui.updateButton->setVisible(false);
  _ui.statusBar->clearMessage();
  _ui.statusBar->showMessage("Checking for updates...", 0);
  _ui.updateButton->disconnect();
  _ui.checkForUpdateAction->setEnabled(false);

  solarus::launcher::checkForUpdates([this](const UpdateCheckResult& result) {
    _ui.checkForUpdateAction->setEnabled(true);

    switch (result.status) {
    case UpdateCheckStatus::UpdateAvailable:
      _ui.updateButton->setVisible(true);
      _ui.statusBar->clearMessage();
      _ui.updateButton->setToolTip(i18n::versionComparison()
                                  .arg(result.currentVersion.toString(), result.newVersion.toString()));
      QObject::connect(_ui.updateButton, &QPushButton::clicked, this, [this, result]() {
        QDesktopServices::openUrl(result.newVersionDownloadUrl);
      });
    break;
    case UpdateCheckStatus::NoUpdate:
      _ui.updateButton->setVisible(false);
      _ui.statusBar->clearMessage();
      _ui.statusBar->showMessage("No update available", 5000);
      break;
    case UpdateCheckStatus::Error:
      _ui.updateButton->setVisible(false);
      _ui.statusBar->clearMessage();
      _ui.statusBar->showMessage(QString("Failed to check for updates. Error code: %1").arg(result.errorCode), 5000);
      break;
    default:
      break;
    }
  });
}

void MainWindow::resizeEvent(QResizeEvent* event) {
  QWidget::resizeEvent(event);
  _preferences->setWindowGeometry(saveGeometry());
  _preferences->setWindowSplitterState(_ui.consoleSplitter->saveState());
}

void MainWindow::closeEvent(QCloseEvent* event) {
  QWidget::closeEvent(event);
  _preferences->setWindowGeometry(saveGeometry());
  _preferences->setWindowSplitterState(_ui.consoleSplitter->saveState());
}
} // namespace solarus::launcher
