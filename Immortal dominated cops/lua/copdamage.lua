Hooks:PostHook(CopDamage, "damage_melee", "meleeinstakillonhostages", function(self,attack_data)
	if immdomcops.settings.meleekill == true and immdomcops.hostages[self._unit:id()] == true and attack_data.damage > 0 then
		attack_data.damage = 999999
		self._unit:character_damage():set_invulnerable(false)
		self._unit:character_damage():set_immortal(false)
		self._unit:network():send("set_unit_invulnerable", false, false)
		self:damage_melee(attack_data)
		
		immdomcops.hostages[self._unit:id()] = nil
		managers.money:civilian_killed() -- thats what you get for killing prisoners of war lmao
	end
end )

Hooks:PostHook(CopDamage, "die", "postcopdeathcountourcleanup", function(self,attack_data)
	if immdomcops.settings.highlights == true then
		self._unit:contour():remove( "friendly" , true )
		self._unit:contour():remove( "highlight_character" , true ) -- not really needed cuz we dont use this highlight, but this should help in case clients run intim. highlights or something
	end
end )