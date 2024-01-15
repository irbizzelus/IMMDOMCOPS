Hooks:PostHook(CopMovement, "action_request", "IDC_post_action_request_tweak_unit_data" , function(self,action_desc)
	
	if not Network:is_server() then
		return
	end
	
	-- idk, some check if unit is busy or something? ask Undeadsewer, that's his code
	if self._unit:base().mic_is_being_moved then
		return
	end
	
	if managers.enemy:is_civilian(self._unit) then
		return
	end
	
	-- check if 'cop' action is requested by an actuall cop and not by Hoxton or other friendly ai, who are supposed to be immortal
	if self._unit:base():char_tweak().access == "teamAI4" then
		return
	end
	
	-- only highlights in stealth
	if managers.groupai:state():whisper_mode() and action_desc.variant == "tied_all_in_one" then
		if immdomcops.settings.highlights == true then
			self._unit:contour():add( "friendly" , true )
		end
	-- on hands up activate everything
	elseif action_desc.variant == "hands_up" then
		if immdomcops.settings.highlights == true then
			self._unit:contour():add( "friendly" , true )
		end
		self._unit:network():send("set_unit_invulnerable", true, true)
		self._unit:character_damage():set_invulnerable(true)
		self._unit:character_damage():set_immortal(true)
		immdomcops.hostages[self._unit:id()] = "giving_up"
	elseif action_desc.variant == "hands_back" then
		-- dont remove highlights if getting on knees
	elseif action_desc.variant == "tied" then
		immdomcops.hostages[self._unit:id()] = "gave_up"
		DelayedCalls:Add("IDC_remove_invuln_for_unit_"..tostring(self._unit:id()), immdomcops.settings.immortality_duration, function()
			if alive(self._unit) and self._unit:character_damage().set_immortal and self._unit:character_damage()._immortal ~= false then
				self._unit:network():send("set_unit_invulnerable", false, false)
				self._unit:character_damage():set_invulnerable(false)
				self._unit:character_damage():set_immortal(false)
				immdomcops.hostages[self._unit:id()] = nil
			end
			
			if alive(self._unit) and not managers.groupai:state():is_enemy_converted_to_criminal(self._unit) and self._unit:contour() and self._unit:contour()._contour_list and #self._unit:contour()._contour_list >= 1 and not immdomcops.settings.keep_hl_for_mortals then
				for i=1, #self._unit:contour()._contour_list do
					if self._unit:contour()._contour_list[i] and self._unit:contour()._contour_list[i].type and self._unit:contour()._contour_list[i].type == "friendly" then
						self._unit:contour():remove( "friendly" , true ) 
					end
				end
			end
		end)
	else
		if immdomcops.settings.highlights == true then
			if managers.groupai:state():is_enemy_converted_to_criminal(self._unit) then
				-- dont remove highlights if enemy is converted
			else
				if self._unit:contour() and self._unit:contour()._contour_list and #self._unit:contour()._contour_list >= 1  then
					for i=1, #self._unit:contour()._contour_list do
						if self._unit:contour()._contour_list[i] and self._unit:contour()._contour_list[i].type and self._unit:contour()._contour_list[i].type == "friendly" then
							self._unit:contour():remove( "friendly" , true ) 
						end
					end
				end
			end
		end
		
		-- if unit is part of our hostage list and requests a new action, remove their immortality since they are now untied/converted and their AI sends requests again
		if immdomcops.hostages[self._unit:id()] then
			if self._unit:character_damage().set_immortal then
				if self._unit:character_damage()._immortal ~= false then
					self._unit:character_damage():set_invulnerable(false)
					self._unit:character_damage():set_immortal(false)
					self._unit:network():send("set_unit_invulnerable", false, false)
					immdomcops.hostages[self._unit:id()] = nil
				end
			end
		end
	end
	
end)