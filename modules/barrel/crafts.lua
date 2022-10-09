local ci = cottages.craftitems

if ci.wood and ci.steel then
	minetest.register_craft({
		output = "cottages:barrel",
		recipe = {
			{ci.wood, ci.wood, ci.wood},
			{ci.steel, "", ci.steel},
			{ci.wood, ci.wood, ci.wood},
		},
	})

	minetest.register_craft({
		output = "cottages:barrel_open",
		recipe = {
			{ci.wood, "", ci.wood},
			{ci.steel, "", ci.steel},
			{ci.wood, ci.wood, ci.wood},
		},
	})
end

minetest.register_craft({
	output = "cottages:tub 2",
	recipe = {
		{"cottages:barrel"},
	},
})

minetest.register_craft({
	output = "cottages:barrel",
	recipe = {
		{"cottages:tub"},
		{"cottages:tub"},
	},
})
