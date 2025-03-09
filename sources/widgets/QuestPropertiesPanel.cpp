// SPDX-License-Identifier: GPL-3.0-or-later
#include <widgets/QuestPropertiesPanel.h>

#include <quests/QuestData.h>
#include <quests/QuestListModel.h>

#include <QAbstractTableModel>
#include <QVBoxLayout>
#include <QLabel>
#include <QTableView>
#include <QHeaderView>
#include <QScrollArea>
#include <QApplication>
#include <QScrollBar>

#include <oclero/qlementine/style/QlementineStyle.hpp>

namespace solarus::launcher {
namespace i18n {
static QString ageToString(const Common::AgeRating value) {
  switch (value) {
    case Common::AgeRating::All:
      return QApplication::translate("SolarusLauncher", "All");
    case Common::AgeRating::Restricted:
      return QApplication::translate("SolarusLauncher", "Restricted");
    case Common::AgeRating::Warning:
      return QApplication::translate("SolarusLauncher", "Warning");
    default:
      return "";
  }
}

static QString controlToString(const Common::Control value) {
  switch (value) {
    case Common::Control::Joypad:
      return QApplication::translate("SolarusLauncher", "Joypad");
    case Common::Control::Keyboard:
      return QApplication::translate("SolarusLauncher", "Keyboard");
    case Common::Control::Mouse:
      return QApplication::translate("SolarusLauncher", "Mouse");
    case Common::Control::Other:
      return QApplication::translate("SolarusLauncher", "Other");
    default:
      return "";
  }
}
} // namespace i18n

static QString controlsToString(const Common::Controls controls) {
  QStringList strings;
  for (const auto control : {
         Common::Control::Keyboard,
         Common::Control::Mouse,
         Common::Control::Joypad,
         Common::Control::Other,
       }) {
    if (controls.testFlag(control)) {
      strings.append(i18n::controlToString(control));
    }
  }
  return strings.join(", ");
}

static QString playersToString(const int minPlayers, const int maxPlayers) {
  return maxPlayers == minPlayers ? (maxPlayers > 0 ? QString::number(maxPlayers) : QString())
                                  : QString("%1-%2").arg(minPlayers, maxPlayers);
}

static QString makeHtmlLink(const QUrl& url) {
  return url.isEmpty() ? QString() : QString("<a href=\"%1\">%1</a>").arg(url.toString());
}

class QuestPropsModel : public QAbstractTableModel {
public:
  using QAbstractTableModel::QAbstractTableModel;

  enum TableColumn {
    Value,
    ColumnCount,
  };

  enum TableRow {
    Title,
    // Description,
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
        if (index.column() == TableColumn::Value) {
          return rowValue(index.row());
        }
        break;
      case Qt::ItemDataRole::DecorationRole:
        if (index.column() == TableColumn::Value) {
          return rowValueIcon(index.row());
        }
        break;
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
      // { TableRow::Description, "Description" },
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
    if (!quest.isValid)
      return QString();

    switch (row) {
      case TableRow::Title:
        return quest.title;
      case TableRow::Authors:
        return quest.authors.join(", ");
      case TableRow::InitialReleaseDate:
        return quest.initialReleaseDate.toString(Qt::DateFormat::ISODateWithMs);
      case TableRow::LatestReleaseDate:
        return quest.latestReleaseDate.toString(Qt::DateFormat::ISODateWithMs);
      // case TableRow::Description:
      //   return quest.description;
      case TableRow::Version:
        return quest.version.toString();
      case TableRow::EngineVersion:
        return quest.engineVersion.toString();
      case TableRow::Licenses:
        return quest.licenses.join(", ");
      case TableRow::Languages:
        return quest.languages.join(", ");
      case TableRow::Players:
        return playersToString(quest.minPlayers, quest.maxPlayers);
      case TableRow::Genres:
        return quest.genres.join(", ");
      case TableRow::Website:
        return makeHtmlLink(quest.website);
      case TableRow::Age:
        return i18n::ageToString(quest.ageRating);
      case TableRow::Controls:
        return controlsToString(quest.controls);
      default:
        return QString();
    }
  }

  QIcon rowValueIcon(int row) const {
    if (!quest.isValid)
      return QIcon();

    if (row == TableRow::Age) {
      return Common::ageIcon(quest.ageRating);
    }
    return QIcon();
  }

  QVariant headerData(int section, Qt::Orientation orientation, int role) const override {
    if (role == Qt::ItemDataRole::DisplayRole && orientation == Qt::Orientation::Vertical) {
      return rowLabel(section);
    }
    return {};
  }
};

QuestPropertiesPanel::QuestPropertiesPanel(QuestListModel* model, QWidget* parent)
  : QScrollArea(parent)
  , _model(model) {
  setupUi();
}

void QuestPropertiesPanel::setupUi() {
  setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Expanding);
  setFixedWidth(300);
  setWidgetResizable(true);

  auto* scrollAreaContent = new QWidget(this);
  setWidget(scrollAreaContent);

  auto* layout = new QVBoxLayout(scrollAreaContent);
  layout->setSpacing(0);
  layout->setContentsMargins(0, 0, 0, 0);
  scrollAreaContent->setLayout(layout);

  // Quest thumbnail.
  constexpr auto thumbnailRatio = 360. / 700.;
  const auto thumbnailWidth = width();
  _thumbnailLabel = new QLabel(scrollAreaContent);
  _thumbnailLabel->setFixedSize(thumbnailWidth, thumbnailWidth * thumbnailRatio);
  _thumbnailLabel->setScaledContents(true);
  layout->addWidget(_thumbnailLabel);
  layout->setAlignment(_thumbnailLabel, Qt::AlignHCenter);

  // Quest description.
  _descriptionLabel = new QLabel(scrollAreaContent);
  _descriptionLabel->setSizePolicy(QSizePolicy::Expanding, QSizePolicy::Preferred);
  _descriptionLabel->setMargin(16);
  _descriptionLabel->setWordWrap(true);
  layout->addWidget(_descriptionLabel);

  // Quest properties.
  _tableModel = new QuestPropsModel(this);

  _tableView = new QTableView(scrollAreaContent);
  if (auto* qlementine = qobject_cast<oclero::qlementine::QlementineStyle*>(_tableView->style())) {
    qlementine->setAutoIconColor(_tableView, oclero::qlementine::AutoIconColor::None);
  }

  _tableView->setSizeAdjustPolicy(QTableView::SizeAdjustPolicy::AdjustIgnored);
  _tableView->setFixedWidth(width());
  _tableView->setSizePolicy(QSizePolicy::Fixed, QSizePolicy::Fixed);
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

  updateUi(_model->currentQuest());
  QObject::connect(_model, &QuestListModel::currentQuestChanged, this, &QuestPropertiesPanel::updateUi);
}

void QuestPropertiesPanel::updateUi(const QModelIndex& index) {
  const auto& quest = _model->questDataAt(index);
  _tableModel->setQuest(quest);
  _thumbnailLabel->setPixmap(_tableModel->quest.thumbnail);
  _descriptionLabel->setText(quest.description);

  if (auto* hHeader = _tableView->horizontalHeader()) {
    // hHeader->setSectionResizeMode(QuestPropsModel::TableColumn::Label, QHeaderView::ResizeToContents);
    hHeader->setSectionResizeMode(QuestPropsModel::TableColumn::Value, QHeaderView::Stretch);
  }
  if (auto* vHeader = _tableView->verticalHeader()) {
    vHeader->setSectionResizeMode(QHeaderView::ResizeMode::ResizeToContents);
  }

  _tableView->resizeColumnsToContents();
  _tableView->resizeRowsToContents();
  _tableView->setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
  _tableView->setFixedHeight(_tableView->verticalHeader()->length() + _tableView->horizontalHeader()->height());

  setEnabled(quest.isValid);
  verticalScrollBar()->setValue(0);
}
} // namespace solarus::launcher
