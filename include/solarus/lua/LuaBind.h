/*
 * Copyright (C) 2006-2019 Christopho, Solarus - http://www.solarus-games.org
 *
 * Solarus is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Solarus is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#ifndef SOLARUS_LUA_BIND_H
#define SOLARUS_LUA_BIND_H

#include "solarus/lua/LuaContext.h"

namespace Solarus {

namespace LuaBind {

/**
 * \brief Disables C to Lua conversion when used as a return value.
 *
 * Used with LuaToC functions, if this is their return type then the usual
 * conversion of return type to Lua type will not take place. Instead the
 * values already on the stack will be used.
 */
struct OnStack {
  int count;
};

/**
 * \brief Represents a Lua nil value.
 */
struct Nil {};

/**
 * \brief Wraps a C function so that it can be called from Lua.
 *
 * This is not a generic wrapper and is tied to the engine. The wrapping
 * roughly consists of three parts:
 *
 * 1.  Performs the boundary handling, which updates information inside
 *     LuaContext and prepares to handle any errors that may occur.
 * 2.  Read arguments from Lua and passes them to the wrapped function.
 * 3.  Push the return values from the wrapped function to Lua.
 *
 * The interface is based around types with direct Lua representations,
 * here called compatable types. These types are:
 * +   Reprsentations of Lua's primitive types: bool, int, double,
 *     const char * (or std::string) and Nil.
 * +   Enumerations with EnumInfoTraits defined.
 * +   The userdata types, repersented by a reference to ExportableToLua
 *     or one of its child types.
 * +   An optional version of one of the above.
 *     For primitive types and enumerations, wrap the type in std::optional.
 *     For userdata types, replace the reference with a pointer.
 *
 * The function should take compatable types as arguments. The wrapper will
 * read the Lua stack to get the arguments, causing an error in Lua if that
 * cannot be done. The optional types accept nil or none as a no-value
 * alternative, except for booleans where only none can be used.
 *
 * The first argument may be lua_State * or LuaContext &, in which case
 * the current context is passed. Instead the function can be a method,
 * in which case the receiver must be a userdata type.
 *
 * The return type may be one of the compatable types, a tuple of compatable
 * types, void or OnStack. The first three handle most cases where you want
 * to return a value, multiple values or nothing to Lua, the wrapper will
 * handle the conversion to Lua. OnStack gives the number of values already
 * on the stack that should be returned.
 *
 * This can completely automate the interaction with Lua in some simple cases.
 * In the remaining cases, get a lua_State * or LuaContext & argument and, if
 * necessary, return an OnStack value. This allows for direct interaction
 * with the Lua stack.
 *
 * \param func_name A callable that matches the described requirements.
 * \return A lua_CFunction, that runs the provided function from Lua.
 */
#define LUA_TO_C_BIND(func_name) \
  ::Solarus::LuaBind::Private::LuaToC<decltype(func_name)>::call<func_name>

}

}

#include "solarus/lua/LuaBind.inl"

#endif
