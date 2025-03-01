// SPDX-License-Identifier: GPL-3.0-or-later
#include <quests/QuestListItemDelegate.h>

#include <QPainter>

#include <oclero/qlementine/utils/ImageUtils.hpp>
#include <oclero/qlementine/utils/StateUtils.hpp>
#include <oclero/qlementine/style/QlementineStyle.hpp>

namespace solarus::launcher {
QuestListItemDelegate::QuestListItemDelegate(QObject* parent)
  : QStyledItemDelegate(parent) {}

void QuestListItemDelegate::paint(
  QPainter* painter, const QStyleOptionViewItem& option, const QModelIndex& index) const {
  const auto pixelRatio = option.widget->devicePixelRatioF();
  const auto* qlementineStyle = qobject_cast<oclero::qlementine::QlementineStyle*>(option.widget->style());
  const auto& theme = qlementineStyle ? qlementineStyle->theme() : oclero::qlementine::Theme{};
  const auto radius = theme.borderRadius * pixelRatio;

  auto thumbnail = index.data(Qt::DecorationRole)
                     .value<QPixmap>()
                     .scaledToHeight(option.rect.height() * pixelRatio, Qt::SmoothTransformation);
  thumbnail.setDevicePixelRatio(pixelRatio);
  const auto roundedThumbnail = oclero::qlementine::makeRoundedPixmap(thumbnail, radius);

  const auto mouse = oclero::qlementine::getMouseState(option.state);
  const auto selected = oclero::qlementine::getSelectionState(option.state);
  const auto focus = oclero::qlementine::getFocusState(option.state);
  const auto active = oclero::qlementine::getActiveState(option.state);
  const auto bgColor =
    qlementineStyle ? qlementineStyle->listItemBackgroundColor(mouse, selected, focus, active, index, option.widget)
                    : theme.backgroundColorMain1;

  painter->setPen(Qt::NoPen);
  painter->setRenderHint(QPainter::Antialiasing, true);
  painter->setBrush(bgColor);
  painter->drawRoundedRect(option.rect, theme.borderRadius, theme.borderRadius);

  const auto thumbnailSize = roundedThumbnail.deviceIndependentSize();
  const auto x = option.rect.x() + (option.rect.width() - thumbnailSize.width()) / 2;
  const auto y = option.rect.y() + (option.rect.height() - thumbnailSize.height()) / 2;
  painter->setClipRect(option.rect);
  painter->drawPixmap(x, y, roundedThumbnail);
}

QSize QuestListItemDelegate::sizeHint(const QStyleOptionViewItem&, const QModelIndex&) const {
  return { 200, 102 };
}
} // namespace solarus::launcher
