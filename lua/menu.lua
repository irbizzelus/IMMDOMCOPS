if not immdomcops then
    _G.immdomcops = {}
	immdomcops.modpath = ModPath
	immdomcops.hostages = {}
	immdomcops.settings = {
		highlights = true,
		keep_hl_for_mortals = true,
		immortality_duration = 5
    }

    function immdomcops:Save()
        local file = io.open(SavePath .. 'IMMDOMCOP_save.txt', 'w+')
        if file then
            file:write(json.encode(immdomcops.settings))
            file:close()
        end
    end
    
    function immdomcops:Load()
        local file = io.open(SavePath .. 'IMMDOMCOP_save.txt', 'r')
        if file then
            for k, v in pairs(json.decode(file:read('*all')) or {}) do
                immdomcops.settings[k] = v
            end
            file:close()
        end
    end
	
	immdomcops:Load()
    immdomcops:Save()	
end