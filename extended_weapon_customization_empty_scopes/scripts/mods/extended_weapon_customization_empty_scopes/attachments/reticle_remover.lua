local mod = get_mod("extended_weapon_customization_empty_scopes")

local _item = "content/items/weapons/player"
local _item_ranged = _item.."/ranged"
local _item_melee = _item.."/melee"
local _item_empty_trinket = _item.."/trinkets/unused_trinket"
local icon_rot = mod.icon_rot
local icon_pos = mod.icon_pos

local sight_reticles_to_add = mod.sight_reticles_to_add

local attachment_blob = {
    attachments = { sight_reticle = {}, }, -- filled out below
    attachment_slots = {
        sight_reticle = {
            parent_slot = "sight",
            default_path = _item_empty_trinket,
            fix = {
                --[[
                offset = {
                    node = 1,
                    position = vector3_box(.04, .27, 0),
                    rotation = vector3_box(0, 0, 0),
                    scale = vector3_box(1, 1, 1),
                },
                ]]
                hide = {
                    mesh = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15},
                },
            },
        }
    },
    fixes = {
        {
            attachment_slot = "sight",
            requirements = {
                sight_reticle = {
                    has = "remove_reticle",
                },
                --sight = {
                --    has = "reflex_sight_01|reflex_sight_02|reflex_sight_03",
                --},
            },
            fix = {
                disable_in_ui = false,
                hide = {
                    mesh = {1},
                },
                --[[
                offset = {
                    position = vector3_box(0, 0.5, 0.2), -- just to see if it work
                },
                ]]
            },
        },
        {
            attachment_slot = "sight",
            requirements = {
                sight_reticle = {
                    has = "remove_sight",
                },
                --sight = {
                --    has = "reflex_sight_01|reflex_sight_02|reflex_sight_03",
                --},
            },
            fix = {
                disable_in_ui = false,
                hide = {
                    node = {1},
                },
                alpha = 1,
            },
        }, 
        --[[
        {
            attachment_slot = "sight_reticle",
            requirements = {
                sight_reticle = {
                    has = "remove_reticle|remove_sight",
                },
            },
            fix = {
                disable_in_ui = false,
                offset = {
                    node = 1,
                    position = vector3_box(0, 0.5, 0.2), -- just to see if it work
                    rotation = vector3_box(0, 0, 0),
                    scale = vector3_box(1, 1, 1)
                },
                --hide = {
                --    mesh = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
                --}
            },
        }
        ]]
    },
    kitbashs = {},
}

for key, internal_name in ipairs(sight_reticles_to_add) do
    -- Attachment
    attachment_blob.attachments.sight_reticle[internal_name] = {
        replacement_path = _item_ranged.."/sight_reticles/"..internal_name,
        icon_render_unit_rotation_offset = icon_rot,
        icon_render_camera_position_offset = icon_pos,
        custom_selection_group = "empty_scopes"
    }

    -- Kitbash
    local replacement_name = _item_ranged.."/sight_reticles/"..internal_name
    --local base_unit_path = "content/characters/empty_item/empty_item"
    --local base_unit_path = "content/items/weapons/player/ranged/stocks/autogun_rifle_stock_02"
    --local base_unit_path = "content/weapons/player/melee/chain_sword/attachments/body_06/body_06"
    local base_unit_path = "content/weapons/player/melee/chain_sword/attachments/body_0"..key.."/body_0"..key
    attachment_blob.kitbashs[replacement_name] = {
        
        is_fallback_item = false,
        show_in_1p = true,
        base_unit = base_unit_path,
        item_list_faction = "Player",
        tags = {
        },
        only_show_in_1p = false,
        feature_flags = {
            "FEATURE_item_retained",
        },
        attach_node = "ap_sight_01",
        resource_dependencies = {
            [base_unit_path] = true,
        },
        attachments = {
            zzz_shared_material_overrides = {
                item = "",
                children = {},
            },
        },
        workflow_checklist = {
        },
        --display_name = "loc_"..internal_name,
        display_name = "n/a",
        name = replacement_name,
        workflow_state = "RELEASABLE",
        is_full_item = true
    }
end

return attachment_blob