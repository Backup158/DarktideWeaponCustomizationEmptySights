local mod = get_mod("extended_weapon_customization_empty_scopes")

local icon_rot = mod.icon_rot
local icon_pos = mod.icon_pos

local attachment_blob = {
    attachments = {}, -- filled out below
    -- attachment_slots = {},
    fixes = {

    },
    kitbashs = {

    },
}
for i = 1, 3 do
    attachment_blob.attachments[weapon_id].sight["reflex_sight_0"..i.."_empty"] = {
        replacement_path = _item_ranged.."/sights/reflex_sight_0"..i.."_empty",
        icon_render_unit_rotation_offset = icon_rot,
        icon_render_camera_position_offset = icon_pos,
        custom_selection_group = "empty_scopes"
    }
end

return attachment_blob