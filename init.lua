local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)

cottages = {
	version = os.time({year = 2022, month = 9, day = 29}),
	fork = "fluxionary",

	modname = modname,
	modpath = modpath,
	S = S,

	has = {
		bucket = minetest.get_modpath("bucket"),
		default = minetest.get_modpath("default"),
		doors = minetest.get_modpath("doors"),
		env_sounds = minetest.get_modpath("env_sounds"),
		ethereal = minetest.get_modpath("ethereal"),
		farming = minetest.get_modpath("farming"),
		moreblocks = minetest.get_modpath("moreblocks"),
		node_entity_queue = minetest.get_modpath("node_entity_queue"),
		player_api = minetest.get_modpath("player_api"),
		player_monoids = minetest.get_modpath("player_monoids"),
		stairs = minetest.get_modpath("stairs"),
		stairsplus = minetest.get_modpath("stairsplus"),
		stamina = minetest.get_modpath("stamina") and minetest.global_exists("stamina") and stamina.exhaust_player,
		technic = minetest.get_modpath("technic"),
		unified_inventory = minetest.get_modpath("unified_inventory"),
		wool = minetest.get_modpath("wool"),
		workbench = minetest.get_modpath("workbench"),
	},

	log = function(level, messagefmt, ...)
		return minetest.log(level, ("[%s] %s"):format(modname, messagefmt:format(...)))
	end,

	dofile = function(...)
		return dofile(table.concat({modpath, ...}, DIR_DELIM) .. ".lua")
	end,
}

cottages.dofile("settings")
cottages.dofile("util")
cottages.dofile("resources", "init")
cottages.dofile("api", "init")
cottages.dofile("modules", "init")
