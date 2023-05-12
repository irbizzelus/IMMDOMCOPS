Hooks:PostHook(CopMovement, "action_request", "IDC_post_action_request_tweak_unit_data" , function(self,action_desc)
	
	if not Network:is_server() then
		return
	end
	
	-- idk, some check if unit is busy or something? ask Undeadsewer, thats his code
	if self._unit:base().mic_is_being_moved then
		return
	end
	
	if managers.enemy:is_civilian( self._unit ) then
		return
	end
	
	-- Check if 'cop' action is requested by an actuall cop and not by Hoxton or other friendly ai, who are supposed to be immortal
	if self._unit:base():char_tweak().access == "teamAI4" then
		return
	end
	
	if managers.groupai:state():whisper_mode() and action_desc.variant == "tied_all_in_one" then
	
		-- Only add highlights in stealth
		if immdomcops.settings.highlights == true then
			self._unit:contour():add( "friendly" , true )
		end
		
	-- If hands are up activate highlights and invulnerability, and sync that info to clients
	elseif action_desc.variant == "hands_up" then
	
		if immdomcops.settings.highlights == true then
			self._unit:contour():add( "friendly" , true )
		end
		
		self._unit:network():send("set_unit_invulnerable", true, true)
		self._unit:character_damage():set_invulnerable(true)
		self._unit:character_damage():set_immortal(true)
		
		-- add unit's id to our list of immortal hostages
		immdomcops.hostages[self._unit:id()] = "hands_up"
		
	elseif action_desc.variant == "hands_back" then
	
		-- dont remove highlights if getting on knees
		
	elseif action_desc.variant == "tied" then
	
		-- dont remove highlights if cuffed
		
		-- add unit's id to our list of immortal hostages for melee insta kill tracking
		immdomcops.hostages[self._unit:id()] = "tied_down"
		
	else
		
		if immdomcops.settings.highlights == true then
			if managers.groupai:state():is_enemy_converted_to_criminal(self._unit) then
				-- dont remove highlights if enemy is converted
			else
				-- remove highlights otherwise
				-- sanity check #1
				if self._unit:contour() then
					-- sanity check #2
					if self._unit:contour()._contour_list then
						if #self._unit:contour()._contour_list >= 1 then
						
							for i=1, #self._unit:contour()._contour_list do
								if self._unit:contour()._contour_list[i].type == "friendly" then
									self._unit:contour():remove( "friendly" , true ) 
								end
							end
							
						end
					end
				end
			end
		end
		
		-- if unit is part of our hostage list and requests a new action, remove their immortality since they are now untied/converted and their AI sends requests again
		if immdomcops.hostages[self._unit:id()] then
			-- check that unit can be immortal, just in case
			if self._unit:character_damage().set_immortal then
				-- check that unit is allready immortal
				if self._unit:character_damage()._immortal ~= false then
				
					self._unit:character_damage():set_invulnerable(false)
					self._unit:character_damage():set_immortal(false)
					self._unit:network():send("set_unit_invulnerable", false, false)
					
					-- remove unit's id from our hostage list
					immdomcops.hostages[self._unit:id()] = nil
				end
			end
		end

	end
	
end)