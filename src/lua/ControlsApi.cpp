/*
 * Copyright (C) 2018-2020 std::gregwar, Solarus - http://www.solarus-games.org
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
#include "solarus/lua/LuaBind.h"
#include "solarus/lua/LuaContext.h"
#include "solarus/lua/LuaTools.h"

#include "solarus/core/ControlsDispatcher.h"

namespace Solarus {

const std::string LuaContext::controls_module_name = "sol.controls";

// Define marchaling for Commands
namespace LuaBind {
template<>
struct Marshalling<Command>{
    using actual_arg_type = std::optional<std::string>;
    using actual_return_type = std::optional<std::string>;

    static inline Command marshall_from_lua(const actual_arg_type& str) {
      return str.has_value() ? Controls::get_command_by_name(*str) : Command(CommandId::NONE);
    }

    static inline actual_return_type marshall_to_lua(const Command& cmd) {
      auto str = Controls::get_command_name(cmd);
      return str.empty() ? std::nullopt : actual_return_type(str);
    }
};

template<>
struct Marshalling<Axis>{
    using actual_arg_type = std::optional<std::string>;
    using actual_return_type = std::optional<std::string>;

    static inline Axis marshall_from_lua(const actual_arg_type& str) {
      return str.has_value() ? Controls::get_axis_by_name(*str) : Axis(AxisId::NONE);
    }

    static inline actual_return_type marshall_to_lua(const Axis& axis) {
      auto str = Controls::get_axis_name(axis);
      return str.empty() ? std::nullopt : actual_return_type(str);
    }
};

template<>
struct Marshalling<Solarus::Controls::JoypadBinding>{
    using actual_arg_type = std::optional<std::string>;
    using actual_return_type = std::optional<std::string>;

    static inline Controls::JoypadBinding marshall_from_lua(const actual_arg_type& str) {
      return str.has_value() ? Controls::JoypadBinding(*str) : Controls::JoypadBinding(JoyPadButton::INVALID);
    }

    static inline actual_return_type marshall_to_lua(const Controls::JoypadBinding& binding) {
      return binding.is_invalid() ? std::nullopt : actual_return_type(binding.to_string());
    }
};

template<>
struct Marshalling<Controls::ControlAxisBinding>{
    using actual_arg_type = std::optional<std::string>;
    using actual_return_type = std::optional<std::string>;

    static inline Controls::ControlAxisBinding marshall_from_lua(const actual_arg_type& str) {
      return str.has_value() ? Controls::ControlAxisBinding{Controls::get_axis_by_name(*str)} : Controls::ControlAxisBinding{};
    }

    static inline actual_return_type marshall_to_lua(const Controls::ControlAxisBinding& binding) {
      auto str = Controls::get_axis_name(binding.axis);
      return str.empty() ? std::nullopt : actual_return_type(str);
    }
};

}

/**
 * \brief Implementation of sol.controls.create_from_keyboard().
 * \return A newly created control object with default keyboard mapping
 */
static ControlsPtr create_from_keyboard() {
  return ControlsDispatcher::get().create_commands_from_keyboard();
}

/**
 * \brief Implementation of sol.controls.create_from_joypad().
 * \param joypad a joypad to be tied to the control object
 * \return A newly created control object with default joypad mapping
 */
static ControlsPtr create_from_joypad(const JoypadPtr& joypad) {
    return ControlsDispatcher::get().create_commands_from_joypad(joypad);
}

/**
 * \brief Implementation of so.controls:get_direction
 * \param cmds the controls instance
 * \return a direction or nil if nothing is pressed
 */
static std::optional<int> get_direction(Controls& cmds) {
  int wanted_direction8 = cmds.get_wanted_direction8();
  if (wanted_direction8 == -1) {
    return {};
  }
  else {
    return wanted_direction8;
  }
}

/**
 * \brief Implementation of sol.controls:capture_bindings
 * \param cmds the control object
 * \param cmd the command to capture
 * \param callback an optional callback for when capture suceeds
 */
static void capture_bindings(Controls& cmds, Command cmd, std::optional<LuaBind::Callback> callback) {
  cmds.customize(cmd, callback.value_or(LuaBind::Callback()));
}

/**
 * \brief Implementation of sol.controls:simulate_pressed.
 * \param cmds the control object
 * \param command the command to simulate
 */
static void simulate_pressed(ControlsPtr cmds, Command command) {
  LuaContext::run_on_main([cmds, command](lua_State*){
    cmds->command_pressed(command);
  });
}

/**
 * \brief Implementation of sol.controls:simulate_released.
 * \param cmds the control object
 * \param command the command to simulate
 */
static void simulate_released(ControlsPtr cmds, Command command) {
  LuaContext::run_on_main([cmds, command](lua_State*){
    cmds->command_released(command);
  });
}

/**
 * \brief Implementation of sol.controls:simulate_axis_moved.
 * \param cmds the control object
 * \param axis the axis to move
 * \param state new state to put the axis in
 */
static void simulate_axis_moved(ControlsPtr cmds, Axis axis, double state) {
  LuaContext::run_on_main([cmds, axis, state](lua_State*){
    cmds->command_axis_moved(axis, state);
  });
}

void LuaContext::register_controls_module() {

  // Functions of sol.commands
  const std::vector<luaL_Reg> functions = {
    { "create_from_keyboard", LUA_TO_C_BIND(create_from_keyboard)},
    { "create_from_joypad", LUA_TO_C_BIND(create_from_joypad)},
    { "set_analog_commands_enabled", LUA_TO_C_BIND(Controls::set_analog_commands_enabled)},
    { "are_analog_commands_enabled", LUA_TO_C_BIND(Controls::are_analog_commands_enabled)}
  };

  // Methods of the commands type.
  const std::vector<luaL_Reg> methods = {
    { "is_pressed", LUA_TO_C_BIND(&Controls::is_command_pressed)},
    { "get_axis_state", LUA_TO_C_BIND(&Controls::get_axis_state)},
    { "get_direction", LUA_TO_C_BIND(get_direction)},
    { "set_keyboard_binding", LUA_TO_C_BIND(&Controls::set_keyboard_binding)},
    { "get_keyboard_binding", LUA_TO_C_BIND(&Controls::get_keyboard_binding)},
    { "set_joypad_binding", LUA_TO_C_BIND(&Controls::set_joypad_binding)},
    { "get_joypad_binding", LUA_TO_C_BIND(&Controls::get_joypad_binding)},
    { "get_keyboard_axis_binding", LUA_TO_C_BIND(&Controls::get_keyboard_axis_binding)},
    { "set_keyboard_axis_binding", LUA_TO_C_BIND(&Controls::set_keyboard_axis_binding)},
    { "set_joypad_axis_binding", LUA_TO_C_BIND(&Controls::set_joypad_axis_binding)},
    { "get_joypad_axis_binding", LUA_TO_C_BIND(&Controls::get_joypad_axis_binding)},

    { "set_keyboard_bindings", LUA_TO_C_BIND(&Controls::set_keyboard_bindings)},
    { "get_keyboard_bindings", LUA_TO_C_BIND(&Controls::get_keyboard_bindings)},
    { "set_joypad_bindings", LUA_TO_C_BIND(&Controls::set_joypad_bindings)},
    { "get_joypad_bindings", LUA_TO_C_BIND(&Controls::get_joypad_bindings)},
    { "get_keyboard_axis_bindings", LUA_TO_C_BIND(&Controls::get_keyboard_axis_bindings)},
    { "set_keyboard_axis_bindings", LUA_TO_C_BIND(&Controls::set_keyboard_axis_bindings)},
    { "set_joypad_axis_bindings", LUA_TO_C_BIND(&Controls::set_joypad_axis_bindings)},
    { "get_joypad_axis_bindings", LUA_TO_C_BIND(&Controls::get_joypad_axis_bindings)},

    { "capture_bindings", LUA_TO_C_BIND(capture_bindings)},
    { "simulate_pressed", LUA_TO_C_BIND(simulate_pressed)},
    { "simulate_released", LUA_TO_C_BIND(simulate_released)},
    { "simulate_axis_moved", LUA_TO_C_BIND(simulate_axis_moved)},
    { "set_joypad", LUA_TO_C_BIND(&Controls::set_joypad)},
    { "get_joypad", LUA_TO_C_BIND(&Controls::get_joypad)},
    { "remove", LUA_TO_C_BIND(&Controls::remove)}
  };

  // Metamethods of the commands type
  const std::vector<luaL_Reg> metamethods = {
    { "__gc", userdata_meta_gc },
    { "__newindex", userdata_meta_newindex_as_table },
    { "__index", userdata_meta_index_as_table },
  };

  register_type(controls_module_name, functions, methods, metamethods);
}

/**
 * @brief push a commands userdata on the lua stack
 * @param current_l lua state
 * @param joypad
 */
void LuaContext::push_controls(lua_State* current_l, Controls& commands) {
  push_userdata(current_l, commands);
}

/**
 * @brief check wheter a value on the stack is a joypad
 * @param current_l lua state
 * @param index index on the stack
 * @return
 */
bool LuaContext::is_controls(lua_State* current_l, int index) {
  return is_userdata(current_l,index, controls_module_name);
}

/**
 * @brief return a Shared Joypad from the lua stack
 * @param current_l lua state
 * @param index index on the stack
 * @return a joypad if index point to a true joypad
 */
std::shared_ptr<Controls> LuaContext::check_controls(lua_State* current_l, int index) {
  return std::static_pointer_cast<Controls>(check_userdata(
                                              current_l,index,controls_module_name)
                                            );
}

/**
 * @brief Check a command string on the stack
 * @param l the lua state
 * @param index index of the object on the stack
 * @return command sum type
 */
Command LuaContext::check_command(lua_State* l, int index) {
  std::string name = LuaTools::check_string(l, index);

  return Controls::get_command_by_name(name);
}

} //Solarus

