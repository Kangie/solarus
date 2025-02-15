// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <QAbstractListModel>

#include "QuestData.h"

namespace solarus::launcher {
class QuestListModel : public QAbstractListModel {
  Q_OBJECT

public:
  explicit QuestListModel(QObject* parent = nullptr);
  virtual ~QuestListModel() = default;

public:
  void addQuest(const QuestData& quest);

public:
  int rowCount(const QModelIndex& parent) const override;
  QVariant data(const QModelIndex& index, int role) const override;

private:
  QList<QuestData> _quests;
};
} // namespace solarus::launcher
