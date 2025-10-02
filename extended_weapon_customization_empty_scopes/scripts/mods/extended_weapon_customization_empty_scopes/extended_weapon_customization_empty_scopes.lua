local mod = get_mod("extended_weapon_customization_empty_scopes")

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
    attachments = {

    },
    fixes = {

    },
    kitbashs = {

    },
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
        mod:error("No attachments found for "..weapon_id_A)
        return
    end
    -- If destination doesn't exist
    if not extended_weapon_customization_plugin.attachments[weapon_id_B] then
        extended_weapon_customization_plugin.attachments[weapon_id_B] = {}
    end
    table_merge_recursive(extended_weapon_customization_plugin.attachments[weapon_id_B], extended_weapon_customization_plugin.attachments[weapon_id_A])

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
        else
            info_if_debug("\t\tuwu This is not a real weapon: "..weapon_id)
        end
    end
end

local function create_alignment_for_sights(table_to_insert_into, vectors_table)
    table_insert(table_to_insert_into, {
            attachment_slot = "sight_offset",
            requirements = {
                sight = {
                    has = "reflex_sight_01_empty|reflex_sight_02_empty",
                },
            },
            fix = {
                offset = {
                    position = vectors_table.position_for_1_and_2 or vector3_box(0, 0, 0),
                    rotation = vectors_table.rotation_for_1_and_2 or vector3_box(0, 0, 0),
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
                    position = vectors_table.position_for_3 or vector3_box(0, 0, 0),
                    rotation = vectors_table.rotation_for_3 or vector3_box(0, 0, 0),
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
local icon_pos = {.035, -.1, .175}

local weapons_to_add_to = { "autogun_p1_m1", "autogun_p2_m1", "autogun_p3_m1", 
    "autopistol_p1_m1", 
    "bolter_p1_m1", "boltpistol_p1_m1", 
    "lasgun_p1_m1", "lasgun_p2_m1", "lasgun_p3_m1", 
    "laspistol_p1_m1", 
    --"ogryn_heavystubber_p1_m1", "ogryn_heavystubber_p2_m1", 
    "shotgun_p1_m1", 
    "shotgun_p4_m1",
}
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

    -- initialize fixes
    if not extended_weapon_customization_plugin.fixes[weapon_id] then
        extended_weapon_customization_plugin.fixes[weapon_id] = {}
    end
end

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
            offset = { position = vector3_box(0, 0, -.0085) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_03_empty" },
            receiver = { has = infantry_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -.0075) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_01_empty|reflex_sight_02_empty" },
            receiver = { has = braced_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -.0085) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_03_empty" },
            receiver = { has = braced_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -.0075) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_01_empty|reflex_sight_02_empty" },
            receiver = { has = vigilant_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -.011) },
        },
    },
    {
        attachment_slot = "sight_offset",
        requirements = {
            sight = { has = "reflex_sight_03_empty" },
            receiver = { has = vigilant_autogun_receivers },
        },
        fix = {
            offset = { position = vector3_box(0, 0, -.0085) },
        },
    },
}

-- ##################
-- Kitbash definition 
-- ##################
for i = 1, 3 do
    local base_item_path = _item_ranged.."/sights/reflex_sight_0"..i
    local internal_name = "reflex_sight_0"..i.."_empty"
    local replacement_path = _item_ranged.."/sights/"..internal_name

    extended_weapon_customization_plugin.kitbashs[replacement_path] = {
        --[[
        is_fallback_item = false,
        show_in_1p = true,
        base_unit = base_item_path,
        item_list_faction = "Player",
        tags = {
        },
        only_show_in_1p = false,
        feature_flags = {
            "FEATURE_item_retained",
        },
        attach_node = ap_sight_01,
        resource_dependencies = {
            [base_item_path] = true,
        },
        attachments = {
            zzz_shared_material_overrides = {
                item = "",
                children = {},
            },
        },
        workflow_checklist = {
        },
        display_name = "loc_"..internal_name,
        name = replacement_path,
        workflow_state = "RELEASABLE",
        is_full_item = true
        ]]
        attachments = {
            base = {
                item = base_item_path,
                fix = {
                    disable_in_ui = true,
                    hide = {
                        --node = 1, -- hides whole scope
                        -- node = {2, 3, 4,5,6,7,8,9,10,11,12,13,14,15} -- doesn't hit reticle

                        mesh = 1,
                        --mesh = 2,
                        --mesh = 3,
                        --mesh = 4,
                        --mesh = 5,
                        --mesh = {0, 1}
                        --mesh = {1},
                        --mesh = "1",
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
-- Autoguns: Propagate Infantry autogun attachments to Braced and Vigilant
--copy_attachments_from_A_to_B("autogun_p1_m1", "autogun_p2_m1")
--copy_attachments_from_A_to_B("autogun_p1_m1", "autogun_p3_m1")

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
