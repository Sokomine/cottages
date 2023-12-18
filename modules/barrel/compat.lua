local api = cottages.barrel

if cottages.has.bucket and cottages.has.default then
	local S = minetest.get_translator("default")

	if minetest.registered_items["bucket:bucket_water"] then
		api.register_barrel_liquid({
			liquid = "default:water_source",
			liquid_name = S("Water"),
			liquid_texture = "default_water.png",
			liquid_input_sound = cottages.sounds.water_empty,
			liquid_output_sound = cottages.sounds.water_fill,
			bucket_empty = "bucket:bucket_empty",
			bucket_full = "bucket:bucket_water",
		})
	end

	if minetest.registered_items["bucket:bucket_river_water"] then
		api.register_barrel_liquid({
			liquid = "default:river_water_source",
			liquid_name = S("River Water"),
			liquid_texture = "default_river_water.png",
			liquid_input_sound = cottages.sounds.water_empty,
			liquid_output_sound = cottages.sounds.water_fill,
			bucket_empty = "bucket:bucket_empty",
			bucket_full = "bucket:bucket_river_water",
		})
	end

	if minetest.registered_items["bucket:bucket_lava"] then
		api.register_barrel_liquid({
			liquid = "default:lava_source",
			liquid_name = S("Lava"),
			liquid_input_sound = cottages.sounds.lava_empty,
			liquid_output_sound = cottages.sounds.lava_fill,
			liquid_texture = "default_lava.png",
			bucket_empty = "bucket:bucket_empty",
			bucket_full = "bucket:bucket_lava",
		})
	end
end
