---@class item : entity
---
---An equipment item represents something that the player can obtain (one or more times, in various forms and with several variants) and possibly keep. The Lua item type described in this page provides various functions to
---
---  * get and the possession state of a equipment item,
---  * set its properties, like whether the item is saved and has an amount,
---  * control its dynamic behavior, like what happens when the player uses this item (for items that can be used).
---
---
---
---A Lua item object represents a kind of treasure, and not a particular instance of treasures. Individual treasures may then be represented as [pickable treasures](https://doxygen.solarus-games.org/latest/lua_api_pickable.html), [chests](https://doxygen.solarus-games.org/latest/lua_api_chest.html), [shop treasures](https://doxygen.solarus-games.org/latest/lua_api_shop_treasure.html), and may be brandished by the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html). For example, multiple treasures of the kind `"rupee"` may exist at the same time during the [game](https://doxygen.solarus-games.org/latest/lua_api_game.html), but only one Lua item object manages them.
---
---The script file `items/XXXX.lua` defines the item named `XXXX`. The corresponding Lua item object is passed as parameter of that script. Use the Lua notation `"..."` to get this parameter and store it into a regular variable.
---
---Here is a basic example of script for the `rupee` item, an item whose only role is to increase the money of the player when he obtains a rupee. 
---    
---    
---    -- First, we put the parameter into a variable called "rupee".
---    -- (In Lua, the notation "..." refers to the parameter(s) of the script.)
---    local rupee = ...
---    
---    -- Event called when the hero obtains a rupee treasure.
---    function rupee:on_obtaining()
---      self:get_game():add_money(1)  -- Increase the money of 1 unit.
---    end
---    
---
---Remarks
---    All item scripts are loaded when you create a [savegame](https://doxygen.solarus-games.org/latest/lua_api_game.html) object. Indeed, equipment items only exist in the context of a particular savegame. As shown in the example above, you can retrieve that savegame with [item:get_game()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_get_game).
---     A [sprite](https://doxygen.solarus-games.org/latest/quest_sprite_data_file.html) animation named `XXXX` must also exist in the sprite `entities/items`: it is used by the engine whenever it needs to draw your item on the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html) (for example, when a [pickable treasure](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) of this kind is created on the map).
---
local m = {}

---
---Sets the name of the integer savegame value that stores the possession state of this item.
---
---You should call this function at initialization time if you want your item to be saved.
---
---  * `savegame_variable` (string): The savegame variable that should stored the possessed variant of this item, or `nil` to make this item unsaved.
---
---
---
---@param savegame_variable string
function m:set_savegame_variable(savegame_variable) end

---
---Sets the amount associated to this item (only for an item with an amount value). A negative amount will be replaced by `0`. An amount greater than [item:get_max_amount()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_get_max_amount) will be replaced by that maximum value.
---
---  * `amount` (number): The amount to set.
---
---
---
---@param amount number
function m:set_amount(amount) end

---
---Sets whether this item should be assignable to an item slot.
---
---When the item is assigned to a slot, the player can use it by pressing the [game command](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands) of this slot. Some items are meant to be used by pressing a command (like the bow), other are not supposed to (like a key or a rupee). When the player uses your item, the event [item:on_using()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_on_using) is triggered.
---
---By default, an item is not assignable. Call this function at initialization time if you want your item to be assignable.
---
---  * `assignable` (boolean, optional): `true` if this item is assignable (no value means `true`).
---
---
---
---@param assignable boolean|nil
function m:set_assignable(assignable) end

---
---Returns the name of the integer savegame value that stores the possession state of this item.
---
---  * Return value (string): The savegame variable that stores the possessed variant of this item, or `nil` if this item is not saved.
---
---
---
---@return string
function m:get_savegame_variable() end

---
---Returns whether this item has an associated amount, or whether the player has at least the specified value.
---
---  * `amount` (number, optional): The amount to check. If this parameter is not set, this function only tests whether an amount value exists for the item.
---  * Return value (boolean): If an amount is specified, return `true` if the player has at least that amount. Otherwise, returns `true` if the item has an amount value.
---
---
---
---Remarks
---    If an amount is specified, this method is equivalent to `item:get_amount() >= amount`. Otherwise, this method is equivalent to `item:get_amount_savegame_variable() ~= nil`.
---
---@param amount number|nil
---@return boolean
function m:has_amount(amount) end

---
---Returns the maximum amount associated to this item (only for an item with an amount value).
---
---  * Return value (number): The maximum amount.
---
---
---
---@return number
function m:get_max_amount() end

---
---Sets the name of the animation that should represent the shadow of this item in the sprite `"entities/shadow"`.
---
---When the engine needs to show a treasure representing your item, it sometimes also wants to display a shadow (in addition of the treasure's main sprite). For example, [pickable treasures](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) dropped by enemies normally have a shadow.
---
---The default shadow animation is `"big"`. You should call this function at initialization time if your item sprite is larger or smaller than usual.
---
---  * `shadow_animation` (string): Name of the shadow animation in the sprite `"entities/shadow"` to set for this item. `nil` means that no shadow will be displayed.
---
---
---
---Remarks
---    To draw a treasure, the engine relies on two sprites: the treasure's main sprite (`entities/item`) and the shadow's sprite (`entities/shadow`). Both sprites and their appropriate animations must exist so that treasures can be displayed correctly.
---
---@param shadow_animation string
function m:set_shadow(shadow_animation) end

---
---Returns the name of the integer savegame value that stores the amount associated to this item.
---
---  * Return value (string): The savegame variable that stores the possessed amount of this item, or `nil` if this item has no associated amount.
---
---
---
---@return string
function m:get_amount_savegame_variable() end

---
---Returns the possession state of this item (only for a saved item).
---
---  * Return value (number): The possession state (`0`: not possessed, `1`: first variant, `2`: second variant, etc.).
---
---
---
---Remarks
---    Equivalent to `item:get_game():get_value(item:get_savegame_variable())`.
---
---@return number
function m:get_variant() end

---
---Returns the amount associated to this item (only for an item with an amount value).
---
---  * Return value (number): The associated amount.
---
---
---
---Remarks
---    Equivalent to `item:get_game():get_value(item:get_amount_savegame_variable())`.
---
---@return number
function m:get_amount() end

---
---Sets the name of the integer savegame value that stores the amount of this item.
---
---You should call this function at initialization time if you want your item to store an amount (in addition to its possessed variant). This is typically used for items like the bow and the counter of bombs.
---
---  * Return value (string): The savegame variable that should store the possessed amount of this item, or `nil` to make this item have no associated amount.
---
---
---
---@return string
function m:set_amount_savegame_variable() end

---
---Notifies the engine that using this item is finished and that the hero can get back to a normal state.
---
---When the player uses this item (by pressing an item [game command](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands)), your item script takes full control of the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html) (event [item:on_using()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_on_using) is called) and you have to program the item's behavior. When it is finished, call this function to restore normal control to the player.
---
---This method should only be called when the hero is using this item.
---
---#  Events of an item
---
---Events are callback methods automatically called by the engine if you define them. In the case of a game, they are only called on the game currently running, if any.
---
function m:set_finished() end

---
---Sets whether [pickable treasures](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) of this kind should disappear after a few seconds when they are dropped by an [enemy](https://doxygen.solarus-games.org/latest/lua_api_enemy.html) or a [destructible entity](https://doxygen.solarus-games.org/latest/lua_api_destructible.html).
---
---By default, an item cannot disappear. Call this function at initialization time if you want your item to be ephemeral.
---
---  * `can_disappear` (boolean, optional): `true` to make such pickable treasures disappear after a few seconds (no value means `true`).
---
---
---
---Remarks
---    This property only applies to [pickable treasures](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) dropped dynamically (by [enemies](https://doxygen.solarus-games.org/latest/lua_api_enemy.html) and [destructible entities](https://doxygen.solarus-games.org/latest/lua_api_destructible.html)). Pickable treasures already present on the [map](https://doxygen.solarus-games.org/latest/lua_api_map.html) when the map starts don't disappear with time.
---
---@param can_disappear boolean|nil
function m:set_can_disappear(can_disappear) end

---
---Sets the sound to play when the hero [picks a treasure](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) of this kind.
---
---The default sound is `"picked_item"`.
---
---  * `sound_when_picked` (string): Name of the sound to play (as in [sol.audio.play_sound()](https://doxygen.solarus-games.org/latest/lua_api_audio.html#lua_api_audio_play_sound)) when the hero picks a treasure of this kind (`nil` means no sound).
---
---
---
---Remarks
---    This sound is always played, even if the treasure is also brandished then (i.e. if [item:get_brandish_when_picked()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_get_brandish_when_picked) returns `true`).
---
---@param sound_when_picked string
function m:set_sound_when_picked(sound_when_picked) end

---
---Returns the sound played when the hero brandishes a treasure of this kind.
---
---  * Return value (string): Name of the sound played when the hero brandishes a treasure of this kind (`nil` means no sound).
---
---
---
---@return string
function m:get_sound_when_brandished() end

---
---Returns the sound played when the hero [picks a treasure](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) of this kind.
---
---  * Return value (string): Name of the sound played when the hero picks a treasure of this kind (`nil` means no sound).
---
---
---
---@return string
function m:get_sound_when_picked() end

---
---Sets whether the hero should brandish treasures of this kind when he [picks](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) them on the ground.
---
---Treasures coming from a [chest](https://doxygen.solarus-games.org/latest/lua_api_chest.html) are always brandished, even the most basic ones like simple rupees. However, when treasures are [picked](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) on the ground (like rupees dropped by an [enemy](https://doxygen.solarus-games.org/latest/lua_api_enemy.html)), you may want the hero not to brandish them.
---
---By default, this property is `true`. Call this function if you don't want your item to be brandished when it is picked on the ground.
---
---  * `brandish_when_picked` (boolean, optional): `true` if the hero should brandish such treasures (no value means `true`).
---
---
---
---@param brandish_when_picked boolean|nil
function m:set_brandish_when_picked(brandish_when_picked) end

---
---Returns whether the item is currently being used by the [hero](https://doxygen.solarus-games.org/latest/lua_api_hero.html).
---
function m:is_being_used() end

---
---Sets the maximum amount associated to this item (only for an item with an amount value). This maximum value is used in [item:set_amount()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_set_amount) and [item:add_amount()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_add_amount) to make a limit. The default value is `1000`.
---
---  * `max_amount` (number): The maximum amount to set.
---
---
---
---Remarks
---    The maximum amount of an item is not saved automatically. Only the current variant (see [item:set_savegame_variable()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_set_savegame_variable)) and the current amount (see [item:set_amount_savegame_variable()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_set_amount_savegame_variable)) are saved by the engine. Therefore, you have to set the maximum amount of appropriate items when they are loaded (typically from event [item:on_started()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_on_started)).
---
---@param max_amount number
function m:set_max_amount(max_amount) end

---
---Returns the game where this item belongs.
---
---  * Return value ([game](https://doxygen.solarus-games.org/latest/lua_api_game.html)): The game that contains this item.
---
---
---
---Remarks
---    Items only exist in the context of a game, but the game is not necessarily running.
---
---@return game
function m:get_game() end

---
---Returns whether the player is allowed to obtain this item.
---
---If not, any treasure representing this item is automatically replaced by an empty treasure.
---
---  * Return value (boolean): `true` if this item is obtainable.
---
---
---
---@return boolean
function m:is_obtainable() end

---
---Decreases the amount associated to this item (only for an item with an amount value), without going below `0`.
---
---  * `amount` (number): The amount to remove.
---
---
---
---@param amount number
function m:remove_amount(amount) end

---
---Increases the amount associated to this item (only for an item with an amount value), without exceeding the maximum amount.
---
---  * `amount` (number): The amount to add.
---
---
---
---@param amount number
function m:add_amount(amount) end

---
---Sets the possession state of this item (only for a saved item).
---
---  * `variant` (number): The new possession state to set (`0`: not possessed, `1`: first variant, `2`: second variant, etc.)
---
---
---
---Remarks
---    Equivalent to `item:get_game():set_value(item:get_savegame_variable(), variant)`.
---
---@param variant number
function m:set_variant(variant) end

---
---Returns whether [pickable treasures](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) of this kind disappears after a few seconds when they are dropped by an [enemy](https://doxygen.solarus-games.org/latest/lua_api_enemy.html) or a [destructible entity](https://doxygen.solarus-games.org/latest/lua_api_destructible.html).
---
---  * Return value (boolean): `true` if pickable treasures of this kind can disappear.
---
---
---
---@return boolean
function m:get_can_disappear() end

---
---Returns whether this item can be assigned to an item slot.
---
---When the item is assigned to a slot, the player can use it by pressing the [game command](https://doxygen.solarus-games.org/latest/lua_api_game.html#lua_api_game_overview_commands) of that slot. Some items are meant to be used by pressing a command (like the bow), other are not supposed to (like a key or a rupee). When the player uses your item, the event [item:on_using()](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_on_using) is triggered.
---
---  * Return value (boolean): `true` if this item is assignable.
---
---
---
---@return boolean
function m:is_assignable() end

---
---Returns the name of the animation representing the shadow of this item in the sprite `"entities/shadow"`.
---
---  * Return value (string): Name of the shadow animation adapted to this item in the sprite `"entities/shadow"`. `nil` means no shadow displayed.
---
---
---
---@return string
function m:get_shadow() end

---
---Sets the sound to play when the hero brandishes a treasure of this kind.
---
---The hero can brandish treasures in various situations: when opening a [chest](https://doxygen.solarus-games.org/latest/lua_api_chest.html), when buying a [shop treasure](https://doxygen.solarus-games.org/latest/lua_api_shop_treasure.html), when picking up a [pickable treasure](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) (unless you called [item:set_brandish_when_picked(false)](https://doxygen.solarus-games.org/latest/lua_api_item.html#lua_api_item_set_brandish_when_picked)), and also when you call [hero:start_treasure()](https://doxygen.solarus-games.org/latest/lua_api_hero.html#lua_api_hero_start_treasure) directly.
---
---The default sound is `"treasure"`.
---
---  * `sound_when_brandished` (string): Name of the sound to play (as in [sol.audio.play_sound()](https://doxygen.solarus-games.org/latest/lua_api_audio.html#lua_api_audio_play_sound)) when the hero brandishes a treasure of this kind (`nil` means no sound).
---
---
---
---@param sound_when_brandished string
function m:set_sound_when_brandished(sound_when_brandished) end

---
---Returns whether the player owns at least the specified variant of this item (only for a saved item).
---
---  * `variant` (number, optional): The variant to check (default `1`).
---  * Return value (boolean): `true` if the player has at least this variant.
---
---
---
---Remarks
---    Equivalent to `item:get_variant() >= variant`.
---
---@param variant number|nil
---@return boolean
function m:has_variant(variant) end

---
---Returns the name of this item.
---
---  * Return value (string): The name that identifies this item. It is also the file name of the item script (without the extension).
---
---
---
---@return string
function m:get_name() end

---
---Returns whether the hero brandishes treasures of this kind when he [picks](https://doxygen.solarus-games.org/latest/lua_api_pickable.html) them on the ground.
---
---  * Return value (boolean): `true` if the hero brandish such treasures.
---
---
---
---@return boolean
function m:get_brandish_when_picked() end

---
---Sets whether the player is allowed to obtain this item.
---
---If not, any treasure representing this item is automatically replaced by an empty treasure. There is no risk that the player can obtain it or even see it during the [game](https://doxygen.solarus-games.org/latest/lua_api_game.html). You can use this feature to hide some items while the player has not the necessary equipment. For example, you can make arrows unobtainable until the player has the bow. You can also make magic jars unobtainable until the player has a magic bar.
---
---  * Return value (boolean, optional): `true` if this item is obtainable (no value means `true`).
---
---
---
---@return boolean|nil
function m:set_obtainable() end

---
---Returns the current map.
---
---  * Return value ([map](https://doxygen.solarus-games.org/latest/lua_api_map.html)): The current map, or `nil` if the [game](https://doxygen.solarus-games.org/latest/lua_api_game.html) is not running.
---
---
---
---@return map
function m:get_map() end

_G.item = m

return m