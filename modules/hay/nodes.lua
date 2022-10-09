local S = cottages.S

minetest.register_node("cottages:hay_mat", {
	drawtype = "nodebox",
	paramtype2 = "leveled",
	description = S("Some hay"),
	tiles = {
		cottages.textures.straw .. "^[multiply:#88BB88"
	},
	groups = {hay = 3, snappy = 2, oddly_breakable_by_hand = 2, flammable = 3},
	sounds = cottages.sounds.leaves,
	-- the bale is slightly smaller than a full node
	is_ground_content = false,
	node_box = {
		type = "leveled", --"fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
		}
	},
	-- make sure a placed hay block looks halfway reasonable
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		minetest.swap_node(pos, {name = "cottages:hay_mat", param2 = math.random(2, 25)})
	end,
})

-- hay block, similar to straw block
minetest.register_node("cottages:hay", {
	description = S("Hay"),
	tiles = {cottages.textures.straw .. "^[multiply:#88BB88"},
	groups = {hay = 3, snappy = 2, oddly_breakable_by_hand = 2, flammable = 3},
	sounds = cottages.sounds.leaves,
	is_ground_content = false,
})

-- hay bales for hungry animals
minetest.register_node("cottages:hay_bale", {
	drawtype = "nodebox",
	description = S("Hay bale"),
	tiles = {"cottages_darkage_straw_bale.png^[multiply:#88BB88"},
	paramtype = "light",
	groups = {hay = 3, snappy = 2, oddly_breakable_by_hand = 2, flammable = 3},
	sounds = cottages.sounds.leaves,
	-- the bale is slightly smaller than a full node
	node_box = {
		type = "fixed",
		fixed = {
			{-0.45, -0.5, -0.45, 0.45, 0.45, 0.45},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.45, -0.5, -0.45, 0.45, 0.45, 0.45},
		}
	},
	is_ground_content = false,
})
