if not immdomcops then
	dofile(ModPath .. "lua/menu.lua")
end

Hooks:Add('LocalizationManagerPostInit', 'immdomcops_loc', function(loc)
	immdomcops:Load()
	
	local lang = "en"
	local file = io.open(SavePath .. 'blt_data.txt', 'r')
    if file then
        for k, v in pairs(json.decode(file:read('*all')) or {}) do
			if k == "language" then
				lang = v
			end
        end
        file:close()
    end

	if lang == "ru" then
		loc:load_localization_file(immdomcops.modpath .. 'menus/lang/immdomcopsmenu_ru.txt', false)
	elseif lang == "fr" then -- thanks Tardoss
		loc:load_localization_file(immdomcops.modpath .. 'menus/lang/immdomcopsmenu_fr.txt', false)
	elseif lang == "chs" then -- thanks Arknights
		loc:load_localization_file(immdomcops.modpath .. 'menus/lang/immdomcopsmenu_chs.txt', false)
	elseif lang == "es" then -- thanks MaxiAccess
		loc:load_localization_file(immdomcops.modpath .. 'menus/lang/immdomcopsmenu_es.txt', false)
	elseif lang == "pt-br" then -- thanks gabsF
		loc:load_localization_file(immdomcops.modpath .. 'menus/lang/immdomcopsmenu_pt-br.txt', false)
	else
		loc:load_localization_file(immdomcops.modpath .. 'menus/lang/immdomcopsmenu_en.txt', false)
	end
end)

Hooks:Add('MenuManagerInitialize', 'immdomcops_init', function(menu_manager)
	MenuCallbackHandler.idc_immdomcopssave = function(this, item)
		immdomcops:Save()
	end

	MenuCallbackHandler.idc_cb_highlights = function(this, item)
		immdomcops.settings[item:name()] = item:value() == 'on'
		immdomcops:Save()
	end
	
	MenuCallbackHandler.idc_cb_keep_hl_for_mortals = function(this, item)
		immdomcops.settings[item:name()] = item:value() == 'on'
		immdomcops:Save()
	end
	
	MenuCallbackHandler.idc_cb_immortality_duration = function(this, item)
		immdomcops.settings.immortality_duration = math.floor(tonumber(item:value()))
		immdomcops:Save()
	end

	immdomcops:Load()

	MenuHelper:LoadFromJsonFile(immdomcops.modpath .. 'menus/immdomcopsmenu.txt', immdomcops, immdomcops.settings)
end)

Hooks:PostHook(MenuManager, "_node_selected", "IDC:Node", function(self, menu_name, node)
	if type(node) == "table" and node._parameters.name == "main" and (not immdomcops.settings.changelog_msg_shown or immdomcops.settings.changelog_msg_shown and immdomcops.settings.changelog_msg_shown < 1.7) then
		DelayedCalls:Add("IDC_showchangelogmsg_delayed", 0.9, function()
			local menu_options = {}
			menu_options[#menu_options+1] = {text = "Understood", is_cancel_button = true}
			local message = "1.7 Important Update!!!\n\n- This update changed this mod's core mechanic of immortality to NOT LAST FOREVER. From now on, after FULLY intimidating a cop, they will loose their immortality after certain amount of seconds (you can change this duration in IDC mod options). Melee insta-kill option was removed and replaced with 2 new settings related to this change.\n- LOCALIZATION is not up to date unless you are running English/Russian language options in BLT settings.\n\nOn a personal note, from now on any user running versions older then 1.7 are considered cheaters in my eyes, because keeping a bunch of tied down immortal cops for perk/skill bonuses or easier game completions should not have been a thing with this mod from the start. Now this mod just removes frustration that other players could cause, without providing any gameplay advantages."
			local menu = QuickMenu:new("Immortal dom'ed cops", message, menu_options)
			menu:Show()
			immdomcops.settings.changelog_msg_shown = 1.7
			immdomcops:Save()
		end)
	end
end)