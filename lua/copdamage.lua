Hooks:PostHook(CopDamage, "die", "IDC_post_cop_death_countour_cleanup", function(self,attack_data)
	if immdomcops.settings.highlights == true then
		self._unit:contour():remove( "friendly" , true )
		self._unit:contour():remove( "highlight_character" , true ) -- not really needed cuz we dont use this highlight, but this should help in case clients run intim. highlights or something
	end
end)