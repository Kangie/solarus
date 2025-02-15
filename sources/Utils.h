// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <oclero/qlementine/icons/Icons16.hpp>
#include <oclero/qlementine/style/QlementineStyle.hpp>
#include <QIcon>

using Icons16 = oclero::qlementine::icons::Icons16;

static QIcon makeIcon(Icons16 id, bool macOSMenu = false, const QSize& size = { 16, 16 }) {
  if (macOSMenu)
    return QIcon{};

  const auto svgPath = oclero::qlementine::icons::iconPath(id);
  if (auto* style = oclero::qlementine::appStyle()) {
    return style->makeThemedIcon(svgPath, size);
  } else {
    return QIcon(svgPath);
  }
}
