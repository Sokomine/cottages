local has = cottages.has

local sounds = {}

if has.default then
	sounds.wood = default.node_sound_wood_defaults()
	sounds.dirt = default.node_sound_dirt_defaults()
	sounds.stone = default.node_sound_stone_defaults()
	sounds.leaves = default.node_sound_leaves_defaults()
	sounds.metal = default.node_sound_metal_defaults()

	sounds.water_empty = "default_water_footstep"
	sounds.water_fill = "default_water_footstep"

	sounds.tool_breaks = "default_tool_breaks"

	sounds.use_thresher = "default_grass_footstep"
	sounds.use_quern = "default_gravel_footstep"
end

if has.env_sounds then
	sounds.water_empty = sounds.water_empty or "env_sounds_water"
	sounds.water_fill = "env_sounds_water"
	sounds.lava_fill = "env_sounds_lava"
	sounds.lava_empty = "env_sounds_lava"
end

cottages.sounds = sounds
