local s = minetest.settings

cottages.settings = {
	anvil = {
		enabled = s:get_bool("cottages.anvil.enabled", true),

		disable_hammer_repair = s:get_bool("cottages.anvil.disable_hammer_repair", false),
		hammer_wear = tonumber(s:get("cottages.anvil.hammer_wear")) or 100,
		hud_timeout = tonumber(s:get("cottages.anvil.hud_timeout")) or 2, -- seconds
		repair_amount = tonumber(s:get("cottages.anvil.repair_amount")) or 4369,
		stamina = tonumber(s:get("cottages.anvil.stamina")) or 40,
		formspec_enabled = s:get_bool("cottages.anvil.formspec_enabled", true),
		tool_hud_enabled = s:get_bool("cottages.anvil.tool_hud_enabled", true),
		tool_entity_enabled = s:get_bool("cottages.anvil.tool_entity_enabled", false),
		tool_entity_displacement = tonumber(s:get("cottages.anvil.tool_entity_displacement")) or 2 / 16,
	},

	barrel = {
		enabled = s:get_bool("cottages.barrel.enabled", true),

		max_liquid_amount = tonumber(s:get("cottages.barrel.max_liquid_amount")) or 99,
	},

	doorlike = {
		enabled = s:get_bool("cottages.doorlike.enabled", true),

		stamina = tonumber(s:get("cottages.doorlike.stamina")) or 1,
	},

	feldweg = {
		enabled = s:get_bool("cottages.feldweg.enabled", true),
	},

	fences = {
		enabled = s:get_bool("cottages.fences.enabled", true),
	},

	furniture = {
		enabled = s:get_bool("cottages.furniture.enabled", true),
	},

	hay = {
		enabled = s:get_bool("cottages.hay.enabled", true),
	},

	historic = {
		enabled = s:get_bool("cottages.historic.enabled", true),
	},

	mining = {
		enabled = s:get_bool("cottages.mining.enabled", true),
	},

	pitchfork = {
		enabled = s:get_bool("cottages.pitchfork.enabled", true),

		stamina = tonumber(s:get("cottages.pitchfork.stamina")) or 10,
	},

	roof = {
		enabled = s:get_bool("cottages.roof.enabled", true),

		use_farming_straw_stairs = (
			s:get_bool("cottages.roof.use_farming_straw_stairs", false) and
			minetest.registered_nodes["stairs:stair_straw"]
		),
	},

	straw = {
		enabled = s:get_bool("cottages.straw.enabled", true),

		quern_min_per_turn = tonumber(s:get("cottages.straw.quern_min_per_turn")) or 2,
		quern_max_per_turn = tonumber(s:get("cottages.straw.quern_max_per_turn")) or 5,
		quern_stamina = tonumber(s:get("cottages.straw.quern_stamina")) or 20,

		threshing_min_per_punch = tonumber(s:get("cottages.straw.threshing_min_per_punch")) or 5,
		threshing_max_per_punch = tonumber(s:get("cottages.straw.threshing_max_per_punch")) or 10,
		threshing_stamina = tonumber(s:get("cottages.straw.threshing_stamina")) or 20,
	},

	water = {
		enabled = s:get_bool("cottages.water.enabled", true),

		well_fill_time = tonumber(s:get("cottages.water.well_fill_time")) or 10
	},
}
