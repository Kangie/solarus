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

#include <lua.hpp>
#include <utility>
#include <tuple>
#include <type_traits>

#include "solarus/lua/LuaTools.h"

namespace Solarus {

namespace LuaBind {

namespace Private {

/**
 * \brief Check if a value on the Lua stack is of the appropriate type.
 * \tparam T The C/C++ type that matches the Lua type.
 * \param L The Lua state.
 * \param index An acceptable Lua index for the state.
 * \return True if the index contains a Lua value of the appropriate type,
 *   otherwise false.
 */
template<typename T>
static inline bool index_is(lua_State * L, int index);

/// \brief \ref index_is<T>(lua_State*,int) specialization for bool.
template<>
bool index_is<bool>(lua_State * L, int index) {
  return lua_isboolean(L, index);
}

/// \brief \ref index_is<T>(lua_State*,int) specialization for double.
template<>
bool index_is<double>(lua_State * L, int index) {
  return lua_isnumber(L, index);
}

/// \brief \ref index_is<T>(lua_State*,int) specialization for int.
template<>
bool index_is<int>(lua_State * L, int index) {
  return lua_isnumber(L, index);
}

/// \brief \ref index_is<T>(lua_State*,int) specialization for C-style strings.
template<>
bool index_is<const char *>(lua_State * L, int index) {
  return lua_isstring(L, index);
}

/// \brief \ref index_is<T>(lua_State*,int) specialization for std::string.
template<>
bool index_is<std::string>(lua_State * L, int index) {
  return lua_isstring(L, index);
}

/// \brief \ref index_is<T>(lua_State*,int) specialization for Nil.
template<>
bool index_is<Nil>(lua_State * L, int index) {
  return lua_isnil(L, index);
}

/**
 * \brief Convert a value on the Lua stack to the appropriate C/C++ type.
 * \tparam T The C/C++ type that matches the Lua type.
 * \param L The Lua state.
 * \param index An acceptable Lua index for the state.
 * \return The converted value.
 */
template<typename T>
static inline T index_to(lua_State * L, int index);

/// \brief \ref index_to<T>(lua_State*,int) specialization for bool.
template<>
bool index_to<bool>(lua_State * L, int index) {
  return lua_toboolean(L, index);
}

/// \brief \ref index_to<T>(lua_State*,int) specialization for double.
template<>
double index_to<double>(lua_State * L, int index) {
  return lua_tonumber(L, index);
}

/// \brief \ref index_to<T>(lua_State*,int) specialization for int.
template<>
int index_to<int>(lua_State * L, int index) {
  return lua_tointeger(L, index);
}

/// \brief \ref index_to<T>(lua_State*,int) specialization for C-style strings.
template<>
const char * index_to<const char *>(lua_State * L, int index) {
  return lua_tostring(L, index);
}

/// \brief \ref index_to<T>(lua_State*,int) specialization for std::string.
template<>
std::string index_to<std::string>(lua_State * L, int index) {
  size_t len;
  const char * str = lua_tolstring(L, index, &len);
  return std::string(str, len);
}

/// \brief \ref index_to<T>(lua_State*,int) specialization for Nil.
template<>
Nil index_to<Nil>(lua_State * L, int index) {
  (void)L;
  (void)index;
  return Nil();
}

/**
 * \brief Check if a Lua value is an exported userdata of a given type.
 *
 * Note that this assumes that Solarus's shared_ptr system is being used,
 * including that the metatables and the type's module_name.
 * \tparam T The type of object exported to Lua.
 * \param L The Lua state.
 * \param index An acceptable Lua index for the state.
 * \return Pointer to the object if the value was of the correct type,
 *   otherwise returns nullptr.
 */
template<typename T>
T * test_exportable(lua_State * l, int index) {
  void* udata = LuaTools::test_userdata(l, index, T::module_name);
  return (udata) ? static_cast<std::shared_ptr<T> *>(udata)->get() : nullptr;
}

/**
 * \brief \ref test_exportable<T>(lua_State*,int) specialization for Drawable.
 *
 * Drawable is not a leaf type so it must check for each of its children.
 */
template<>
Drawable * test_exportable(lua_State * l, int index) {
  if (Surface * ptr = test_exportable<Surface>(l, index)) {
    return ptr;
  } else if (TextSurface * ptr = test_exportable<TextSurface>(l, index)) {
    return ptr;
  } else if (Sprite * ptr = test_exportable<Sprite>(l, index)) {
    return ptr;
  }
  return nullptr;
}

/**
 * \brief Push a value onto a Lua stack.
 * \param L The Lua stack.
 * \param value The value to push to Lua.
 */
static inline void push_any(lua_State * L, bool boolean) {
  lua_pushboolean(L, boolean);
}

/// \copydoc push_any(lua_State*,bool)
static inline void push_any(lua_State * L, double number) {
  lua_pushnumber(L, number);
}

/// \copydoc push_any(lua_State*,bool)
static inline void push_any(lua_State * L, int integer) {
  lua_pushinteger(L, integer);
}

/// \copydoc push_any(lua_State*,bool)
static inline void push_any(lua_State * L, const char * str) {
  lua_pushstring(L, str);
}

/// \copydoc push_any(lua_State*,bool)
static inline void push_any(lua_State * L, const std::string& str) {
  lua_pushlstring(L, str.c_str(), str.size());
}

/// \copydoc push_any(lua_State*,bool)
static inline void push_any(lua_State * L, ExportableToLua& userdata) {
  LuaContext::push_userdata(L, userdata);
}

/// \copydoc push_any(lua_State*,bool)
template<typename T>
static inline void push_any(lua_State * L, const std::optional<T>& option) {
  if (option.has_value()){
    push_any(L, *option);
  } else {
    lua_pushnil(L);
  }
}

/// \copydoc push_any(lua_State*,bool)
template<typename T>
static inline void push_any(lua_State * L, T * ptr) {
  if (nullptr != ptr) {
    push_any(L, *ptr);
  } else {
    lua_pushnil(L);
  }
}

/**
 * \brief Push each value to Lua, from left to right.
 * \tparam Args Types of the arguments to push to Lua.
 * \param L The Lua stack.
 * \param args The values to push to Lua.
 */
template<typename... Args>
static inline void push_all(lua_State * L, Args&&... args) {
  // Comma operator enforces ordering.
  (push_any(L, std::forward<Args>(args)), ...);
}

/**
 * \brief Push a return value to Lua.
 * \tparam T The value to push to lua.
 * \param L The Lua stack to push to.
 * \param value The value to push.
 * \return The number of values pushed to Lua.
 */
template<typename T>
static int push_ret(lua_State * L, T && value) {
  push_any(L, value);
  return 1;
}

/**
 * \brief Push a tuple of return values to Lua.
 * \tparam Ts The members of the tuple.
 * \param L The Lua stack to push to.
 * \param value The tuple to push.
 * \return The number of values pushed to Lua.
 */
template<typename... Ts>
static int push_ret(lua_State * L, std::tuple<Ts...> && tuple) {
  std::apply(push_all<Ts...>, std::tuple_cat(std::make_tuple(L), tuple));
  return sizeof...(Ts);
}

/**
 * \brief Get the id for the Lua type that encodes a given C/C++ type.
 * \tparam T The C/C++ type.
 */
template<typename T>
struct LuaTypeId;

/// \brief \ref LuaTypeId<T> specialization for bool.
template<>
struct LuaTypeId<bool> :
  public std::integral_constant<int, LUA_TBOOLEAN> {};

/// \brief \ref LuaTypeId<T> specialization for double.
template<>
struct LuaTypeId<double> :
  public std::integral_constant<int, LUA_TNUMBER> {};

/// \brief \ref LuaTypeId<T> specialization for int.
template<>
struct LuaTypeId<int> :
  public std::integral_constant<int, LUA_TNUMBER> {};

/// \brief \ref LuaTypeId<T> specialization for C-style strings.
template<>
struct LuaTypeId<const char *> :
  public std::integral_constant<int, LUA_TSTRING> {};

/// \brief \ref LuaTypeId<T> specialization for std::string.
template<>
struct LuaTypeId<std::string> :
  public std::integral_constant<int, LUA_TSTRING> {};

/// \brief \ref LuaTypeId<T> specialization for Nil.
template<>
struct LuaTypeId<Nil> :
  public std::integral_constant<int, LUA_TNIL> {};

/**
 * \brief Convert a type to a standard returnable form.
 * \tparam T A type to convert.
 */
template<typename T>
struct AsReturn {
  using is_exportable = std::is_convertible<T, ExportableToLua&>;
  using base_t = std::remove_cv_t<std::remove_reference_t<T>>;
  using type = std::conditional_t<is_exportable::value, base_t &, base_t>;
};

/**
 * \brief Check the type of the argument at index, return it if the type is
 *   correct, otherwise raise a type error.
 * \tparam T C/C++ type to return, should be from AsReturn.
 * \param L The Lua stack.
 * \param index The index on the stack to check.
 */
template<typename T>
struct CheckArg {
  static T call(lua_State * L, int index) {
    // Handle Userdata Types:
    if constexpr (std::is_convertible_v<T, ExportableToLua&>) {
      using base_t = std::remove_reference_t<T>;
      if (base_t * ptr = test_exportable<base_t>(L, index)) {
        return *ptr;
      }
      std::string name = LuaTools::get_type_name(base_t::module_name);
      LuaTools::type_error(L, index, name);
    // Handle Primitive Types:
    } else {
      if (index_is<T>(L, index)) {
        return index_to<T>(L, index);
      }
      const char * name = lua_typename(L, LuaTypeId<T>::value);
      LuaTools::type_error(L, index, name);
    }
  }
};

/**
 * \brief \ref CheckArg<T> specialization for optional primitive types.
 *
 * If the value is of the correct type, returns it in the optional. If the
 * value is nil or none, returns an empty optional.
 */
template<typename T>
struct CheckArg<std::optional<T>> {
  static std::optional<T> call(lua_State * L, int index) {
    if (index_is<T>(L, index)) {
      return std::optional<T>(index_to<T>(L, index));
    } else if (lua_isnoneornil(L, index)) {
      return std::nullopt;
    }
    std::string name = lua_typename(L, LuaTypeId<T>::value);
    LuaTools::type_error(L, index, "optional " + name);
  }
};

/**
 * \brief \ref CheckArg<T> specialization for optional userdata types.
 *
 * If the value is of the correct type, returns a pointer to it. If the
 * value is nil or none, returns a null pointer.
 */
template<typename T>
struct CheckArg<T *> {
  static T * call(lua_State * L, int index) {
    if (T * ptr = test_exportable<T>(L, index)) {
      return ptr;
    } else if (lua_isnoneornil(L, index)) {
      return nullptr;
    }
    std::string name = LuaTools::get_type_name(T::module_name);
    LuaTools::type_error(L, index, "optional " + name);
  }
};

/**
 * \brief \ref CheckArg<T> specialization for Drawable.
 *
 * Same behaviour as the unspecialized version.
 */
template<>
struct CheckArg<Drawable &> {
  static Drawable & call(lua_State * L, int index) {
    if (Drawable * ptr = test_exportable<Drawable>(L, index)) {
      return *ptr;
    }
    LuaTools::type_error(L, index, "drawable");
  }
};

/**
 * \brief Check the types of all arguments and return them as a tuple.
 * \tparam Args Arguments to get from Lua. Should be types from AsReturn.
 */
template<typename... Args>
struct CheckArgs {
  using ret_t = std::tuple<LuaContext &, Args...>;

  template<int... Inds>
  static ret_t help(LuaContext & context, std::integer_sequence<int, Inds...>) {
    lua_State * l = context.get_internal_state();
    return ret_t{context, CheckArg<Args>::call(l, Inds + 1)...};
  }

  static ret_t call(LuaContext & context) {
    return help(context, std::make_integer_sequence<int, sizeof...(Args)>());
  }
};

/**
 * \brief Run a function in the engine's context from Lua.
 * \tparam Ret The return type of the wrapped function.
 * \tparam Args The types of the additional arguments of the wrapped function.
 * \param L The Lua stack.
 * \param func The function to call in the engine's context.
 * \return The number of return values on the Lua stack.
 */
template<typename Ret, typename... Args>
int wrapper(lua_State * L, Ret(*func)(LuaContext&, Args...)) {
  using CheckArgs = Private::CheckArgs<typename AsReturn<Args>::type...>;
  LuaContext & context = LuaContext::get();
  return context.state_boundary_handle(L, [&context, func](){
    if constexpr (std::is_same_v<void, Ret>) {
      std::apply(func, CheckArgs::call(context));
      return 0;
    } else if constexpr (std::is_same_v<OnStack, Ret>) {
      return std::apply(func, CheckArgs::call(context)).count;
    } else {
      return push_ret(context.get_internal_state(),
        std::apply(func, CheckArgs::call(context)));
    }
  });
}

} // Private

/**
 * \brief \ref LuaToC<FuncType> specialization for simple functions.
 *
 * A simple function is one that has all arguments that can be taken from Lua.
 */
template<typename Ret, typename... Args>
class LuaToC<Ret(Args...)> {
  template<Ret (*func)(Args...)>
  static Ret runc(LuaContext&, Args... args) {
    return func(std::forward<Args>(args)...);
  }
public:
  template<Ret (*func)(Args...)>
  static constexpr int call(lua_State * L) {
    return Private::wrapper(L, runc<func>);
  }
};

/**
 * \brief \ref LuaToC<FuncType> specialization for functions with a lua_State.
 *
 * The lua_State * must be the first argument and the rest must be standard.
 */
template<typename Ret, typename... Args>
class LuaToC<Ret(lua_State *, Args...)> {
  template<Ret(*func)(lua_State *, Args...)>
  static Ret runc(LuaContext& context, Args... args) {
    return func(context.get_internal_state(), std::forward<Args>(args)...);
  }
public:
  template<Ret(*func)(lua_State *, Args...)>
  static constexpr int call(lua_State * L) {
    return Private::wrapper(L, runc<func>);
  }
};

/**
 * \brief \ref LuaToC<FuncType> specialization for functions with a LuaContext.
 *
 * The LuaContext& must be the first argument and the rest must be standard.
 */
template<typename Ret, typename... Args>
class LuaToC<Ret(LuaContext&, Args...)> {
public:
  template<Ret(*func)(LuaContext&, Args...)>
  static constexpr int call(lua_State * L) {
    return Private::wrapper(L, func);
  }
};

/**
 * \brief \ref LuaToC<FuncType> specialization for const methods.
 *
 * The object type and all arguments must be types we can get from Lua.
 */
template<typename Ret, typename Class, typename... Args>
class LuaToC<Ret(Class::*)(Args...) const> {
  template<Ret(Class::*func)(Args...) const>
  static Ret runc(LuaContext&, Class& object, Args... args) {
    return (object.*func)(std::forward<Args>(args)...);
  }
public:
  template<Ret (Class::*func)(Args...) const>
  static constexpr int call(lua_State * L) {
    return Private::wrapper(L, runc<func>);
  }
};

/**
 * \brief \ref LuaToC<FuncType> specialization for methods.
 *
 * The object type and all arguments must be types we can get from Lua.
 */
template<typename Ret, typename Class, typename... Args>
class LuaToC<Ret(Class::*)(Args...)> {
  template<Ret(Class::*func)(Args...)>
  static Ret runc(LuaContext&, Class& object, Args... args) {
    return (object.*func)(std::forward<Args>(args)...);
  }
public:
  template<Ret (Class::*func)(Args...)>
  static constexpr int call(lua_State * L) {
    return Private::wrapper(L, runc<func>);
  }
};

}

}
