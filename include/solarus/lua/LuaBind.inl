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
#include <sstream>
#include <ostream>

#include "solarus/lua/LuaTools.h"

namespace Solarus {

namespace LuaBind {

[[noreturn]] void inline error(const CheckContext& ctx, lua_State* L, int sindex, const std::string & message) {
  ctx.error(L, sindex, message);
  std::abort(); // Convince GCC that this never returns
}

[[noreturn]] void inline type_error(const CheckContext& ctx, lua_State* L, int sindex, const std::string& type_name) {
  ctx.type_error(L, sindex, type_name);
  std::abort(); // Convince GCC that this never returns
}

namespace Private {
/* The Private namespace holds all the implementation details of LuaBind.
 * Many of these details involve all sorts of template meta-programming
 * tricks. From SFINAE and partial specialization to using overloading in
 * the right place and various type_traits helpers. Be prepared to look
 * some of them up if you are not already familiar with them.
 *
 * Hopefully good code design and documentation will make it easier to
 * follow. Also, the template function wrapper is the center of the design,
 * so that may be a good place to start.
 */

/**
 * \brief Convert a value on the Lua stack to the appropriate C/C++ type.
 * \tparam T The C/C++ type that matches the Lua type.
 * \param L The Lua state.
 * \param index An acceptable Lua index for the state.
 * \return The converted value.
 */
template<typename T>
static inline T to_type(lua_State * L, int index) {
  // This fakes explicit/full specialization in much less code.
  if constexpr (std::is_same_v<bool, T>) {
    return lua_toboolean(L, index);
  } else if constexpr (std::is_same_v<double, T>) {
    return lua_tonumber(L, index);
  } else if constexpr (std::is_same_v<int, T>) {
    return lua_tointeger(L, index);
  } else if constexpr (std::is_same_v<const char *, T>) {
    return lua_tostring(L, index);
  } else if constexpr (std::is_same_v<std::string, T>) {
    size_t len;
    const char * str = lua_tolstring(L, index, &len);
    return std::string(str, len);
  } else if constexpr (std::is_same_v<Callback, T>) {
    return LuaTools::create_ref(L, index);
  } else {
    static_assert(std::is_same_v<Nil, T>, "Unknown to_type template type.");
    (void)L;
    (void)index;
    return Nil();
  }
}

/**
 * \brief Check if a Lua value is an exported userdata of a given type.
 *
 * Note that this assumes that Solarus's shared_ptr system is being used,
 * including that the metatables and the type's module_name.
 * \tparam T The type of object exported to Lua.
 * \param L The Lua state.
 * \param index An acceptable Lua index for the state.
 * \return shared_ptr to the object if the value was of the correct type,
 *   otherwise returns empty shared_ptr.
 */
template<typename T>
std::shared_ptr<T> test_shared_exportable(lua_State * L, int index) {
  // Leaf types can be handled with a standard metatable test.
  if constexpr (std::is_final_v<T>) {
    void * data = LuaTools::test_userdata(L, index, T::module_name);
    return (data) ? *static_cast<std::shared_ptr<T> *>(data) : std::shared_ptr<T>();
  // Super-types are several types on Lua's side, this checks for them all.
  } else {
    std::string module_name;
    void * data = lua_touserdata(L, index);
    // Make sure this is a solarus userdata, with a known underlying type.
    if (data && LuaContext::is_solarus_userdata(L, index, module_name)) {
      auto ptr = static_cast<std::shared_ptr<ExportableToLua> *>(data);
      // Now we can rely on C++'s type infomation for the check.
      return std::dynamic_pointer_cast<T>(*ptr);
    }
    return {};
  }
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
T * test_exportable(lua_State * L, int index) {
  return test_shared_exportable<T>(L, index).get();
}

/// \copydoc push_any(lua_State*,bool)
///
/// Forward declaration because this wrapper can be used by other push_anys
template<typename T>
static inline auto push_any(lua_State * L, const T& v)
  -> decltype(Marshalling<std::decay_t<T>>::push, void());

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
static inline void push_any(lua_State * L, unsigned int integer) {
  // Lossy type conversion.
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
template<typename E>
static inline auto push_any(lua_State * L, E value)
    -> decltype(EnumInfoTraits<E>::pretty_name, void()) {
  push_any(L, enum_to_name<E>(value));
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
static inline void push_any(lua_State * L, const std::shared_ptr<T>& userdata) {
  LuaContext::push_userdata(L, *userdata);
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

/// \copydoc push_any(lua_State*,bool)
template<typename T>
static inline void push_any(lua_State * L, const std::vector<T>& vec) {
  // Build a Lua table containing the vector content.
  lua_createtable(L, vec.size(), 0);
  int i = 1;
  for (const auto& v : vec) {
    push_any(L, v);
    lua_rawseti(L, -2, i);
    ++i;
  }
}

/// \copydoc push_any(lua_State*,bool)
template<typename K, typename V>
static inline void push_any(lua_State * L, const std::map<K, V>& map) {
  // Build a Lua table containing the map content.
  lua_createtable(L, 0, map.size());
  for (const auto& [k, v] : map) {
    push_any(L, k);
    push_any(L, v);
    lua_rawset(L, -3);
  }
}

/// \copydoc push_any(lua_State*,bool)
template<typename T>
static inline auto push_any(lua_State * L, const T& v)
  -> decltype(Marshalling<std::decay_t<T>>::push, void()) {
  using M = Marshalling<std::decay_t<T>>;
  M::push(L, v);
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

/// \brief \ref LuaTypeId<T> specialization for Callback.
template<>
struct LuaTypeId<Callback> :
  public std::integral_constant<int, LUA_TFUNCTION> {};

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
 * \brief Get the Lua type name for a given type.
 *
 * This is a SFINAE helper for \ref get_type_name<T>().
 * Types can declare their Lua type name directly.
 * \tparam T The type being examined.
 * \return The type's name.
 */
template<typename T>
static inline auto get_type_name(int)
    -> decltype(T::type_name, std::string()) {
  return T::type_name;
}

/**
 * \brief Get the Lua type name for a given type.
 *
 * This is a SFINAE helper for \ref get_type_name<T>().
 * If there is not a dedicated type_name field, use the module_name.
 * \tparam T The type being examined.
 * \return The type's name.
 */
template<typename T>
static inline auto get_type_name(long)
    -> decltype(T::module_name, std::string()) {
  return LuaTools::get_type_name(T::module_name);
}

/**
 * \brief Get the Lua type name for a given type.
 * \tparam T The type being examined, must be a properly labeled class.
 * \return The type's name.
 */
template<typename T>
static inline std::string get_type_name() {
  return get_type_name<T>(0);
}

/**
 * @brief Abstract lua marshalling Context class implementing basic error function for context
 *
 * Uses the curiously recursive pattern to access child class implementation
 */
template<typename C>
struct CheckContextImpl : public CheckContext {
    [[noreturn]] void error(lua_State* L, int /*sindex*/, const std::string& message) const override {
      throw LuaException(L, message);
    }

    [[noreturn]] void type_error(lua_State* L, int sindex, const std::string& type_name) const override {
      LuaBind::error(*static_cast<const C*>(this), L, sindex, type_name + " expected, got " + LuaTools::get_type_name(L, sindex));
    }
};

/**
 * @brief Argument parsing context
 *
 * Used to represent lua checking context for an argument
 */
struct ArgContext : public CheckContextImpl<ArgContext> {
    ArgContext(int index) : index(index) {}

    int index;

    // Copied from LuaTools::arg_error...
    void error(lua_State* l, int sindex, const std::string& message) const override {
      int arg_index = this->index;

      std::ostringstream oss;
      lua_Debug info;
      if (!lua_getstack(l, 0, &info)) {
        // No stack frame.
        oss << "bad argument #" << arg_index << " (" << message << ")";
        CheckContextImpl::error(l, sindex, oss.str());
      }

      lua_getinfo(l, "n", &info);
      if (std::string(info.namewhat) == "method") {
         arg_index--;  // Do not count self.
         if (arg_index == 0) {
           // Error is in the self argument itself.
           oss << "calling " << info.name << " on bad self (" << message << ")";
           CheckContextImpl::error(l, sindex, oss.str());
         }
      }

      if (info.name == nullptr) {
        info.name = "?";
      }
      oss << "bad argument #" << arg_index << " to " << info.name << " (" << message << ")";
      CheckContextImpl::error(l, sindex, oss.str());
    }
};

/**
 * @brief Numeric field context class
 *
 * Used to hold context when checking an array value
 */
template<typename P>
struct NumFieldContext : public CheckContextImpl<NumFieldContext<P>> {
    int index;
    const P& parent;
    NumFieldContext(int index, const P& parent) : index(index), parent(parent) {}

    void error(lua_State* l, int sindex, const std::string& message) const override {
      parent.error(l, sindex, std::string("Bad field '[") + std::to_string(index) + "]': " + message);
    }
};

/**
 * @brief Key value context class
 *
 * Used to hold context when checking a map key
 */
template<typename P>
struct KeyContext : public CheckContextImpl<KeyContext<P>> {
    const P& parent;
    KeyContext(const P& parent) : parent(parent) {}

    void error(lua_State* l, int sindex, const std::string& message) const override {
      parent.error(l, sindex, std::string("Bad key : ") + message);
    }
};

/**
 * @brief Map value context class
 *
 * Used to hold context when checking a map value
 *
 * Note : Keytype K must be stringifiable to print proper error
 */
template<typename P, typename K>
struct ValueContext : public CheckContextImpl<ValueContext<P,K>> {
    const K& key;
    const P& parent;
    ValueContext(const K& key, const P& parent) : key(key), parent(parent) {}

    void error(lua_State* l, int sindex, const std::string& message) const override {

      auto key_str = [this](){
        if constexpr(std::is_enum_v<K>) {
          return enum_to_name<K>(key);
        } else {
          return key.to_string();
        }
      }();

      parent.error(l, sindex, std::string("Bad field '") + key_str + "': " + message);
    }
};

/// Forward declaration
template<typename T>
T check_arg(lua_State* L, int index, const CheckContext& context);

/**
 * \brief Check the type of the argument at index, return it if the type is
 *   correct, otherwise raise a type error.
 * \tparam T C/C++ type to return, should be from AsReturn.
 * \param L The Lua stack.
 * \param index The index on the stack to check.
 */
template<typename T, typename = void>
struct CheckArg {
  static T call(lua_State * L, int index, const CheckContext& context) {
    // Handle Userdata Types:
    if constexpr (std::is_convertible_v<T, ExportableToLua&>) {
      using base_t = std::remove_reference_t<T>;
      if (base_t * ptr = test_exportable<base_t>(L, index)) {
        return *ptr;
      }
      type_error(context, L, index, get_type_name<base_t>());
    // Handle Enumeration Types:
    } else if constexpr (std::is_enum_v<T>) {
      return LuaTools::check_enum<T>(L, index);
    // Handle Primitive Types:
    } else {
      if (LuaTypeId<T>::value == lua_type(L, index)) {
        return to_type<T>(L, index);
      }
      const char * name = lua_typename(L, LuaTypeId<T>::value);
      type_error(context, L, index, name);
    }
  }
};

/**
 * Forward declaration to be able to use it from others
 */
template<typename T>
struct CheckArg<T, decltype(void(Marshalling<T>::check_arg))>;

/**
 * \brief \ref CheckArg<T> specialization for optional primitive types.
 *
 * If the value is of the correct type, returns it in the optional. If the
 * value is nil or none, returns an empty optional. Except for nil for
 * booleans, where it is a type error, as are all the remaining cases.
 */
template<typename T>
struct CheckArg<std::optional<T>> {
  static std::optional<T> call(lua_State * L, int index, const CheckContext& context) {
    // Handle Enumeration Types:
    if constexpr (std::is_enum_v<T>) {
      // Explicitely ask for a string before checking its value.
      const auto& opt_name =
          check_arg<std::optional<std::string>>(L, index, context);
          //CheckArg<std::optional<std::string>>::call(L, index);
      if (!opt_name.has_value()) return std::nullopt;
      const std::string& name = opt_name.value();

      const std::map<T, std::string>& names = EnumInfoTraits<T>::names;
      for (const auto& kvp : names) {
        if (kvp.second == name) {
          return std::make_optional(kvp.first);
        }
      }
      // This error message doesn't mention that the value is optional.
      error(context, L, index, check_enum_error_message(name, names));
    // Handle Primitive Types:
    } else {
      if (LuaTypeId<T>::value == lua_type(L, index)) {
        return std::optional<T>(to_type<T>(L, index));
      }
      // This case makes the handling of bool consistent with opt_boolean.
      if constexpr (std::is_same_v<bool, T>) {
        if (lua_isnone(L, index)) {
          return std::nullopt;
        }
      } else {
        if (lua_isnoneornil(L, index)) {
          return std::nullopt;
        }
      }
      std::string name = lua_typename(L, LuaTypeId<T>::value);
      type_error(context, L, index, "optional " + name);
    }
  }
};

/**
 * \brief \ref CheckArg<T> specialization for shared_ptr<T> types.
 *
 * If the value is of the correct type and exportable_to_lua, returns it in a shared_ptr
 */
template<typename T>
struct CheckArg<std::shared_ptr<T>> {
  static std::shared_ptr<T> call(lua_State * L, int index, const CheckContext& context) {
    if (auto sptr = test_shared_exportable<T>(L, index)) {
      return sptr;
    }
    type_error(context, L, index, get_type_name<T>());
  }
};

/**
 * \brief \ref CheckArg<T> specialization for vector types.
 *
 * Checks if value is a table and then recursively checks each non-nil T element
 */
template<typename T>
struct CheckArg<std::vector<T>> {
  static std::vector<T> call(lua_State * L, int index, const CheckContext& context) {
    if(lua_type(L, index) != LUA_TTABLE) {
      type_error(context, L, index, "array");
    }

    auto len = lua_objlen(L, index);
    std::vector<T> vec; vec.reserve(len);

    for(size_t i = 1; i < len+1; i++) {
      lua_rawgeti(L, index, i);
      vec.push_back(check_arg<T>(L, -1, NumFieldContext(i, context)));
      lua_pop(L, 1);
    }

    return vec;
  }
};

/**
 * \brief \ref CheckArg<T> specialization for map types.
 *
 * Checks if value is a table and then recursively checks each non-nil K,V pair
 */
template<typename K, typename V>
struct CheckArg<std::map<K, V>> {
  static std::map<K, V> call(lua_State * L, int index, const CheckContext& context) {
    if(lua_type(L, index) != LUA_TTABLE) {
      context.type_error(L, index, "map");
    }

    std::map<K, V> map;
    lua_pushnil(L);
    while(lua_next(L, index) != 0) {
      auto k = check_arg<K>(L,-2, KeyContext(context));
      auto v = check_arg<V>(L,-1, ValueContext(k,context));
      map.insert({k,v});
      lua_pop(L, 1);
    }

    return map;
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
  static T * call(lua_State * L, int index, const CheckContext& context) {
    if (T * ptr = test_exportable<T>(L, index)) {
      return ptr;
    } else if (lua_isnoneornil(L, index)) {
      return nullptr;
    }
    context.type_error(L, index, "optional " + get_type_name<T>());
  }
};

/**
 * \brief \ref CheckArg<T> specialization for types that have a Marshalling<T> specialization
 *
 * This enables client code to specify how to convert checked lua args to C++ args
 * see \ref LuaBind::Marshalling<T>
 */
template<typename T>
struct CheckArg<T, decltype(void(Marshalling<T>::check_arg))>{
  static inline auto call(lua_State* L, int index, const CheckContext& context) -> decltype(auto) {
    using M = LuaBind::Marshalling<T>;
    return M::check_arg(L, index, context);
  }
};

/**
 * @brief template deduction helper for the CheckArg class
 * @param L the lua state
 * @param index lua stack index
 * @param context a deduced checking context
 * @return a checked value
 */
template<typename T>
T check_arg(lua_State* L, int index, const CheckContext& context) {
  return CheckArg<T>::call(L, index, context);
}

/**
 * \brief Check the types of all arguments and return them as a tuple.
 * \tparam Args Arguments to get from Lua. Should be types from AsReturn.
 */
template<typename... Args>
struct CheckArgs {
  /**
   * \brief The result of the functions in this class.
   */
  using ret_t = std::tuple<LuaContext &, Args...>;

  /**
   * \brief Get all arguments and return the result tuple (private).
   *
   * This creates a zip for the Args and their index in the parameter pack.
   * \tparam Inds Must always be 0, 1, ... sizeof(Args)-1.
   * \param context The LuaContext with the arguments.
   */
  template<int... Inds>
  static ret_t help(LuaContext & context, std::integer_sequence<int, Inds...>) {
    // This mimimizes calls to get_internal_state and avoids warnings.
    if constexpr (0 != sizeof...(Inds)) {
      lua_State * L = context.get_internal_state();
      return ret_t(context, check_arg<Args>(L, Inds + 1, ArgContext(Inds + 1))...);
    } else {
      return ret_t(context);
    }
  }

  /**
   * \brief Get all arguments and return the result tuple.
   * \param context The Lua context to read from.
   */
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
  // Decide how to handle arguments:
  using CheckArgs = Private::CheckArgs<typename AsReturn<Args>::type...>;
  // State and error handling:
  LuaContext & context = LuaContext::get();
  return context.state_boundary_handle(L, [&context, func](){
    // Decide how to handle the return value (and make the call):
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

/**
 * \brief Adapter type to make functions match the wrapper function.
 *
 * Every specialization adds a `call` template static method that is the
 * adapter itself, parameterized over the adapted function.
 *
 * \tparam FuncType The type of function to adapt.
 */
template<typename FuncType>
struct AdaptC;

/**
 * \brief \ref LuaToC<FuncType> specialization for simple functions.
 *
 * A simple function is one that has all arguments that can be taken from Lua.
 */
template<typename Ret, typename... Args>
struct AdaptC<Ret(Args...)> {
  template<Ret(*func)(Args...)>
  static Ret call(LuaContext&, Args... args) {
    return func(std::forward<Args>(args)...);
  }
};

/**
 * \brief \ref LuaToC<FuncType> specialization for functions with a lua_State.
 *
 * The lua_State * must be the first argument and the rest must be standard.
 */
template<typename Ret, typename... Args>
struct AdaptC<Ret(lua_State *, Args...)> {
  template<Ret(*func)(lua_State *, Args...)>
  static Ret call(LuaContext& context, Args... args) {
    return func(context.get_internal_state(), std::forward<Args>(args)...);
  }
};

/**
 * \brief \ref LuaToC<FuncType> specialization for const methods.
 *
 * The object type and all arguments must be types we can get from Lua.
 */
template<typename Ret, typename Class, typename... Args>
struct AdaptC<Ret(Class::*)(Args...) const> {
  template<Ret(Class::*func)(Args...) const>
  static Ret call(LuaContext&, Class& object, Args... args) {
    return (object.*func)(std::forward<Args>(args)...);
  }
};

/**
 * \brief \ref LuaToC<FuncType> specialization for methods.
 *
 * The object type and all arguments must be types we can get from Lua.
 */
template<typename Ret, typename Class, typename... Args>
struct AdaptC<Ret(Class::*)(Args...)> {
  template<Ret(Class::*func)(Args...)>
  static Ret call(LuaContext&, Class& object, Args... args) {
    return (object.*func)(std::forward<Args>(args)...);
  }
};

/**
 * \brief Interface to create Lua functions that run C code.
 *
 * \tparam FuncType The type of function to run (see LUA_TO_C_BIND).
 */
template<typename FuncType>
struct LuaToC {
  /**
   * \brief Run C code from Lua.
   * \tparam func The C function to run from Lua.
   * \param L The Lua stack.
   * \return The number of return values on the Lua stack.
   */
  template<FuncType func>
  static constexpr int call(lua_State * L) {
    return wrapper(L, AdaptC<FuncType>::template call<func>);
  }
};

/**
 * \brief \ref LuaToC<FuncType> specialization for unadapted functions.
 */
template<typename Ret, typename... Args>
struct LuaToC<Ret(LuaContext&, Args...)> {
  template<Ret(*func)(LuaContext&, Args...)>
  static constexpr int call(lua_State * L) {
    return wrapper(L, func);
  }
};

} // namespace Private

} // namespace LuaBind

} // namespace Solarus
