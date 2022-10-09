local ci = cottages.craftitems
local s = cottages.sounds

local settings = cottages.settings.water

local api = cottages.water

local sound_handles_by_pos = {}
local particlespawner_ids_by_pos = {}

function api.add_filling_effects(pos)
	local entity_pos = vector.add(pos, vector.new(0, 1/4, 0))

	local spos = minetest.pos_to_string(pos)

	local previous_handle = sound_handles_by_pos[spos]
	if previous_handle then
		minetest.sound_stop(previous_handle)
	end
	sound_handles_by_pos[spos] = minetest.sound_play(
		{name = s.water_fill},
		{pos = entity_pos, loop = true, gain = 0.5, pitch = 2.0}
	)

	local previous_id = particlespawner_ids_by_pos[spos]
	if previous_id then
		minetest.delete_particlespawner(previous_id)
	end
	local particle_pos = vector.add(pos, vector.new(0, 1/2 + 1/16, 0))
	particlespawner_ids_by_pos[spos] = minetest.add_particlespawner({
		amount = 10,
		time = 0,
		collisiondetection = false,
		texture = "bubble.png",
		minsize = 1,
		maxsize = 1,
		minexptime = 0.4,
		maxexptime = 0.4,
		minpos = particle_pos,
		maxpos = particle_pos,
		minvel = vector.new(-0.1, -0.2, -0.01),
		maxvel = vector.new(0.1, -0.2, 0.1),
		minacc = vector.new(0, -2, 0),
		maxacc = vector.new(0, -2, 0),
	})
end

function api.fill_bucket(pos)
	local entity_pos = vector.add(pos, vector.new(0, 1/4, 0))

	for _, obj in ipairs(minetest.get_objects_inside_radius(entity_pos, .1)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "cottages:bucket_entity" then
			local props = obj:get_properties()
			props.wield_item = ci.bucket_filled
			obj:set_properties(props)
		end
	end

	local meta = minetest.get_meta(pos)
	meta:set_string("bucket", ci.bucket_filled)

	local spos = minetest.pos_to_string(pos)
	local handle = sound_handles_by_pos[spos]
	if handle then
		minetest.sound_stop(handle)
	end
	local id = particlespawner_ids_by_pos[spos]
	if id then
		minetest.delete_particlespawner(id)
	end
end

function api.initialize_entity(pos)
	local meta = minetest.get_meta(pos)
	local bucket = meta:get("bucket")
	if bucket then
		local entity_pos = vector.add(pos, vector.new(0, 1/4, 0))
		local obj = minetest.add_entity(entity_pos, "cottages:bucket_entity")
		local props = obj:get_properties()
		props.wield_item = bucket
		obj:set_properties(props)

		if bucket == ci.bucket then
			local timer = minetest.get_node_timer(pos)
			if not timer:is_started() then
				timer:start(settings.well_fill_time)
			end
			api.add_filling_effects(pos)
		end
	end
end
