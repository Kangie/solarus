/*
 * Copyright (C) 2021-2021 Christopho, Solarus - http://www.solarus-games.org
 *
 * Solarus Quest Editor is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Solarus Quest Editor is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#ifndef SOLARUSEDITOR_NEW_QUEST_MODE_TRAITS_H
#define SOLARUSEDITOR_NEW_QUEST_MODE_TRAITS_H

#include "enum_traits.h"
#include "new_quest_builder.h"

namespace SolarusEditor {

using NewQuestMode = NewQuestBuilder::NewQuestMode;
using NewQuestModeTraits = EnumTraits<NewQuestMode>;

/**
 * \brief Provides useful properties of NewQuestMode enum values.
 */
template<>
class EnumTraits<NewQuestMode> {

public:

  static QList<NewQuestMode> get_values();
  static QString get_friendly_name(NewQuestMode value);
  static QIcon get_icon(NewQuestMode value);

  static QString get_description(NewQuestMode value);
};

}

#endif
