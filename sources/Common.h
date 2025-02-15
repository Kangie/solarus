// SPDX-License-Identifier: GPL-3.0-or-later
#pragma once

#include <QObject>
#include <QFlags>

namespace solarus::launcher {
class Common {
  Q_GADGET

public:
  enum class AgeRating {
    All,
    Warning,
    Restricted,
  };
  Q_ENUM(AgeRating)

  enum class Control {
    None = 0,
    Keyboard = 1 << 0,
    Mouse = 1 << 1,
    Joypad = 1 << 2,
    Other = 1 << 3,
  };
  Q_ENUM(Control)
  Q_DECLARE_FLAGS(Controls, Control)
  Q_FLAG(Controls)

private:
  Common() = delete;
};
} // namespace solarus::launcher

Q_DECLARE_OPERATORS_FOR_FLAGS(solarus::launcher::Common::Controls)
Q_DECLARE_METATYPE(solarus::launcher::Common::Controls)
