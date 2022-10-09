local S = cottages.S
local ci = cottages.craftitems

function cottages.roof.register_roof(name, material, tiles)
	minetest.register_node("cottages:roof_" .. name, {
		description = S("Roof " .. name),
		drawtype = "nodebox",
		tiles = tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		is_ground_content = false,
	})

	minetest.register_node("cottages:roof_connector_" .. name, {
		description = S("Roof connector " .. name),
		drawtype = "nodebox",
		-- top, bottom, side1, side2, inner, outer
		tiles = tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		is_ground_content = false,
	})

	-- this one is the slab version of the above roof
	minetest.register_node("cottages:roof_flat_" .. name, {
		description = S("Roof (flat) " .. name),
		drawtype = "nodebox",
		-- top, bottom, side1, side2, inner, outer
		-- this one is from all sides - except from the underside - of the given material
		tiles = {tiles[1], tiles[2], tiles[1], tiles[1], tiles[1], tiles[1]},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			},
		},
		is_ground_content = false,
	})

	minetest.register_craft({
		output = "cottages:roof_" .. name .. " 6",
		recipe = {
			{"", "", material},
			{"", material, ""},
			{material, "", ""}
		}
	})

	minetest.register_craft({
		output = "cottages:roof_connector_" .. name,
		recipe = {
			{"cottages:roof_" .. name},
			{ci.wood},
		}
	})

	minetest.register_craft({
		output = "cottages:roof_flat_" .. name .. " 2",
		recipe = {
			{"cottages:roof_" .. name, "cottages:roof_" .. name},
		}
	})

	-- convert flat roofs back to normal roofs
	minetest.register_craft({
		output = "cottages:roof_" .. name,
		recipe = {
			{"cottages:roof_flat_" .. name, "cottages:roof_flat_" .. name}
		}
	})

end -- of cottages.register_roof( name, tiles, basic_material )
