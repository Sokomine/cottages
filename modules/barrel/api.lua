local max_liquid_amount = cottages.settings.barrel.max_liquid_amount

local api = cottages.barrel

api.bucket_empty_by_bucket_full = {}
api.bucket_full_by_empty_and_liquid = {}
api.liquid_by_bucket_full = {}

api.name_by_liquid = {}
api.texture_by_liquid = {}

api.input_sound_by_liquid = {}
api.output_sound_by_liquid = {}

function api.get_barrel_liquid(pos)
	local meta = minetest.get_meta(pos)
	return meta:get("liquid")
end

function api.set_barrel_liquid(pos, liquid)
	local meta = minetest.get_meta(pos)
	meta:set_string("liquid", liquid)
end

function api.get_liquid_amount(pos)
	local meta = minetest.get_meta(pos)
	return meta:get_int("amount")
end

function api.increase_liquid_amount(pos)
	local meta = minetest.get_meta(pos)
	meta:set_int("amount", meta:get_int("amount") + 1)
end

function api.decrease_liquid_amount(pos)
	local meta = minetest.get_meta(pos)
	local amount = meta:get_int("amount") - 1
	meta:set_int("amount", amount)
	if amount == 0 then
		api.set_barrel_liquid(pos, "")
	end
end

local function empty_and_liquid(bucket_empty, liquid)
	return table.concat({bucket_empty, liquid}, "::")
end

function api.register_barrel_liquid(def)
	api.liquid_by_bucket_full[def.bucket_full] = def.liquid
	api.bucket_empty_by_bucket_full[def.bucket_full] = def.bucket_empty

	api.bucket_full_by_empty_and_liquid[empty_and_liquid(def.bucket_empty, def.liquid)] = def.bucket_full

	api.name_by_liquid[def.liquid] = def.liquid_name
	api.texture_by_liquid[def.liquid] = def.liquid_texture
	api.input_sound_by_liquid[def.liquid] = def.liquid_input_sound
	api.output_sound_by_liquid[def.liquid] = def.liquid_output_sound
end

function api.get_bucket_liquid(bucket_full)
	return api.liquid_by_bucket_full[bucket_full]
end

function api.get_bucket_empty(liquid)
	return api.bucket_empty_by_liquid[liquid]
end

function api.get_bucket_empty(bucket_full)
	return api.bucket_empty_by_bucket_full[bucket_full]
end

function api.get_bucket_full(bucket_empty, liquid)
	return api.bucket_full_by_empty_and_liquid[empty_and_liquid(bucket_empty, liquid)]
end

function api.can_fill(pos, bucket_empty)
	local liquid = api.get_barrel_liquid(pos)
	return liquid and api.get_bucket_full(bucket_empty, liquid)
end

function api.can_drain(pos, bucket_full)
	local barrel_liquid = api.get_barrel_liquid(pos)
	local liquid_amount = api.get_liquid_amount(pos)
	local bucket_liquid = api.get_bucket_liquid(bucket_full)

	if (not bucket_liquid) or liquid_amount >= max_liquid_amount then
		return false
	end

	return bucket_liquid and ((not barrel_liquid) or barrel_liquid == bucket_liquid)
end

function api.add_barrel_liquid(pos, bucket_full)
	local liquid = api.get_bucket_liquid(bucket_full)

	if not api.get_barrel_liquid(pos) then
		api.set_barrel_liquid(pos, liquid)
	end

	api.increase_liquid_amount(pos)

	minetest.sound_play(
		{name = api.input_sound_by_liquid[liquid]},
		{pos = pos, loop = false, gain = 0.5, pitch = 2.0}
	)

	return api.get_bucket_empty(bucket_full)
end

function api.drain_barrel_liquid(pos, bucket_empty)
	local liquid = api.get_barrel_liquid(pos)

	api.decrease_liquid_amount(pos)

	minetest.sound_play(
		{name = api.output_sound_by_liquid[liquid]},
		{pos = pos, loop = false, gain = 0.5, pitch = 2.0}
	)

	return api.get_bucket_full(bucket_empty, liquid)
end
