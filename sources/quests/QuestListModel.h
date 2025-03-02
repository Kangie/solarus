// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <QAbstractListModel>

#include <quests/QuestData.h>

class QFileSystemWatcher;
class QSortFilterProxyModel;

namespace solarus::launcher {
class QuestListModel : public QAbstractListModel {
  Q_OBJECT

public:
  explicit QuestListModel(QObject* parent = nullptr);
  virtual ~QuestListModel() = default;

public:
  void addQuest(const QString& path);
  void addQuestFolder(const QString& path);

  void removeQuest(const QString& path);
  void removeQuest(const QModelIndex& index);

  QString questFilePath(const QModelIndex& index) const;
  const QuestData& questDataAt(const QModelIndex& index) const;

  const QModelIndex& currentQuest() const;
  void setCurrentQuest(const QModelIndex& index);
  Q_SIGNAL void currentQuestChanged(const QModelIndex& index);

  QSortFilterProxyModel* proxyModel();

public:
  int rowCount(const QModelIndex& parent) const override;
  QVariant data(const QModelIndex& index, int role) const override;

signals:
  void rowCountChanged();

private:
  QList<QuestData> _quests;
  QFileSystemWatcher* _watcher{ nullptr };
  QModelIndex _currentQuest;
  QSortFilterProxyModel* _proxyModel{ nullptr };
};
} // namespace solarus::launcher
