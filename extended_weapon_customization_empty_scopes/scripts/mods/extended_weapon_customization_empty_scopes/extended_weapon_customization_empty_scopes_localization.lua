local mod = get_mod("extended_weapon_customization_empty_scopes")

-- Localizations for the base mod to use
mod:add_global_localize_strings({
	-- Mod Name for the separators
    loc_ewc_extended_weapon_customization_empty_scopes = {
        en = "Empty Scopes/Sights",
    },
	-- Slot Name
	attachment_slot_sight_reticle = {
		en = "Sight Reticles",
	},
	loc_ewc_empty_scopes = {
		en = "Empty Scopes/Sights"
	},
	-- Attachments
	loc_ewc_remove_reticle = {
		en = "Remove Reticle",
	},
	loc_ewc_remove_sight = {
		en = "Remove Entire Sight",
	},
})
for i = 1, 3 do
	mod:add_global_localize_strings({
		["loc_reflex_sight_0"..i.."_empty"] = {
			en = "Empty Reflex Sight "..i,
		},
	})
end

return {
	mod_description = {
		en = "Adds optics without reticles, for use with Crosshair Remap",
	},
	debug_mode = {
		en = "Debug Mode",
	},
	debug_mode_description = {
		en = "Verbose printing in the console log",
	},
}
