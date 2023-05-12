Hooks:PreHook(CopDamage, "damage_melee", "IDC_melee_insta_kill_on_hostages", function(self,attack_data)
	if immdomcops.settings.meleekill == true and immdomcops.hostages[self._unit:id()] and attack_data.damage > 0 then
		if immdomcops.hostages[self._unit:id()] == "tied_down" then
			attack_data.damage = 999999
			
			self._unit:character_damage():set_invulnerable(false)
			self._unit:character_damage():set_immortal(false)
			self._unit:network():send("set_unit_invulnerable", false, false)
			
			immdomcops.hostages[self._unit:id()] = nil
			
			managers.money:civilian_killed() -- thats what you get for killing prisoners of war lmao
		end
	end
end)

Hooks:PostHook(CopDamage, "die", "IDC_post_cop_death_countour_cleanup", function(self,attack_data)
	if immdomcops.settings.highlights == true then
		self._unit:contour():remove( "friendly" , true )
		self._unit:contour():remove( "highlight_character" , true ) -- not really needed cuz we dont use this highlight, but this should help in case clients run intim. highlights or something
	end
end)