dofile(ModPath .. "lua/menu.lua")

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
	else
		loc:load_localization_file(immdomcops.modpath .. 'menus/lang/immdomcopsmenu_en.txt', false)
	end
end)

Hooks:Add('MenuManagerInitialize', 'immdomcops_init', function(menu_manager)
	MenuCallbackHandler.idc_immdomcopssave = function(this, item)
		immdomcops:Save()
	end
	
	MenuCallbackHandler.idc_donothing = function(this, item)
		-- do nothing
	end

	MenuCallbackHandler.idc_cb_highlights = function(this, item)
		immdomcops.settings[item:name()] = item:value() == 'on'
		immdomcops:Save()
	end
	
	MenuCallbackHandler.idc_cb_meleekill = function(this, item)
		immdomcops.settings[item:name()] = item:value() == 'on'
		immdomcops:Save()
	end

	immdomcops:Load()

	MenuHelper:LoadFromJsonFile(immdomcops.modpath .. 'menus/immdomcopsmenu.txt', immdomcops, immdomcops.settings)
end)