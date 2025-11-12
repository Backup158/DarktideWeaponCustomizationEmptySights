local mod = get_mod("extended_weapon_customization_empty_scopes")

local vector3_box = Vector3Box
local string = string
local string_sub = string.sub
local table = table
local table_insert = table.insert

local icon_rot = mod.icon_rot
local icon_pos = mod.icon_pos

local create_alignments_for_sights = mod.create_alignments_for_sights

local empty_reflexes = ""
local infantry_autogun_receivers = "autogun_rifle_receiver_01|autogun_rifle_receiver_ml01"
local vigilant_autogun_receivers = "autogun_rifle_killshot_receiver_01|autogun_rifle_killshot_receiver_02|autogun_rifle_killshot_receiver_03|autogun_rifle_killshot_receiver_04|autogun_rifle_killshot_receiver_ml01"
local braced_autogun_receivers = "autogun_rifle_ak_receiver_01|autogun_rifle_ak_receiver_02|autogun_rifle_ak_receiver_03|autogun_rifle_ak_receiver_ml01"

local custom_fixes = {}

local attachment_blob = {
    attachments = { sight = {}, }, -- filled out below
    -- attachment_slots = {},
    fixes = {

    },
    manual_fixes = custom_fixes,
    kitbashs = {

    },
}
for i = 1, 3 do
    -- Attachments
    attachment_blob.attachments[weapon_id].sight["reflex_sight_0"..i.."_empty"] = {
        replacement_path = _item_ranged.."/sights/reflex_sight_0"..i.."_empty",
        icon_render_unit_rotation_offset = icon_rot,
        icon_render_camera_position_offset = icon_pos,
        custom_selection_group = "empty_scopes"
    }

    -- Kitbashes
    local base_item_path = _item_ranged.."/sights/reflex_sight_0"..i
    local internal_name = "reflex_sight_0"..i.."_empty"
    local replacement_path = _item_ranged.."/sights/"..internal_name
    attachment_blob.kitbashs[replacement_path] = {
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

    empty_reflexes = empty_reflexes..internal_name.."|"
end

empty_reflexes = empty_reflexes

-- ##################
-- Manual fixes for alignment
-- ##################
custom_fixes.autogun_p1_m1 = {
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
custom_fixes.autogun_p2_m1 = {
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
custom_fixes.autogun_p3_m1 = {
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
create_alignments_for_sights(custom_fixes.autopistol_p1_m1, {
    position = vector3_box(-0.045, -0.05, 0.1175),
    rotation = vector3_box(-2, 10, -2),
})
create_alignments_for_sights(custom_fixes.bolter_p1_m1, {
    position = vector3_box(0, 0, -0.0095),
})
table_insert(custom_fixes.bolter_p1_m1, 
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
create_alignments_for_sights(custom_fixes.boltpistol_p1_m1, {
    position = vector3_box(0, 0, -0.0095),
})
table_insert(custom_fixes.boltpistol_p1_m1, 
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
create_alignments_for_sights(custom_fixes.lasgun_p2_m1, {
    position_for_1 = vector3_box(0, 0, -0.0235),
    position_for_2 = vector3_box(0, 0, -0.022),
    position_for_3 = vector3_box(0, 0, -0.022),
})
create_alignments_for_sights(custom_fixes.lasgun_p3_m1, {
    position = vector3_box(0, 0.15, -0.03),
})
table_insert(custom_fixes.lasgun_p3_m1, {
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
table_insert(custom_fixes.lasgun_p3_m1, {
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
create_alignments_for_sights(custom_fixes.ogryn_heavystubber_p1_m1, {
    position = vector3_box(-0.28, -0.5, 0.18),
    rotation = vector3_box(-2.4, 0, -1.4),
})
create_alignments_for_sights(custom_fixes.ogryn_heavystubber_p2_m1, {
    position = vector3_box(0.06, -0.25, 0.25),
    rotation = vector3_box(-3.1, 0, -2.2),
})
-- Combat Shotguns don't need alignment
--create_alignments_for_sights(custom_fixes.shotgun_p1_m1, {
--    position = vector3_box(0, 0, -0.0335),
--})
create_alignments_for_sights(custom_fixes.shotgun_p4_m1, {
    position = vector3_box(-0.09, 0, 0.13),
    rotation = vector3_box(-6, 0, -5.5),
})
create_alignments_for_sights(custom_fixes.stubrevolver_p1_m1, {
    position = vector3_box(0.00, 0, -0.031),
})
table_insert(custom_fixes.stubrevolver_p1_m1, {
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

return attachment_blob