// SPDX-License-Identifier: GPL-3.0-or-later

#include "QuestListItemDelegate.h"

#include <QPainter>

namespace solarus::launcher {
QuestListItemDelegate::QuestListItemDelegate(QObject *parent) : QStyledItemDelegate(parent) {

}

void QuestListItemDelegate::paint(QPainter *painter, const QStyleOptionViewItem &option, const QModelIndex &index) const {
  painter->setPen(Qt::red);
  painter->setBrush(Qt::yellow);
  painter->drawRect(option.rect);
}

QSize QuestListItemDelegate::sizeHint(const QStyleOptionViewItem &, const QModelIndex &) const {
  return {200, 102};
}
} // namespace solarus::launcher
