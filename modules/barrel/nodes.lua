local S = cottages.S

-- this barrel is opened at the top
minetest.register_node("cottages:barrel_open", {
	description = S("Barrel (Open)"),
	drawtype = "mesh",
	paramtype = "light",
	paramtype2 = "facedir",
	mesh = "cottages_barrel.obj",
	tiles = {"cottages_barrel.png"},
	is_ground_content = false,
	groups = {
		snappy = 1,
		choppy = 2,
		oddly_breakable_by_hand = 1,
		flammable = 2,
	},
})

-- let's hope "tub" is the correct english word for "bottich"
minetest.register_node("cottages:tub", {
	description = S("tub"),
	paramtype = "light",
	drawtype = "mesh",
	mesh = "cottages_tub.obj",
	tiles = {"cottages_barrel.png"},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.1, 0.5},
		}},
		collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.1, 0.5},
		}},
	groups = {
		snappy = 1,
		choppy = 2,
		oddly_breakable_by_hand = 1,
		flammable = 2
	},
	is_ground_content = false,
})
