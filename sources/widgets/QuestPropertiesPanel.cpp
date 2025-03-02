// SPDX-License-Identifier: GPL-3.0-or-later
#include <widgets/QuestPropertiesPanel.h>

#include <quests/QuestData.h>
#include <quests/QuestListModel.h>

#include <QAbstractTableModel>
#include <QVBoxLayout>
#include <QLabel>
#include <QTableView>
#include <QHeaderView>

namespace solarus::launcher {
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

QuestPropertiesPanel::QuestPropertiesPanel(QuestListModel* model, QWidget* parent)
  : QWidget(parent)
  , _model(model) {
  setupUi();
}

void QuestPropertiesPanel::setupUi() {
  _tableModel = new QuestPropsModel(this);

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
  _tableView->setModel(_tableModel);
  _tableView->setSelectionMode(QAbstractItemView::SelectionMode::NoSelection);
  _tableView->setSelectionBehavior(QAbstractItemView::SelectionBehavior::SelectRows);
  _tableView->setDragEnabled(false);
  _tableView->setVerticalScrollMode(QAbstractItemView::ScrollMode::ScrollPerPixel);
  _tableView->setFrameStyle(QFrame::NoFrame);
  _tableView->setTextElideMode(Qt::TextElideMode::ElideNone);
  _tableView->setLineWidth(0);
  _tableView->setAlternatingRowColors(true);
  layout->addWidget(_tableView);

  const auto updateUi = [this](const QModelIndex& index) {
    const auto& quest = _model->questDataAt(index);
    _tableModel->setQuest(quest);
    _thumbnailLabel->setPixmap(_tableModel->quest.thumbnail);

    if (auto* hHeader = _tableView->horizontalHeader()) {
      // hHeader->setSectionResizeMode(QuestPropsModel::TableColumn::Label, QHeaderView::ResizeToContents);
      hHeader->setSectionResizeMode(QuestPropsModel::TableColumn::Value, QHeaderView::Stretch);
    }
    if (auto* vHeader = _tableView->verticalHeader()) {
      vHeader->setSectionResizeMode(QHeaderView::ResizeMode::ResizeToContents);
    }

    // _tableView->resizeRowToContents(QuestPropsModel::TableRow::Title);
    _tableView->resizeRowsToContents();
  };
  updateUi(_model->currentQuest());
  QObject::connect(_model, &QuestListModel::currentQuestChanged, this, updateUi);
}
} // namespace solarus::launcher
