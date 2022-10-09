local ci = cottages.craftitems

-- transform opend and closed shutters into each other for convenience
minetest.register_craft({
	output = "cottages:window_shutter_open",
	recipe = {
		{"cottages:window_shutter_closed"},
	}
})

minetest.register_craft({
	output = "cottages:window_shutter_closed",
	recipe = {
		{"cottages:window_shutter_open"},
	}
})

if ci.wood then
	minetest.register_craft({
		output = "cottages:window_shutter_open",
		recipe = {
			{ci.wood, "", ci.wood},
		}
	})
end

-- transform one half door into another
minetest.register_craft({
	output = "cottages:half_door",
	recipe = {
		{"cottages:half_door_inverted"},
	}
})

minetest.register_craft({
	output = "cottages:half_door_inverted",
	recipe = {
		{"cottages:half_door"},
	}
})

if ci.wood and ci.door then
	minetest.register_craft({
		output = "cottages:half_door 2",
		recipe = {
			{"", ci.wood, ""},
			{"", ci.door, ""},
		}
	})
end

-- transform open and closed versions into into another for convenience
minetest.register_craft({
	output = "cottages:gate_closed",
	recipe = {
		{"cottages:gate_open"},
	}
})

minetest.register_craft({
	output = "cottages:gate_open",
	recipe = {
		{"cottages:gate_closed"},
	}
})

if ci.stick and ci.wood then
	minetest.register_craft({
		output = "cottages:gate_closed",
		recipe = {
			{ci.stick, ci.stick, ci.wood},
		}
	})
end
