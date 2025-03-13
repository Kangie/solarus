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
  enum DataRole {
    IsPlaying = Qt::UserRole + 1,
  };

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

  const QModelIndex& currentPlayingQuest() const;
  void setCurrentPlayingQuest(const QModelIndex& index);
  Q_SIGNAL void currentPlayingQuestChanged(const QModelIndex& index);

  QSortFilterProxyModel* proxyModel();

  QModelIndex questOfPath(const QString& path) const;

  QStringList questPathList() const;
  void setQuestPathList(const QStringList& list);

  int getRow(const QModelIndex& index) const;
  QModelIndex sourceIndex(const QModelIndex& index) const;

public:
  int rowCount(const QModelIndex& parent) const override;
  QVariant data(const QModelIndex& index, int role) const override;

signals:
  void rowCountChanged();
  void questListChanged();

private:
  QList<QuestData> _quests;
  QFileSystemWatcher* _watcher{ nullptr };
  QModelIndex _currentQuest;
  QModelIndex _currentPlayingQuest;
  QSortFilterProxyModel* _proxyModel{ nullptr };
};
} // namespace solarus::launcher
