local S = cottages.S

-- window shutters - they cover half a node to each side
minetest.register_node("cottages:window_shutter_open", {
	description = S("opened window shutters"),
	drawtype = "nodebox",
	tiles = {"cottages_minimal_wood.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
	-- larger than one node but slightly smaller than a half node so that wallmounted torches pose no problem
	node_box = {
		type = "fixed",
		fixed = {
			{-0.90, -0.5, 0.4, -0.45, 0.5, 0.5},
			{0.45, -0.5, 0.4, 0.9, 0.5, 0.5},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.9, -0.5, 0.4, 0.9, 0.5, 0.5},
		},
	},
	on_rightclick = function(pos, node, puncher)
		cottages.doorlike.shutter_close(pos, puncher)
	end,
	is_ground_content = false,
})

minetest.register_node("cottages:window_shutter_closed", {
	description = S("closed window shutters"),
	drawtype = "nodebox",
	tiles = {"cottages_minimal_wood.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4, -0.05, 0.5, 0.5},
			{0.05, -0.5, 0.4, 0.5, 0.5, 0.5},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4, 0.5, 0.5, 0.5},
		},
	},
	on_rightclick = function(pos, node, puncher)
		cottages.doorlike.shutter_open(pos, puncher)
	end,
	is_ground_content = false,
	drop = "cottages:window_shutter_open",
})

minetest.register_node("cottages:half_door", {
	description = S("half door"),
	drawtype = "nodebox",
	tiles = {"cottages_minimal_wood.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4, 0.48, 0.5, 0.5},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4, 0.48, 0.5, 0.5},
		},
	},
	on_rightclick = function(pos, node, puncher)
		local node2 = minetest.get_node({x = pos.x, y = (pos.y + 1), z = pos.z})

		local param2 = node.param2
		if param2 % 4 == 1 then
			param2 = param2 + 1; --2
		elseif param2 % 4 == 2 then
			param2 = param2 - 1; --1
		elseif param2 % 4 == 3 then
			param2 = param2 - 3; --0
		elseif param2 % 4 == 0 then
			param2 = param2 + 3; --3
		end
		minetest.swap_node(pos, {name = "cottages:half_door", param2 = param2})
		-- if the node above consists of a door of the same type, open it as well
		-- Note: doors beneath this one are not opened!
		-- It is a special feature of these doors that they can be opend partly
		if node2 ~= nil and node2.name == node.name and node2.param2 == node.param2 then
			minetest.swap_node({x = pos.x, y = (pos.y + 1), z = pos.z}, {name = "cottages:half_door", param2 = param2})
		end
	end,
	is_ground_content = false,
})

minetest.register_node("cottages:half_door_inverted", {
	description = S("half door inverted"),
	drawtype = "nodebox",
	tiles = {"cottages_minimal_wood.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.48, 0.5, -0.4},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.48, 0.5, -0.4},
		},
	},
	on_rightclick = function(pos, node, puncher)
		local node2 = minetest.get_node({x = pos.x, y = (pos.y + 1), z = pos.z})

		local param2 = node.param2
		if param2 % 4 == 1 then
			param2 = param2 - 1; --0
		elseif param2 % 4 == 0 then
			param2 = param2 + 1; --1
		elseif param2 % 4 == 2 then
			param2 = param2 + 1; --3
		elseif param2 % 4 == 3 then
			param2 = param2 - 1; --2
		end
		minetest.swap_node(pos, {name = "cottages:half_door_inverted", param2 = param2})
		-- open upper parts of this door (if there are any)
		if node2 ~= nil and node2.name == node.name and node2.param2 == node.param2 then
			minetest.swap_node({x = pos.x, y = (pos.y + 1), z = pos.z},
				{name = "cottages:half_door_inverted", param2 = param2})
		end
	end,
	is_ground_content = false,
})

minetest.register_node("cottages:gate_closed", {
	description = S("closed fence gate"),
	drawtype = "nodebox",
	tiles = {cottages.textures.furniture},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.85, -0.25, -0.02, 0.85, -0.05, 0.02},
			{-0.85, 0.15, -0.02, 0.85, 0.35, 0.02},

			{-0.80, -0.05, -0.02, -0.60, 0.15, 0.02},
			{0.60, -0.05, -0.02, 0.80, 0.15, 0.02},
			{-0.15, -0.05, -0.02, 0.15, 0.15, 0.02},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.85, -0.25, -0.1, 0.85, 0.35, 0.1},
		},
	},
	on_rightclick = function(pos, node, puncher)
		minetest.swap_node(pos, {name = "cottages:gate_open", param2 = node.param2})
	end,
	is_ground_content = false,
})

minetest.register_node("cottages:gate_open", {
	description = S("opened fence gate"),
	drawtype = "nodebox",
	tiles = {cottages.textures.furniture},
	paramtype = "light",
	paramtype2 = "facedir",
	drop = "cottages:gate_closed",
	groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2, not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.85, -0.5, -0.25, 0.85, -0.46, -0.05},
			{-0.85, -0.5, 0.15, 0.85, -0.46, 0.35},

			{-0.80, -0.5, -0.05, -0.60, -0.46, 0.15},
			{0.60, -0.5, -0.05, 0.80, -0.46, 0.15},
			{-0.15, -0.5, -0.05, 0.15, -0.46, 0.15},

		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.85, -0.5, -0.25, 0.85, -0.3, 0.35},
		},
	},
	on_rightclick = function(pos, node, puncher)
		minetest.swap_node(pos, {name = "cottages:gate_closed", param2 = node.param2})
	end,
	is_ground_content = false,
})

-- further alternate hatch materials: wood, tree, copper_block
cottages.doorlike.register_hatch(
	"cottages:hatch_wood",
	"wooden hatch",
	"cottages_minimal_wood.png",
	cottages.craftitems.slab_wood,
	{
		groups = {node = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		sounds = cottages.sounds.wood,
	}
)

cottages.doorlike.register_hatch(
	"cottages:hatch_steel",
	"metal hatch",
	"cottages_steel_block.png",
	cottages.craftitems.steel,
	{
		groups = {node = 1, cracky = 1, level = 2},
		sounds = cottages.sounds.metal,
		sound_open = "doors_steel_door_open",
		sound_close = "doors_steel_door_close",
		protected = true,
	}
)
