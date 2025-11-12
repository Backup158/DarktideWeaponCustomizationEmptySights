local mod = get_mod("extended_weapon_customization_empty_scopes")
mod.version = "1.1.0"

-- ##### ┌─┐┌─┐┬─┐┌─┐┌─┐┬─┐┌┬┐┌─┐┌┐┌┌─┐┌─┐ ############################################################################
-- ##### ├─┘├┤ ├┬┘├┤ │ │├┬┘│││├─┤││││  ├┤  ############################################################################
-- ##### ┴  └─┘┴└─└  └─┘┴└─┴ ┴┴ ┴┘└┘└─┘└─┘ ############################################################################
-- local unit = Unit
local pairs = pairs
local ipairs = ipairs
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
-- Load Mod File
-- DESCRIPTION: Runs a file in the mod's folder
-- PARAMETERS:
--  relative_path: string; path to the file without the extension; e.g. "melee/autogun_gooning"
-- RETURN: N/A
-- ######
local function load_mod_file(relative_path)
	return mod:io_dofile("extended_weapon_customization_empty_scopes/scripts/mods/extended_weapon_customization_empty_scopes/"..relative_path)
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

    -- If destination doesn't exist
    if not extended_weapon_customization_plugin.attachment_slots[weapon_id_B] then
        extended_weapon_customization_plugin.attachment_slots[weapon_id_B] = {}
    end
    table_merge_recursive(extended_weapon_customization_plugin.attachment_slots[weapon_id_B], extended_weapon_customization_plugin.attachment_slots[weapon_id_A])
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
function mod.create_alignments_for_sights(table_to_insert_into, vectors_table)
    for i = 1, 3 do
        table_insert(table_to_insert_into, {
                attachment_slot = "sight_offset",
                requirements = {
                    sight = {
                        has = "reflex_sight_0"..i.."_empty",
                    },
                },
                fix = {
                    offset = {
                        position = vectors_table.position or vectors_table["position_for_"..i] or vector3_box(0, 0, 0),
                        rotation = vectors_table.rotation or vectors_table["rotation_for_"..i] or vector3_box(0, 0, 0),
                    },
                },
            }
        ) 
    end
end

-- ######
-- 
-- RETURN: N/A
-- ######
local function merge_attachment_from_file_to_weapon(table_to_insert_into, weapon_id, slot_to_use, attachment_blob)
    -- Attachments
    if not table_to_insert_into.attachments[weapon_id] then
        table_to_insert_into.attachments[weapon_id] = {}
    end
    if not table_to_insert_into.attachments[weapon_id][slot_to_use] then
        table_to_insert_into.attachments[weapon_id][slot_to_use] = {}
    end
    table_merge_recursive(table_to_insert_into.attachments[weapon_id], attachment_blob.attachments)

    -- Attachment Slots
    if attachment_blob.attachment_slots then
        if not table_to_insert_into.attachment_slots[weapon_id] then
            table_to_insert_into.attachment_slots[weapon_id] = {}
        end
        table_merge_recursive(table_to_insert_into.attachment_slots[weapon_id], attachment_blob.attachment_slots)
    end

    -- Fixes
    if attachment_blob.fixes then
        if not table_to_insert_into.fixes[weapon_id] then
            table_to_insert_into.fixes[weapon_id] = {}
        end
        for _, fix in ipairs(attachment_blob.fixes) do
            table_insert(table_to_insert_into.fixes[weapon_id], fix)
        end
    end
    if attachment_blob.manual_fixes and attachment_blob.manual_fixes[weapon_id] then
        if not table_to_insert_into.fixes[weapon_id] then
            table_to_insert_into.fixes[weapon_id] = {}
        end
        for _, fix in ipairs(attachment_blob.manual_fixes[weapon_id]) do
            table_insert(table_to_insert_into.fixes[weapon_id], fix)
        end
    end

    -- Kitbashs
    for kitbash_name, kitbash_data in pairs(attachment_blob.kitbashs) do
        if not attachment_blob.kitbashs[kitbash_name] then
            attachment_blob.kitbashs[kitbash_name] = kitbash_data
        end
    end
end

-- ####################################################################################################################
-- #####  Adding Attachments   ########################################################################################
-- ####################################################################################################################
-- ################################
-- Create Attachment for selection
-- ################################
mod.icon_rot = {90, 0, -95}
mod.icon_pos = {.035, -0.1, .175}

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
mod.sight_reticles_to_add = { "remove_reticle", "remove_sight", --"another_dummy_option", "yet_another_dummy",
}
for _, weapon_id in ipairs(weapons_to_add_to) do
    merge_attachment_from_file_to_weapon(extended_weapon_customization_plugin, weapon_id, "sight", load_mod_file("attachments/empty_scopes"))
    merge_attachment_from_file_to_weapon(extended_weapon_customization_plugin, weapon_id, "sight_reticle", load_mod_file("attachments/reticle_remover"))
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

if mod:get("debug_mode") then
    table.dump(mod.extended_weapon_customization_plugin, "big sweaty black men", 12)
end

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