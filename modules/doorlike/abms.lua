-- open shutters in the morning
minetest.register_abm({
	nodenames = {"cottages:window_shutter_closed"},
	interval = 20, -- change this to 600 if your machine is too slow
	chance = 3, -- not all people wake up at the same time!
	action = function(pos)
		if not cottages.doorlike.is_night() then
			cottages.doorlike.shutter_open(pos)
		end
	end
})

-- close them at night
minetest.register_abm({
	nodenames = {"cottages:window_shutter_open"},
	interval = 20, -- change this to 600 if your machine is too slow
	chance = 2,
	action = function(pos)
		if cottages.doorlike.is_night() then
			cottages.doorlike.shutter_close(pos)
		end
	end
})
