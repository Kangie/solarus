// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <oclero/qlementine/icons/Icons16.hpp>
#include <oclero/qlementine/style/QlementineStyle.hpp>
#include <QIcon>

using Icons16 = oclero::qlementine::icons::Icons16;

QIcon makeIcon(Icons16 id, bool macOSMenu = false, const QSize& size = { 16, 16 });
