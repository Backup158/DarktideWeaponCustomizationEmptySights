local mod = get_mod("extended_weapon_customization_empty_scopes")
mod.version = "1.0.0"

-- ##### ┌─┐┌─┐┬─┐┌─┐┌─┐┬─┐┌┬┐┌─┐┌┐┌┌─┐┌─┐ ############################################################################
-- ##### ├─┘├┤ ├┬┘├┤ │ │├┬┘│││├─┤││││  ├┤  ############################################################################
-- ##### ┴  └─┘┴└─└  └─┘┴└─┴ ┴┴ ┴┘└┘└─┘└─┘ ############################################################################
-- local unit = Unit
local pairs = pairs
local type = type
local table = table
local vector3_box = Vector3Box
local table_clone = table.clone
local table_merge_recursive = table.merge_recursive
local table_insert = table.insert
local string = string
local string_sub = string.sub
local string_gsub = string.gsub

-- ##### ┌┬┐┌─┐┌┬┐┌─┐ #################################################################################################
-- #####  ││├─┤ │ ├─┤ #################################################################################################
-- ##### ─┴┘┴ ┴ ┴ ┴ ┴ #################################################################################################

local _item = "content/items/weapons/player"
local _item_ranged = _item.."/ranged"
local _item_melee = _item.."/melee"
local _item_empty_trinket = _item.."/trinkets/unused_trinket"

-- List of weapons from game code
local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")

-- Table to fill out for base mod
local extended_weapon_customization_plugin = {
    attachments = {},
    attachment_slots = {},
    fixes = {},
    kitbashs = {},
}

-- ####################################################################################################################
-- #####  Helper Functions   ##########################################################################################
-- ####################################################################################################################

-- ######
-- Print if Debug
-- DESCRIPTION: Logs text in console if debug is on
-- PARAMETERS:
--  message: string
-- RETURN: N/A
-- ######
local function info_if_debug(message)
    if mod:get("debug_mode") then
        mod:info(tostring(message))
    end
end

-- ######
-- String is key in table?
-- RETURN: boolean; was the key found?
-- ######
local function string_is_key_in_table(string_to_find, table_to_search)
    if table_to_search[string_to_find] then
        return true
    else
        -- Checks if key is in table but is just has nil value
        for key, _ in pairs(table_to_search) do
            if string_to_find == key then
                return true
            end
        end
        return false
    end
end

-- ######
-- Copy Attachments from A to B
-- DESCRIPTION: Copies table of attachments from one weapon to another
-- PARAMETERS: 
--  weapon_id_A: string; the source
--  weapon_id_B: string; the destination
-- RETURN: N/A
-- ######
local function copy_attachments_from_A_to_B(weapon_id_A, weapon_id_B)
    -- If source does not exist
    if not extended_weapon_customization_plugin.attachments[weapon_id_A] then
        mod:error("No attachments found for source: "..weapon_id_A)
        return
    end
    -- If destination doesn't exist
    if not extended_weapon_customization_plugin.attachments[weapon_id_B] then
        extended_weapon_customization_plugin.attachments[weapon_id_B] = {}
    end
    table_merge_recursive(extended_weapon_customization_plugin.attachments[weapon_id_B], extended_weapon_customization_plugin.attachments[weapon_id_A])

end

local function copy_fixes_from_A_to_B(weapon_id_A, weapon_id_B)
    -- If source does not exist
    if not extended_weapon_customization_plugin.fixes[weapon_id_A] then
        mod:error("No fixes found for source: "..weapon_id_A)
        return
    end
    -- If destination doesn't exist
    if not extended_weapon_customization_plugin.fixes[weapon_id_B] then
        extended_weapon_customization_plugin.fixes[weapon_id_B] = {}
    end

    for _, fix in ipairs(extended_weapon_customization_plugin.fixes[weapon_id_A]) do
        table_insert(extended_weapon_customization_plugin.fixes[weapon_id_B], fix)
    end
end

-- ######
-- Copy Attachments to Siblings
-- DESCRIPTION: Given the first mark of a weapon, copy attachments to marks 2 and 3, if they exist
-- PARAMETERS: 
--  first_mark_id: string
-- RETURN: N/A
-- ######
local function copy_attachments_to_siblings(first_mark_id)
    if not type(first_mark_id) == "string" then
        mod:error("uwu first_mark_id is not a string")
        return
    end
    info_if_debug("\tCopying attachments to siblings of "..first_mark_id)
    -- from 2 to 3
    for i = 2, 3 do
        local weapon_id = string_gsub(first_mark_id, "1$", tostring(i))
        if string_is_key_in_table(weapon_id, WeaponTemplates) then
            info_if_debug("\t\tuwu Copying to sibling: "..first_mark_id.." --> "..weapon_id)
            copy_attachments_from_A_to_B(first_mark_id, weapon_id)
            copy_fixes_from_A_to_B(first_mark_id, weapon_id)
        else
            info_if_debug("\t\tuwu This is not a real weapon: "..weapon_id)
        end
    end
end

-- ######
-- Create Alignments for Sights
-- DESCRIPTION: generates sight offsets with given position/rotation
-- PARAMETERS: 
--  table_to_insert_into: table; the fixes table
--  vectors_table: table of string, vector3_box; what the vector is used for and the vector value
-- RETURN: N/A
-- ######
local function create_alignments_for_sights(table_to_insert_into, vectors_table)
    table_insert(table_to_insert_into, {
            attachment_slot = "sight_offset",
            requirements = {
                sight = {
                    has = "reflex_sight_01_empty",
                },
            },
            fix = {
                offset = {
                    position = vectors_table.position or vectors_table.position_for_1 or vector3_box(0, 0, 0),
                    rotation = vectors_table.rotation or vectors_table.rotation_for_1 or vector3_box(0, 0, 0),
                },
            },
        }
    ) 
    table_insert(table_to_insert_into, {
            attachment_slot = "sight_offset",
            requirements = {
                sight = {
                    has = "reflex_sight_02_empty",
                },
            },
            fix = {
                offset = {
                    position = vectors_table.position or vectors_table.position_for_2 or vector3_box(0, 0, 0),
                    rotation = vectors_table.rotation or vectors_table.rotation_for_2 or vector3_box(0, 0, 0),
                },
            },
        }
    ) 
    table_insert(table_to_insert_into, {
            attachment_slot = "sight_offset",
            requirements = {
                sight = {
                    has = "reflex_sight_03_empty",
                },
            },
            fix = {
                offset = {
                    position = vectors_table.position or vectors_table.position_for_3 or vector3_box(0, 0, 0),
                    rotation = vectors_table.rotation or vectors_table.rotation_for_3 or vector3_box(0, 0, 0),
                },
            },
        }
    ) 
end

-- ####################################################################################################################
-- #####  Adding Attachments   ########################################################################################
-- ####################################################################################################################

-- ##################
-- Create Attachment for selection
-- ##################
local icon_rot = {90, 0, -95}
local icon_pos = {.035, -0.1, .175}

local weapons_to_add_to = { "autogun_p1_m1", "autogun_p2_m1", "autogun_p3_m1", 
    "autopistol_p1_m1", 
    "bolter_p1_m1", "boltpistol_p1_m1", 
    "lasgun_p1_m1", "lasgun_p2_m1", "lasgun_p3_m1", 
    "laspistol_p1_m1", 
    "ogryn_heavystubber_p1_m1", "ogryn_heavystubber_p2_m1", 
    "shotgun_p1_m1", 
    "shotgun_p4_m1",
    "stubrevolver_p1_m1",
}
local sight_reticles_to_add = { "remove_reticle", "does_nothing_atm", "another_dummy_option", }
for _, weapon_id in ipairs(weapons_to_add_to) do
    if not extended_weapon_customization_plugin.attachments[weapon_id] then
        extended_weapon_customization_plugin.attachments[weapon_id] = {}
    end

    if not extended_weapon_customization_plugin.attachments[weapon_id].sight then
        extended_weapon_customization_plugin.attachments[weapon_id].sight = {}
    end

    for i = 1, 3 do
        extended_weapon_customization_plugin.attachments[weapon_id].sight["reflex_sight_0"..i.."_empty"] = {
            replacement_path = _item_ranged.."/sights/reflex_sight_0"..i.."_empty",
            icon_render_unit_rotation_offset = icon_rot,
            icon_render_camera_position_offset = icon_pos,
        }
    end
    --[[
    if not extended_weapon_customization_plugin.attachments[weapon_id].sight_reticle then
        extended_weapon_customization_plugin.attachments[weapon_id].sight_reticle = {}
    end
    for _, internal_name in ipairs(sight_reticles_to_add) do
        extended_weapon_customization_plugin.attachments[weapon_id].sight_reticle[internal_name] = {
            replacement_path = _item_ranged.."/sight_reticle/"..internal_name,
            icon_render_unit_rotation_offset = icon_rot,
            icon_render_camera_position_offset = icon_pos,
        }
    end

    if not extended_weapon_customization_plugin.attachment_slots[weapon_id] then
        extended_weapon_customization_plugin.attachment_slots[weapon_id] = {}
    end
    table_insert(extended_weapon_customization_plugin.attachment_slots[weapon_id], {
        sight_reticle = {
            parent_slot = "sight",
            default_path = _item_empty_trinket,
        },
    })
    ]]
    -- initialize fixes
    if not extended_weapon_customization_plugin.fixes[weapon_id] then
        extended_weapon_customization_plugin.fixes[weapon_id] = {}
    end

    --[[
    table_insert(extended_weapon_customization_plugin.fixes[weapon_id], {
        attachment_slot = "sight",
        requirements = {
            sight_reticle = {
                has = "remove_reticle",
            },
            sight = {
                has = "reflex_sight_01|reflex_sight_02|reflex_sight_03",
            },
        },
        fix = {
            disable_in_ui = false,
            hide = {
                mesh = 1,
            },
            --offset = {
            --    position = vector3_box(0, 0.1, -0.01), -- forwards and down into the middle recess
            --},
        },
    })
    ]]
end
--[[
-- kitbash definition
for _, internal_name in ipairs(sight_reticles_to_add) do
    extended_weapon_customization_plugin.kitbashs[_item_ranged.."/sight_reticle/"..internal_name] = {
        attachments = {
            base = {
                item = _item_empty_trinket,
                fix = {
                    disable_in_ui = false,
                    hide = {
                        mesh = 1,
                    },
                },
                children = {},
            },
        },
        display_name = "loc_"..internal_name,
        description = "loc_description_"..internal_name,
        attach_node = "ap_sight_01",
        dev_name = internal_name,
        
    }
end
]]

-- ##################
-- Manual fixes for alignment
-- ##################
local empty_reflexes = "reflex_sight_01_empty|reflex_sight_02_empty|reflex_sight_03_empty"
local infantry_autogun_receivers = "autogun_rifle_receiver_01|autogun_rifle_receiver_ml01"
local vigilant_autogun_receivers = "autogun_rifle_killshot_receiver_01|autogun_rifle_killshot_receiver_02|autogun_rifle_killshot_receiver_03|autogun_rifle_killshot_receiver_04|autogun_rifle_killshot_receiver_ml01"
local braced_autogun_receivers = "autogun_rifle_ak_receiver_01|autogun_rifle_ak_receiver_02|autogun_rifle_ak_receiver_03|autogun_rifle_ak_receiver_ml01"

extended_weapon_customization_plugin.fixes.autogun_p1_m1 = {
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_01_empty|reflex_sight_02_empty" },
            receiver = { has = infantry_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.0085) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_03_empty" },
            receiver = { has = infantry_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.0075) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_01_empty|reflex_sight_02_empty" },
            receiver = { has = braced_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.0085) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_03_empty" },
            receiver = { has = braced_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.0075) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_01_empty|reflex_sight_02_empty" },
            receiver = { has = vigilant_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.011) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_03_empty" },
            receiver = { has = vigilant_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.0085) },
        },
    },
}
extended_weapon_customization_plugin.fixes.autogun_p2_m1 = {
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_01_empty|reflex_sight_02_empty" },
            receiver = { has = infantry_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(-0.07, 0, 0.0085) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_03_empty" },
            receiver = { has = infantry_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.0075) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_01_empty|reflex_sight_02_empty" },
            receiver = { has = braced_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(-0.075, 0, 0.058) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_03_empty" },
            receiver = { has = braced_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(-0.075, 0, 0.058) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_01_empty|reflex_sight_02_empty" },
            receiver = { has = vigilant_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.011) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_03_empty" },
            receiver = { has = vigilant_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.0085) },
        },
    },
    {
        attachment_slot = "sight",
        requirements = {
            sight = {
                has = empty_reflexes,
            },
            receiver = {
                has = braced_autogun_receivers,
            }
        },
        fix = {
            offset = {
                position = vector3_box(0, -0.025, 0),
                rotation = vector3_box(0, 0, 0),
            },
        },
    },
    {attachment_slot = "sight",
        requirements = {
            sight = {
                has = empty_reflexes,
            },
            receiver = {
                has = vigilant_autogun_receivers,
            }
        },
        fix = {
            offset = {
                position = vector3_box(0, -.05, 0),
                rotation = vector3_box(0, 0, 0),
            },
        },
    },
}
extended_weapon_customization_plugin.fixes.autogun_p3_m1 = {
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_01_empty|reflex_sight_02_empty" },
            receiver = { has = infantry_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.0085) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_03_empty" },
            receiver = { has = infantry_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.0075) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_01_empty|reflex_sight_02_empty" },
            receiver = { has = braced_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.0085) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_03_empty" },
            receiver = { has = braced_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.0075) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_01_empty|reflex_sight_02_empty" },
            receiver = { has = vigilant_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.011) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_03_empty" },
            receiver = { has = vigilant_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -0.0085) },
        },
    },
    {
        attachment_slot = "sight",
        requirements = {
            sight = {
                has = empty_reflexes,
            },
            receiver = {
                has = braced_autogun_receivers,
            }
        },
        fix = {
            offset = {
                position = vector3_box(0, -0.025, 0),
            },
        },
    },
    {
        attachment_slot = "sight",
        requirements = {
            sight = {
                has = empty_reflexes,
            },
            receiver = {
                has = vigilant_autogun_receivers,
            }
        },
        fix = {
            offset = {
                position = vector3_box(0, -0.05, 0),
            },
        },
    },
}
create_alignments_for_sights(extended_weapon_customization_plugin.fixes.autopistol_p1_m1, {
    position = vector3_box(-0.045, -0.05, 0.1175),
    rotation = vector3_box(-2, 10, -2),
})
create_alignments_for_sights(extended_weapon_customization_plugin.fixes.bolter_p1_m1, {
    position = vector3_box(0, 0, -0.0095),
})
table_insert(extended_weapon_customization_plugin.fixes.bolter_p1_m1, 
    {   
        attachment_slot = "sight",
        requirements = {
            sight = {
                has = empty_reflexes,
            },
        },
        fix = {
            offset = {
                position = vector3_box(0, 0.1, -0.01), -- forwards and down into the middle recess
            },
        },
    }
)
create_alignments_for_sights(extended_weapon_customization_plugin.fixes.boltpistol_p1_m1, {
    position = vector3_box(0, 0, -0.0095),
})
table_insert(extended_weapon_customization_plugin.fixes.boltpistol_p1_m1, 
    {   
        attachment_slot = "sight",
        requirements = {
            sight = {
                has = empty_reflexes,
            },
        },
        fix = {
            offset = {
                position = vector3_box(0, 0.095, -0.013), -- forwards and down into the middle recess
            },
        },
    }
)
-- Infantry Lasguns don't need alignment
create_alignments_for_sights(extended_weapon_customization_plugin.fixes.lasgun_p2_m1, {
    position_for_1 = vector3_box(0, 0, -0.0235),
    position_for_2 = vector3_box(0, 0, -0.022),
    position_for_3 = vector3_box(0, 0, -0.022),
})
create_alignments_for_sights(extended_weapon_customization_plugin.fixes.lasgun_p3_m1, {
    position = vector3_box(0, 0.15, -0.03),
})
table_insert(extended_weapon_customization_plugin.fixes.lasgun_p3_m1, {
    attachment_slot = "sight",
    requirements = {
        sight = {
            has = empty_reflexes,
        },
    },
    fix = {
        offset = {
            position = vector3_box(0, 0.05, 0.005),
            rotation = vector3_box(0, 0, 0),
        },
    },
})
-- Resizing rail to not bulge out (owo)
table_insert(extended_weapon_customization_plugin.fixes.lasgun_p3_m1, {
    attachment_slot = "rail",
    requirements = {
        sight = {
            has = empty_reflexes,
        },
    },
    fix = {
        attach = {
            rail = "lasgun_rifle_rail_01", -- part of the base mod
        },
        offset = {
            position = vector3_box(0, 0.035, 0.005),
            rotation = vector3_box(0, 0, 0),
            scale = vector3_box(1, 0.9, 1),
            node = 1,
        },
    },
})
-- Laspistols don't need alignment
create_alignments_for_sights(extended_weapon_customization_plugin.fixes.ogryn_heavystubber_p1_m1, {
    position = vector3_box(-0.28, -0.5, 0.18),
    rotation = vector3_box(-2.4, 0, -1.4),
})
create_alignments_for_sights(extended_weapon_customization_plugin.fixes.ogryn_heavystubber_p2_m1, {
    position = vector3_box(0.06, -0.25, 0.25),
    rotation = vector3_box(-3.1, 0, -2.2),
})
-- Combat Shotguns don't need alignment
--[[
create_alignments_for_sights(extended_weapon_customization_plugin.fixes.shotgun_p1_m1, {
    position = vector3_box(0, 0, -0.0335),
})
]]
create_alignments_for_sights(extended_weapon_customization_plugin.fixes.shotgun_p4_m1, {
    position = vector3_box(-0.09, 0, 0.13),
    rotation = vector3_box(-6, 0, -5.5),
})
create_alignments_for_sights(extended_weapon_customization_plugin.fixes.stubrevolver_p1_m1, {
    position = vector3_box(0.00, 0, -0.02),
})
table_insert(extended_weapon_customization_plugin.fixes.stubrevolver_p1_m1, {
    attachment_slot = "rail",
    requirements = {
        sight = {
            has = empty_reflexes,
        },
    },
    fix = {
        attach = {
            rail = "lasgun_pistol_rail_01", -- part of the base mod
        },
        offset = {
            position = vector3_box(0, -0.07, 0.01),
            rotation = vector3_box(0, 0, 0),
            scale = vector3_box(1, 1, 1),
            node = 1,
        },
    },
})
-- ##################
-- Kitbash definition 
-- ##################
for i = 1, 3 do
    local base_item_path = _item_ranged.."/sights/reflex_sight_0"..i
    local internal_name = "reflex_sight_0"..i.."_empty"
    local replacement_path = _item_ranged.."/sights/"..internal_name

    extended_weapon_customization_plugin.kitbashs[replacement_path] = {
        attachments = {
            base = {
                item = base_item_path,
                fix = {
                    disable_in_ui = false,
                    hide = {
                        mesh = 1,
                    },
                },
                children = {},
            },
        },
        display_name = "loc_"..internal_name,
        description = "loc_description_"..internal_name,
        attach_node = "ap_sight_01",
        dev_name = internal_name,
        
    }
end

-- ################################
-- Copying to Different Marks
-- ################################
info_if_debug("Going through extended_weapon_customization_plugin...")
local siblings_to_add = {}
-- See which weapons may need to copy over to siblings
for weapon_id, _ in pairs(extended_weapon_customization_plugin.attachments) do
    -- If first mark of pattern, copy to the siblings
    --  Check last two characters of the name
    --  if mark 1, copy to mk 2 and 3
    --      if they exist (checks for this are handled in that function)
    info_if_debug("\tChecking "..weapon_id)
    if (string_sub(weapon_id, -2) == "m1") then
        table_insert(siblings_to_add, weapon_id)
    else
        mod:error("uwu [REPORT TO MOD AUTHOR] not the first mark: "..weapon_id)
    end
end
-- copies to siblings
--  Done this way because pairs() does NOT guarantee order
--  and since I'm adding to the table i'm reading, it can lead to duplicates and shuffling order
--  so somehow things can get skipped? this happened to ilas for some reason
for _, weapon_id in ipairs(siblings_to_add) do
    copy_attachments_to_siblings(weapon_id)
end

mod.extended_weapon_customization_plugin = extended_weapon_customization_plugin

-- ####################################################################################################################
-- #####  Hooks   #####################################################################################################
-- ####################################################################################################################

function mod.on_all_mods_loaded()
    mod:info("v"..mod.version.." loaded uwu nya :3")

	-- Checks for installed mods. Kept here so it works after reload.
	--	Base Mod
	if not get_mod("extended_weapon_customization") then
		mod:error("Extended Weapon Customization mod (the rebuild) required")
		return
	end
    --  Outdated base mod
	if get_mod("weapon_customization") then
		mod:error("You are using the OLD version of Weapon Customization! This plugin is for the new, rebuilt version.")
		return
	end
	--	Plugins
	--		Just so I know. Compatibility is only an issue of name collisions
    if get_mod("extended_weapon_customization_base_additions") then
    	mod:info("Uwusa haz base additions :3")
    end
    if get_mod("extended_weapon_customization_owo") then
		mod:info("Uwusa haz OwO :3")
    end
end