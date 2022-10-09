local S = cottages.S
local ci = cottages.craftitems

if cottages.settings.roof.use_farming_straw_stairs then
	minetest.register_alias("cottages:roof_straw", "stairs:stair_straw")
	minetest.register_alias("cottages:roof_connector_straw", "stairs:stair_straw")
	minetest.register_alias("cottages:roof_flat_straw", "stairs:slab_straw")

else
	cottages.roof.register_roof(
		"straw",
		"cottages:straw_mat",
		{cottages.textures.straw, cottages.textures.straw,
		 cottages.textures.straw, cottages.textures.straw,
		 cottages.textures.straw, cottages.textures.straw}
	)
end

cottages.roof.register_roof(
	"reet",
	ci.papyrus,
	{"cottages_reet.png", "cottages_reet.png",
	 "cottages_reet.png", "cottages_reet.png",
	 "cottages_reet.png", "cottages_reet.png"}
)

cottages.roof.register_roof(
	"wood",
	ci.wood,
	{cottages.textures.roof_wood, cottages.textures.roof_sides,
	 cottages.textures.roof_sides, cottages.textures.roof_sides,
	 cottages.textures.roof_sides, cottages.textures.roof_wood}
)

cottages.roof.register_roof(
	"black",
	ci.coal_lump,
	{"cottages_homedecor_shingles_asphalt.png", cottages.textures.roof_sides,
	 cottages.textures.roof_sides, cottages.textures.roof_sides,
	 cottages.textures.roof_sides, "cottages_homedecor_shingles_asphalt.png"}
)

cottages.roof.register_roof(
	"red",
	ci.clay_brick,
	{"cottages_homedecor_shingles_terracotta.png", cottages.textures.roof_sides,
	 cottages.textures.roof_sides, cottages.textures.roof_sides,
	 cottages.textures.roof_sides, "cottages_homedecor_shingles_terracotta.png"}
)

cottages.roof.register_roof(
	"brown",
	ci.dirt,
	{"cottages_homedecor_shingles_wood.png", cottages.textures.roof_sides,
	 cottages.textures.roof_sides, cottages.textures.roof_sides,
	 cottages.textures.roof_sides, "cottages_homedecor_shingles_wood.png"}
)

cottages.roof.register_roof(
	"slate",
	ci.stone,
	{"cottages_slate.png", cottages.textures.roof_sides,
	 "cottages_slate.png", "cottages_slate.png",
	 cottages.textures.roof_sides, "cottages_slate.png"}
)

--------

minetest.register_node("cottages:reet", {
	description = S("Reed for thatching"),
	tiles = {"cottages_reet.png"},
	groups = {hay = 3, snappy = 3, choppy = 3, oddly_breakable_by_hand = 3, flammable = 3},
	sounds = cottages.sounds.leaves,
	is_ground_content = false,
})

minetest.register_node("cottages:slate_vertical", {
	description = S("Vertical Slate"),
	tiles = {"cottages_slate.png", cottages.textures.roof_sides,
	         "cottages_slate.png", "cottages_slate.png",
	         cottages.textures.roof_sides, "cottages_slate.png"},
	paramtype2 = "facedir",
	groups = {cracky = 2, stone = 1},
	sounds = cottages.sounds.stone,
	is_ground_content = false,
})
