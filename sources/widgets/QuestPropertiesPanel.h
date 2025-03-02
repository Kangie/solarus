// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <QWidget>

class QLabel;
class QTableView;

namespace solarus::launcher {
class QuestPropsModel;
class QuestListModel;

class QuestPropertiesPanel : public QWidget {
  Q_OBJECT

public:
  explicit QuestPropertiesPanel(QuestListModel* model, QWidget* parent = nullptr);
  virtual ~QuestPropertiesPanel() = default;

private:
  void setupUi();

private:
  QuestListModel* _model{ nullptr };
  QLabel* _thumbnailLabel{ nullptr };
  QTableView* _tableView{ nullptr };
  QuestPropsModel* _tableModel{ nullptr };
};
} // namespace solarus::launcher
