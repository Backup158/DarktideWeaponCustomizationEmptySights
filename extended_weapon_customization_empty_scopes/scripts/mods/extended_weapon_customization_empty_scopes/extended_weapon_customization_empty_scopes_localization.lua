local mod = get_mod("extended_weapon_customization_empty_scopes")

-- Localizations for the base mod to use
mod:add_global_localize_strings({
	-- Mod Name for the separators
    loc_extended_weapon_customization_empty_scopes = {
        en = "Empty Scopes/Sights",
    },
})

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
