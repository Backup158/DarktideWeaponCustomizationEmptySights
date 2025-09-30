return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`%%title` encountered an error loading the Darktide Mod Framework.")

		new_mod("extended_weapon_customization_empty_scopes", {
			mod_script       = "extended_weapon_customization_empty_scopes/scripts/mods/extended_weapon_customization_empty_scopes/extended_weapon_customization_empty_scopes",
			mod_data         = "extended_weapon_customization_empty_scopes/scripts/mods/extended_weapon_customization_empty_scopes/extended_weapon_customization_empty_scopes_data",
			mod_localization = "extended_weapon_customization_empty_scopes/scripts/mods/extended_weapon_customization_empty_scopes/extended_weapon_customization_empty_scopes_localization",
		})
	end,
	packages = {},
}
