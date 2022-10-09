local api = cottages.barrel

local rotations = {
	3 * 4,
	2 * 4,
	4 * 4,
	1 * 4,
}

minetest.register_lbm({
	label = "Convert lying barrels",
	name = "cottages:convert_lying_barrels",
	nodenames = {"cottages:barrel_lying", "cottages:barrel_lying_open"},
	run_at_every_load = false,
	action = function(pos, node)
		node.name = string.gsub(node.name, "_lying", "")
		node.param2 = rotations[node.param2 + 1] or 0
		minetest.swap_node(pos, node)

		api.update_infotext(pos)
		api.update_formspec(pos)
	end
})
