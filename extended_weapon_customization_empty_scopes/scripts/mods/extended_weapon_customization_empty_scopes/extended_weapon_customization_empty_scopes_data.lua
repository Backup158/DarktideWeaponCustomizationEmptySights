local mod = get_mod("extended_weapon_customization_empty_scopes")

return {
	name = "extended_weapon_customization_empty_scopes",
	description = mod:localize("mod_description"),
	is_togglable = true,
	options = {
		widgets = {
			{
				setting_id = "debug_mode",
				type = "checkbox",
				default_value = false,
			}
		}
	}
}
