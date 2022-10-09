local S = cottages.S

if not (minetest.registered_nodes["farming:straw"]) then
	minetest.register_node("cottages:straw", {
		drawtype = "normal",
		description = S("straw"),
		tiles = {cottages.textures.straw},
		groups = {hay = 3, snappy = 2, oddly_breakable_by_hand = 2, flammable = 3},
		sounds = cottages.sounds.leaves,
		-- the bale is slightly smaller than a full node
		is_ground_content = false,
	})
else
	minetest.register_alias("cottages:straw", "farming:straw")
end


minetest.register_node("cottages:straw_mat", {
	description = S("layer of straw"),
	drawtype = "nodebox",
	tiles = {cottages.textures.straw}, -- done by VanessaE
	wield_image = cottages.textures.straw,
	inventory_image = cottages.textures.straw,
	sunlight_propagates = true,
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = false,
	groups = {hay = 3, snappy = 2, oddly_breakable_by_hand = 2, flammable = 3},
	sounds = cottages.sounds.leaves,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.48, -0.5, -0.48, 0.48, -0.45, 0.48},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.48, -0.5, -0.48, 0.48, -0.25, 0.48},
		}
	},
	is_ground_content = false,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		return cottages.sleep_in_bed(pos, node, clicker, itemstack, pointed_thing)
	end
})

-- straw bales are a must for farming environments; if you for some reason do not have the darkage mod installed, this
-- here gets you a straw bale
minetest.register_node("cottages:straw_bale", {
	drawtype = "nodebox",
	description = S("straw bale"),
	tiles = {"cottages_darkage_straw_bale.png"},
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
