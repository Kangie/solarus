// SPDX-License-Identifier: GPL-3.0-or-later
#include <quests/QuestListItemDelegate.h>

#include <QPainter>
#include <QEvent>
#include <QMouseEvent>

#include <oclero/qlementine/utils/ImageUtils.hpp>
#include <oclero/qlementine/utils/StateUtils.hpp>
#include <oclero/qlementine/style/QlementineStyle.hpp>

namespace solarus::launcher {
namespace {
QPixmap getPixmap(const QModelIndex& index, const qreal radius, const qreal pixelRatio, const qreal height) {
  auto thumbnail =
    index.data(Qt::DecorationRole).value<QPixmap>().scaledToHeight(height * pixelRatio, Qt::SmoothTransformation);
  thumbnail.setDevicePixelRatio(pixelRatio);
  const auto roundedThumbnail = oclero::qlementine::makeRoundedPixmap(thumbnail, radius * pixelRatio);
  return roundedThumbnail;
}
} // namespace

QuestListItemDelegate::QuestListItemDelegate(QObject* parent)
  : QStyledItemDelegate(parent) {}

void QuestListItemDelegate::paint(
  QPainter* painter, const QStyleOptionViewItem& option, const QModelIndex& index) const {
  const auto pixelRatio = option.widget->devicePixelRatioF();
  const auto* qlementine = qobject_cast<oclero::qlementine::QlementineStyle*>(option.widget->style());
  const auto& theme = qlementine ? qlementine->theme() : oclero::qlementine::Theme{};
  const auto radius = theme.borderRadius;
  const auto& bgColor = theme.backgroundColorMain2;
  const auto thumbnail = getPixmap(index, radius, pixelRatio, option.rect.height());
  const auto thumbnailSize = thumbnail.deviceIndependentSize();
  const auto thumbnailX = option.rect.x() + (option.rect.width() - thumbnailSize.width()) / 2;
  const auto thumbnailY = option.rect.y() + (option.rect.height() - thumbnailSize.height()) / 2;

  painter->save();
  {
    painter->setRenderHint(QPainter::Antialiasing, true);

    // Background in case of a logo (Solarus 1.6).
    painter->setPen(Qt::NoPen);
    painter->setBrush(bgColor);
    painter->drawRoundedRect(option.rect, radius, radius);

    // Thumbnail.
    painter->setClipRect(option.rect, Qt::ReplaceClip);
    painter->setClipping(true);
    painter->drawPixmap(thumbnailX, thumbnailY, thumbnail);

    // Overlay to highlight hovered element.
    const auto hasMouseOver = option.state.testFlag(QStyle::State_MouseOver);
    const auto hasMousePress = option.state.testFlag(QStyle::State_Sunken);
    if (hasMouseOver || hasMousePress) {
      const auto overlayColor = QColor(255, 255, 255, hasMousePress ? 64 : 32);
      painter->setCompositionMode(QPainter::CompositionMode_Overlay);
      painter->setPen(Qt::NoPen);
      painter->setBrush(overlayColor);
      painter->drawRoundedRect(option.rect, radius, radius);
      painter->setCompositionMode(QPainter::CompositionMode_SourceOver);
    }
    painter->setClipRect(QRect{}, Qt::NoClip);
    painter->setClipping(false);

    // Border for selected element.
    const auto isCurrent = option.state.testFlag(QStyle::State_Selected);
    const auto hasFocus = option.state.testFlag(QStyle::State_HasFocus);
    if (isCurrent) {
      const auto strokeColor = hasFocus ? theme.primaryColorHovered : theme.primaryColor;
      const auto strokeWidth = hasFocus ? theme.focusBorderWidth + theme.borderWidth : theme.borderWidth;
      const auto halfStrokeWidth = strokeWidth / 2.;
      const auto strokeRect =
        option.rect.toRectF().adjusted(halfStrokeWidth, halfStrokeWidth, -halfStrokeWidth, -halfStrokeWidth);
      const auto strokeRadius = radius - halfStrokeWidth;

      painter->setBrush(Qt::NoBrush);
      painter->setPen(QPen(strokeColor, strokeWidth, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin));
      painter->drawRoundedRect(strokeRect, strokeRadius, strokeRadius);
    }

    // // Border for focus.
    // if (hasFocus) {
    //   const auto focusColor = ;
    //   const auto focusStrokeWidth = theme.focusBorderWidth * 2.;
    //   const auto halfFocusStrokeWidth = focusStrokeWidth / 2.;
    //   const auto focusRect = option.rect.toRectF().adjusted(
    //       halfFocusStrokeWidth, halfFocusStrokeWidth, -halfFocusStrokeWidth, -halfFocusStrokeWidth);
    //   const auto focusRadius = radius - halfFocusStrokeWidth;

    //   painter->setBrush(Qt::NoBrush);
    //   painter->setPen(QPen(focusColor, focusStrokeWidth, Qt::SolidLine, Qt::RoundCap, Qt::RoundJoin));
    //   painter->drawRoundedRect(focusRect, focusRadius, focusRadius);
    // }
  }
  painter->restore();
}

QSize QuestListItemDelegate::sizeHint(const QStyleOptionViewItem&, const QModelIndex&) const {
  return { 200, 102 };
}
} // namespace solarus::launcher
