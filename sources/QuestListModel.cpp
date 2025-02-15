// SPDX-License-Identifier: GPL-3.0-or-later

#include "QuestListModel.h"

namespace solarus::launcher {
QuestListModel::QuestListModel(QObject* parent) : QAbstractListModel(parent) {
}

void QuestListModel::addQuest(const QuestData& quest) {
  //
}

int QuestListModel::rowCount(const QModelIndex &parent) const {
  return 3;

  return static_cast<int>(_quests.size());
}

QVariant QuestListModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid())
    return {};

  const auto row = index.row();
  if (row >= static_cast<int>(_quests.size()))
    return {};

  const auto& quest = _quests.at(row);
  switch (role) {
  case static_cast<int>(Qt::DisplayRole):
  case static_cast<int>(Qt::ToolTipRole):
    return QVariant::fromValue(quest.title);
  case static_cast<int>(Qt::DecorationRole):
    return QVariant::fromValue(quest.thumbnail);
  default:
    return {};
  }
}
} // namespace solarus::launcher

