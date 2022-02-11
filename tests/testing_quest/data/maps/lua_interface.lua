-- Lua script of map lua_interface.
-- General tests for the conversions between Lua and the engine.

local map = ...
local game = map:get_game()

function map:on_started()

  -- Does the "middle type" check work.
  local x, y = 128, 128

  local sprite = sol.sprite.create('blocks/block_brown')
  self:draw_visual(sprite, x, y)

  local hero = self:get_hero()
  assert_error{self.draw_visual, self, hero, x, y}

  sol.main.exit()
end
