local S = cottages.S

if cottages.has.wool and minetest.registered_nodes["wool:white"] then
	minetest.register_alias("cottages:wool", "wool:white")
else
	minetest.register_node("cottages:wool", {
		description = "Wool",
		tiles = { "cottages_wool.png" },
		is_ground_content = false,
		groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3, wool = 1 },
	})
end

minetest.register_node("cottages:wool_tent", {
	description = S("wool for tents"),
	drawtype = "nodebox",
	tiles = { "cottages_wool.png" },
	paramtype = "light",
	paramtype2 = "facedir",
	groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.50, 0.5, -0.5 + 1 / 16, 0.50 },
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.50, 0.5, -0.5 + 1 / 16, 0.50 },
		},
	},
	is_ground_content = false,
	on_place = minetest.rotate_node,
})

minetest.register_node("cottages:wood_flat", {
	description = S("flat wooden planks"),
	drawtype = "nodebox",
	tiles = { "cottages_minimal_wood.png" },
	paramtype = "light",
	paramtype2 = "facedir",
	groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.50, 0.5, -0.5 + 1 / 16, 0.50 },
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.50, 0.5, -0.5 + 1 / 16, 0.50 },
		},
	},
	is_ground_content = false,
	on_place = minetest.rotate_node,
})

minetest.register_node("cottages:glass_pane", {
	description = S("simple glass pane (centered)"),
	drawtype = "nodebox",
	tiles = { "cottages_glass_pane.png" },
	paramtype = "light",
	paramtype2 = "facedir",
	use_texture_alpha = "clip",
	groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.05, 0.5, 0.5, 0.05 },
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.05, 0.5, 0.5, 0.05 },
		},
	},
	is_ground_content = false,
})

minetest.register_node("cottages:glass_pane_side", {
	description = S("simple glass pane"),
	drawtype = "nodebox",
	tiles = { "cottages_glass_pane.png" },
	paramtype = "light",
	paramtype2 = "facedir",
	use_texture_alpha = "clip",
	groups = { snappy = 2, choppy = 2, oddly_breakable_by_hand = 2 },
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.40, 0.5, 0.5, -0.50 },
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.40, 0.5, 0.5, -0.50 },
		},
	},
	is_ground_content = false,
})

minetest.register_node("cottages:straw_ground", {
	description = S("straw ground for animals"),
	tiles = {
		cottages.straw_texture,
		"cottages_loam.png",
		"cottages_loam.png",
		"cottages_loam.png",
		"cottages_loam.png",
		"cottages_loam.png",
	},
	groups = { snappy = 2, crumbly = 3, choppy = 2, oddly_breakable_by_hand = 2 },
	sounds = cottages.sounds.leaves,
	is_ground_content = false,
})

minetest.register_node("cottages:loam", {
	description = S("loam"),
	tiles = { "cottages_loam.png" },
	groups = { snappy = 2, crumbly = 3, choppy = 2, oddly_breakable_by_hand = 2 },
	sounds = cottages.sounds.dirt,
	is_ground_content = false,
})

minetest.register_node("cottages:wagon_wheel", {
	description = S("wagon wheel"),
	drawtype = "signlike",
	tiles = { "cottages_wagonwheel.png" },
	inventory_image = "cottages_wagonwheel.png",
	wield_image = "cottages_wagonwheel.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
	},
	groups = { choppy = 2, dig_immediate = 2, attached_node = 1 },
	legacy_wallmounted = true,
	is_ground_content = false,
})

if cottages.has.stairs then
	stairs.register_stair_and_slab(
		"loam",
		"cottages:loam",
		{ snappy = 2, crumbly = 3, choppy = 2, oddly_breakable_by_hand = 2 },
		{ "cottages_loam.png" },
		S("Loam Stairs"),
		S("Loam Slab"),
		cottages.sounds.dirt
	)
end
