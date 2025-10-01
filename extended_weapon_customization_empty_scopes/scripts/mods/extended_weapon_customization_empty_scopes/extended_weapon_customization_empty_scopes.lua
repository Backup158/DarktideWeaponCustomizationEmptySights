local mod = get_mod("extended_weapon_customization_empty_scopes")

-- ##### ┌─┐┌─┐┬─┐┌─┐┌─┐┬─┐┌┬┐┌─┐┌┐┌┌─┐┌─┐ ############################################################################
-- ##### ├─┘├┤ ├┬┘├┤ │ │├┬┘│││├─┤││││  ├┤  ############################################################################
-- ##### ┴  └─┘┴└─└  └─┘┴└─┴ ┴┴ ┴┘└┘└─┘└─┘ ############################################################################
-- #region Performance
    -- local unit = Unit
    local pairs = pairs
    local table = table
    local vector3_box = Vector3Box
    local table_clone = table.clone
--#endregion

local master_items = mod:original_require("scripts/backend/master_items")

-- ##### ┌┬┐┌─┐┌┬┐┌─┐ #################################################################################################
-- #####  ││├─┤ │ ├─┤ #################################################################################################
-- ##### ─┴┘┴ ┴ ┴ ┴ ┴ #################################################################################################

local _item = "content/items/weapons/player"
local _item_ranged = _item.."/ranged"
local _item_melee = _item.."/melee"
local _item_empty_trinket = _item.."/trinkets/unused_trinket"

local extended_weapon_customization_plugin = {
    attachments = {

    },
    fixes = {

    },
    kitbashs = {
        [_item_ranged.."/sights/reflex_sight_01_empty"] = {
            attachments = {
                sight = {
                    item = _item_ranged.."/sights/reflex_sight_01",
                    fix = {
                        disable_in_ui = true,
                        hide = {
                            mesh = {1, 2},
                        },
                    },
                    children = {},
                },
            },
            display_name = "loc_empty_sight_01",
            description = "loc_description_empty_sight_01",
            attach_node = "ap_sight_01",
            dev_name = "loc_empty_sight_01",
        },
        [_item_ranged.."/sights/reflex_sight_02_empty"] = {
            attachments = {
                sight = {
                    item = _item_ranged.."/sights/reflex_sight_02",
                    fix = {
                        disable_in_ui = true,
                        hide = {
                            mesh = {1, 2},
                        },
                    },
                    children = {},
                },
            },
            display_name = "loc_empty_sight_02",
            description = "loc_description_empty_sight_02",
            attach_node = "ap_sight_01",
            dev_name = "loc_empty_sight_02",
        },
        [_item_ranged.."/sights/reflex_sight_03_empty"] = {
            attachments = {
                sight = {
                    item = _item_ranged.."/sights/reflex_sight_03",
                    fix = {
                        disable_in_ui = true,
                        hide = {
                            mesh = {1, 2},
                        },
                    },
                    children = {},
                },
            },
            display_name = "loc_empty_sight_03",
            description = "loc_description_empty_sight_03",
            attach_node = "ap_sight_01",
            dev_name = "loc_empty_sight_03",
        },
    },
}

local weapons_to_add_to = { "autogun_p1_m1" }
for _, weapon_id in ipairs(weapons_to_add_to) do
    if not extended_weapon_customization_plugin.attachments[weapon_id] then
        extended_weapon_customization_plugin.attachments[weapon_id] = {}
    end

    extended_weapon_customization_plugin.attachments[weapon_id].sight = {
        reflex_sight_01_empty = {
            replacement_path = _item_ranged.."/sights/reflex_sight_01_empty",
            icon_render_unit_rotation_offset = {90, 0, -95},
            icon_render_camera_position_offset = {.035, -.1, .175},
        },
        reflex_sight_02_empty = {
            replacement_path = _item_ranged.."/sights/reflex_sight_02_empty",
            icon_render_unit_rotation_offset = {90, 0, -95},
            icon_render_camera_position_offset = {.035, -.1, .175},
        },
        reflex_sight_03_empty = {
            replacement_path = _item_ranged.."/sights/reflex_sight_03_empty",
            icon_render_unit_rotation_offset = {90, 0, -95},
            icon_render_camera_position_offset = {.035, -.1, .175},
        },
    }
end

mod.extended_weapon_customization_plugin = extended_weapon_customization_plugin
