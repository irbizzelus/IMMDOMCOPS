Hooks:PostHook(CopMovement, "action_request", "postactionrequesttweakunitdata" , function(self,action_desc)
	
	if not Network:is_server() then
		return
	end
	
	if self._unit:base().mic_is_being_moved then -- idk, some check if unit is busy or something? ask Undeadsewer, thats his code
		return
	end
	
	if managers.enemy:is_civilian( self._unit ) then
		return
	end
	
	if self._unit:base():char_tweak().access == "teamAI4" then -- Check if 'cop' action is requested by an actuall cop and not by Hoxton or other friendly ai, who are supposed to be immortal
		return
	end
	
	-- Wacky zany First World Bank stealth retention code by Divided By Zero²
	if Global.game_settings and Global.game_settings.level_id == "red2" and managers.groupai:state():whisper_mode() then 
		return
	end
	
	-- Much better way to make sure that wrong 'enemies' dont get immortal/mortal is to only allow enemies from a list that we make ourselves to become mortal/immortal
	-- Pros:
	-- 1) less bugs
	-- Cons:
	-- 1) will take time a bit of time to figure out all enemy types that we need
	-- 2) will have to make updates if ovkl adds more units who can give up
	
	-- teamAI4 workaround seems to work fine since its used for every allied 'cop' as far as i know
	-- 1.3 update: everything works great for now, so unless ovkl patches a new ally who works differently we are good
	
	if managers.groupai:state():whisper_mode() and action_desc.variant == "tied_all_in_one" then -- Only add highlight in stealth
		if immdomcops.settings.highlights == true then
			self._unit:contour():add( "friendly" , true )
		end
	elseif action_desc.variant == "hands_up" then -- If hands are up activate highlights and invulnerability, and sync that info to clients
		if immdomcops.settings.highlights == true then
			self._unit:contour():add( "friendly" , true )
		end
		self._unit:network():send("set_unit_invulnerable", true, true)
		self._unit:character_damage():set_invulnerable(true)
		self._unit:character_damage():set_immortal(true)
	elseif action_desc.variant == "hands_back" then
		-- dont remove highlights if getting on knees
	elseif action_desc.variant == "tied" then
		-- dont remove highlights if cuffed
		immdomcops.hostages[self._unit:id()] = true -- add unit's id to our list of hostages for melee insta kill tracking
	else
		if immdomcops.hostages[self._unit:id()] then -- remove unit's id if they are no longer a hostage
			immdomcops.hostages[self._unit:id()] = nil
		end
		
		if immdomcops.settings.highlights == true then -- remove highlights
			self._unit:contour():remove( "friendly" , true ) 
		end
		
		if managers.groupai:state():is_enemy_converted_to_criminal(self._unit) then -- but if enemy is converted add a highlight
			if immdomcops.settings.highlights == true then
				self._unit:contour():add( "friendly" , true )
			end
		end
		
		if self._unit:character_damage().set_immortal then -- check that unit can be immortal
			if self._unit:character_damage()._immortal ~= false then -- check that unit is allready immortal, then remove immortality and sync that to clients
				self._unit:character_damage():set_invulnerable(false)
				self._unit:character_damage():set_immortal(false)
				self._unit:network():send("set_unit_invulnerable", false, false)
			end
		end
	end
end )