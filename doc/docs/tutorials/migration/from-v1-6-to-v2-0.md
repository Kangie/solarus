# Upgrade Your Quest from Solarus 1.6 to Solarus 2.0

The multiplayer update! Solarus now supports multiple maps, cameras, heroes and game controllers.
We also provide brand new APIs for [controllers](../../lua-api/controls/overview.md) with much better joypad support, [music](../../lua-api/audio/music.md) and [sound](../../lua-api/audio/sound.md) with a lot of customization.

As always, you should make a backup before any upgrade.

In this page, we only focus on the incompatibilities. See the [changelog](https://gitlab.com/solarus-games/solarus/-/blob/master/changelog.md) to know more about the new features.

!!! note "Compatibility layer with 1.5/1.6"
    Good news for players!
    Quests in format 1.5 and 1.6 can still be played by Solarus 2.0 with no modification. Indeed, Solarus 2.0 will detect their old version in `quest.dat` and will keep the old and fully compatible API for them. It is only when you upgrade your quest to 2.0 that your quest gets the new API, and that you need to take care of instructions on this page.

## Upgrading Data Files

Data files other than scripts can be upgraded automatically with Solarus Editor. Open your quest with Solarus Editor 2.0 and a dialog will guide you to upgrade data files.

## Upgrading Lua Scripts

The Lua scripting API of Solarus 2.0 introduces a small number of incompabilities in order to enable better joypad support.
We give below the list of potential incompatilibies you may have to take care of when upgrading your quest to the Solarus 2.0 format.

### Joypad input event button names

Joypad input events now provide button names instead of numbers.

In more details,
`on_joypad_button_pressed(button_number)`,
`on_joypad_button_released(button_number)` and
`on_joypad_axis_moved(axis_number)`
are replaced by
[`on_joypad_button_pressed(button_name, joypad)`](../../lua-api/controls/inputs.md#handleron_joypad_button_pressedbutton-joypad),
[`on_joypad_button_released(button_name, joypad)`](../../lua-api/controls/inputs.md#handleron_joypad_button_releasedbutton-joypad),
[`on_joypad_axis_moved(axis_name, joypad)`](../../lua-api/controls/inputs.md#handleron_joypad_axis_movedaxis-state-joypad).

These events exist on various Solarus objects: [sol.main](../../lua-api/general-features.md), the current [game](../../lua-api/game.md), [maps](../../lua-api/map.md), hero [custom states](../../lua-api/custom-states.md) and [menus](../../lua-api/menus.md). Instead of being called with a number that does not help much, they will now be called with a meaningful name.

For compatibility, as explained in the "compatibility layer" note above, quests with format 1.5 or 1.6 in their `quest.dat` file will still receive a number as parameter in these events, even when you run them with Solarus 2.0.

### No more automatic saving of commands

Commands are no longer saved by default, because there can be now multiple joypads, multiple inputs bound to the same commands, custom commands and even possibly multiple heroes. So we think is better to let quests handle saving controls their own way, as there are now too many possible use cases.
However, you can use [`game:set_legacy_controls_storage(true)`](../../lua-api/game.md#gameset_legacy_controls_storagelegacy_controls_storage) to continue to automatically save commands the pre Solarus 2.0 way.

Quests with format 1.5 or 1.6, and quests that call [`game:set_legacy_controls_storage(true)`](../../lua-api/game.md#gameset_legacy_controls_storagelegacy_controls_storage) will still automatically load and save game commands for the main hero.
This function is provided for quests that were designed before Solarus 2.0, and for quests that accept the limitations of this automatic commands storage.

### Minor Incompatibilities

The remaining incompatibilities in the Solarus API are less disruptive. They should not have any consequence in most games, and if they do, they should be easy to address. Yet, we provide them here for completeness.

- `hero:teleport()` now also teleports the camera instead of recreating one.

- `hero:get_sword_sound_id()` now returns `nil` if there is no sword sound.
