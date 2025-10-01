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

-- ####################################################################################################################
-- #####  Adding Attachments   ########################################################################################
-- ####################################################################################################################

local weapons_to_add_to = { "autogun_p1_m1" }
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
            icon_render_unit_rotation_offset = {90, 0, -95},
            icon_render_camera_position_offset = {.035, -.1, .175},
        }
    end
end

for i = 1, 3 do
    local internal_name = "reflex_sight_0"..i.."_empty"
    extended_weapon_customization_plugin.kitbashs[_item_ranged.."/sights/"..internal_name] = {
        attachments = {
            sight = {
                item = _item_ranged.."/sights/reflex_sight_0"..i,
                fix = {
                    disable_in_ui = false,
                    hide = {
                        --node = 1, -- hides whole scope
                        -- node = {2, 3, 4,5,6,7,8,9,10,11,12,13,14,15} -- doesn't hit reticle

                        mesh = 1,
                        --mesh = 2,
                        --mesh = 3,
                        --mesh = 4,
                        --mesh = 5,
                        
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
copy_attachments_from_A_to_B("autogun_p1_m1", "autogun_p2_m1")
copy_attachments_from_A_to_B("autogun_p1_m1", "autogun_p3_m1")

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
