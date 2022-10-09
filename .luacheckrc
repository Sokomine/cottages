std = "lua51+luajit+minetest+cottages"
unused_args = false
max_line_length = 120

stds.minetest = {
	read_globals = {
		"DIR_DELIM",
		"minetest",
		"core",
		"dump",
		"vector",
		"nodeupdate",
		"VoxelManip",
		"VoxelArea",
		"PseudoRandom",
		"ItemStack",
		"default",
		"table",
		"math",
		"string",
	}
}

stds.cottages = {
	globals = {
		"cottages",
	},
	read_globals = {
	    player_api = {
	        fields = {
	            player_attached = {
                    read_only = false,
                    other_fields = true,
	            },
	        },
	        other_fields = true,
	    },

	    "carts",
		"default",
		"doors",
		"fs_layout",
		"futil",
		"node_entity_queue",
		"player_monoids",
		"stairs",
		"stamina",
		"unified_inventory",
	},
}
