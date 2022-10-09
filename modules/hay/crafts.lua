
minetest.register_craft({
	output = "cottages:hay_mat 9",
	recipe = {
		{"cottages:hay"},
	},
})

minetest.register_craft({
	output = "cottages:hay",
	recipe = {
		{"cottages:hay_mat", "cottages:hay_mat", "cottages:hay_mat"},
		{"cottages:hay_mat", "cottages:hay_mat", "cottages:hay_mat"},
		{"cottages:hay_mat", "cottages:hay_mat", "cottages:hay_mat"},
	},
})

minetest.register_craft({
	output = "cottages:hay",
	recipe = {{"cottages:hay_bale"}},
})

minetest.register_craft({
	output = "cottages:hay_bale",
	recipe = {{"cottages:hay"}},
})
