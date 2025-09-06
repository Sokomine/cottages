-- store for which player we're showing which huds
cottages.hud_wait = {}


-- remove all huds that were shown to the player via cottages.add_hud_list
cottages.unshow_hud_list = function(puncher)
	if(not(puncher) or not(cottages.hud_wait[puncher])) then
		return
	end
	for i, hud_id in ipairs(cottages.hud_wait[puncher] or {}) do
		if(puncher and hud_id) then
			puncher:hud_remove(hud_id)
		end
	end
	cottages.hud_wait[puncher] = nil
end


-- show a list of huds to puncher and remove them after delay seconds
cottages.add_hud_list = function(puncher, delay, hud_list)
	if(not(puncher) or not(hud_list) or not(delay)) then
		return
	end
	if(cottages.hud_wait[puncher]) then
		-- if necessary, remove all currently shown huds (it would get
		-- pretty messy if we had overlaying huds here)
		cottages.unshow_hud_list(puncher)
	end
	-- start with a new, clear list
	cottages.hud_wait[puncher] = {}
	for i, hud_def in ipairs(hud_list or {}) do
		local hud_id = puncher:hud_add(hud_def)
		table.insert(cottages.hud_wait[puncher], hud_id)
	end
	minetest.after(delay, cottages.unshow_hud_list, puncher)
end
