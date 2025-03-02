// SPDX-License-Identifier: GPL-3.0-or-later
#include <widgets/QuestListView.h>

#include <Utils.h>
#include <Preferences.h>
#include <Controller.h>
#include <quests/QuestListItemDelegate.h>
#include <quests/QuestListModel.h>
#include <quests/QuestRunner.h>

#include <QMouseEvent>
#include <QSortFilterProxyModel>
#include <QMenu>
#include <QApplication>

namespace solarus::launcher {
namespace i18n {
static QString removeQuest() {
  return QApplication::translate("SolarusLauncher", "Remove Quest");
}
static QString playQuest() {
  return QApplication::translate("SolarusLauncher", "Play Quest");
}
static QString showQuestInformation() {
  return QApplication::translate("SolarusLauncher", "Show Quest Information");
}
static QString showContaingFolder() {
  return QApplication::translate("SolarusLauncher", "Open Containing Folder");
}
} // namespace i18n

QuestListView::QuestListView(Controller* controller, QWidget* parent)
  : QListView(parent)
  , _controller(controller) {
  setupUi();
}

void QuestListView::setupUi() {
  ensurePolished();
  setFlow(QListView::Flow::LeftToRight);
  setSpacing(16);
  setResizeMode(QListView::ResizeMode::Adjust);
  setViewMode(QListView::ViewMode::IconMode);
  setDragEnabled(false);
  setItemAlignment(Qt::AlignCenter);
  setMovement(QListView::Movement::Static);
  setSelectionMode(QAbstractItemView::SelectionMode::SingleSelection);
  setSelectionBehavior(QAbstractItemView::SelectionBehavior::SelectItems);
  setWrapping(true);
  setContentsMargins(0, 0, 0, 0);
  setVerticalScrollMode(QAbstractItemView::ScrollMode::ScrollPerPixel);
  setUniformItemSizes(true);

  auto* listDelegate = new QuestListItemDelegate(this);
  setItemDelegate(listDelegate);

  setModel(_controller->model()->proxyModel());

  QObject::connect(selectionModel(), &QItemSelectionModel::currentRowChanged, this,
    [this](const QModelIndex& current, const QModelIndex&) {
      _controller->model()->setCurrentQuest(current);
    });

  QObject::connect(this, &QListView::doubleClicked, this, [this](const QModelIndex& index) {
    _controller->playQuest(index);
  });

  setCurrentIndex(_controller->model()->index(0));

  setContextMenuPolicy(Qt::ContextMenuPolicy::CustomContextMenu);
  QObject::connect(this, &QListView::customContextMenuRequested, this, [this](const QPoint& pos) {
    const auto index = indexAt(pos);
    if (index.isValid()) {
      QMenu menu(this);
      {
        auto* playAction = new QAction(makeIcon(Icons16::Media_Play), i18n::playQuest(), &menu);
        playAction->setShortcut(QKeySequence(Qt::Key_F5));
        menu.addAction(playAction);
        QObject::connect(playAction, &QAction::triggered, this, [this, index]() {
          _controller->playQuest(index);
        });
      }
      {
        auto* infoAction = new QAction(makeIcon(Icons16::Misc_Info), i18n::showQuestInformation(), &menu);
        menu.addAction(infoAction);
        QObject::connect(infoAction, &QAction::triggered, this, [this, index]() {
          setCurrentIndex(index);
          _controller->preferences()->setAppPropertiesPanelVisible(true);
        });
      }
      {
        auto* folderAction = new QAction(makeIcon(Icons16::File_FolderOpen), i18n::showContaingFolder(), &menu);
        menu.addAction(folderAction);
        QObject::connect(folderAction, &QAction::triggered, this, [this, index]() {
          _controller->openQuestFolder(index);
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
          _controller->removeQuest(index);
        });
      }

      const auto globalPos = mapToGlobal(pos);
      menu.exec(globalPos);
    }
  });
}

void QuestListView::mousePressEvent(QMouseEvent* event) {
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

void QuestListView::mouseReleaseEvent(QMouseEvent* event) {
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

void QuestListView::mouseMoveEvent(QMouseEvent* event) {
  if (event->buttons() != Qt::NoButton) {
    // Ignore clicks on empty areas.
    event->ignore();
    return;
  }
  QListView::mouseMoveEvent(event);
}

void QuestListView::currentChanged(const QModelIndex& current, const QModelIndex& previous) {
  QListView::currentChanged(current, previous);
  _controller->model()->setCurrentQuest(current);
}
} // namespace solarus::launcher
