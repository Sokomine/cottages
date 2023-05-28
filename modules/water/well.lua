local f = string.format
local F = minetest.formspec_escape
local S = cottages.S
local FS = function(...)
	return F(S(...))
end

local s = cottages.sounds
local t = cottages.textures
local water = cottages.water
local ci = cottages.craftitems

local settings = cottages.settings.water

local sound_handles_by_pos = {}
local particlespawner_ids_by_pos = {}

water.registered_fillables = {}
water.registered_filleds = {}

function water.register_fillable(empty, filled, fill_time)
	assert(minetest.registered_items[empty], f("item %s does not exist", empty))
	assert(minetest.registered_items[filled], f("item %s does not exist", filled))
	assert(not fill_time or fill_time >= 0, f("fill time must be greater than or equal to 0"))
	local def = {
		empty = empty,
		filled = filled,
		fill_time = fill_time or settings.well_fill_time,
	}
	water.register_fillable[empty] = def
	water.registered_filleds[filled] = def
end

function water.get_well_fs_parts(pos)
	return {
		"size[8,9]",
		("label[3.0,0.0;%s]"):format(FS("Tree trunk well")),
		("label[0,0.7;%s]"):format(FS("Punch the well while wielding an empty bucket.")),
		("label[0,1.0;%s]"):format(FS("Your bucket will slowly be filled with river water.")),
		("label[0,1.3;%s]"):format(FS("Punch again to get the bucket back when it is full.")),
		("label[0,1.9;%s]"):format(FS("Punch well with full water bucket in order to empty bucket.")),
		("label[1.0,2.9;%s]"):format(FS("Internal bucket storage (passive storage only):")),
		("item_image[0,2.8;1.0,1.0;%s]"):format(F(ci.bucket)),
		("item_image[0,3.8;1.0,1.0;%s]"):format(F(ci.bucket_filled)),
		"list[context;main;1,3.3;8,1;]",
		"list[current_player;main;0,4.85;8,4;]",
		"listring[]",
	}
end

function water.get_well_info(pos)
	return S("Tree trunk well")
end

if bucket.fork == "flux" then
	-- bucket redo
	function water.use_well(pos, puncher)
		if not minetest.is_player(puncher) then
			return
		end

		local wielded = puncher:get_wielded_item()
		local wielded_name = wielded:get_name()
		if minetest.get_item_group(wielded_name, "bucket") == 0 then
			return
		end

		if not ci.river_water then
			return
		end

		local pinv = puncher:get_inventory()
		pinv:add_item("main", ci.river_water)

		minetest.sound_play(
			{ name = "cottages_fill_glass" },
			{ pos = pos, loop = false, gain = 0.5, pitch = 1.0 },
			true
		)
	end
else
	function water.use_well(pos, puncher)
		local spos = minetest.pos_to_string(pos)
		local player_name = puncher:get_player_name()
		local node_meta = minetest.get_meta(pos)

		local pinv = puncher:get_inventory()
		local current_bucket = node_meta:get("bucket")

		local entity_pos = vector.add(pos, vector.new(0, 1 / 4, 0))

		if not current_bucket then
			local wielded = puncher:get_wielded_item()
			local wielded_name = wielded:get_name()
			local fillable = water.registered_fillables[wielded_name]
			local filled = water.registered_filleds[wielded_name]
			if fillable then
				if fillable.fill_time == 0 then
					local removed = pinv:remove_item("main", wielded_name)
					if removed:is_empty() then
						cottages.log(
							"error",
							"well @ %s: failed to remove %s's wielded item %s",
							spos,
							player_name,
							removed:to_string()
						)
					else
						local remainder = pinv:add_item("main", fillable.filled)
						if not remainder:is_empty() then
							if not minetest.add_item(pos, remainder) then
								cottages.log(
									"error",
									"well @ %s: somehow lost %s's %s",
									spos,
									player_name,
									remainder:to_string()
								)
							end
						end

						minetest.sound_play(
							{ name = "cottages_fill_glass" },
							{ pos = entity_pos, loop = false, gain = 0.5, pitch = 2.0 },
							true
						)
					end
				else
					local removed = pinv:remove_item("main", wielded_name)
					local remainder = node_meta:set_string("bucket", removed)
					if not remainder:is_empty() then
						if not minetest.add_item(pos, remainder) then
							cottages.log(
								"error",
								"well @ %s: somehow lost %s's %s",
								spos,
								player_name,
								remainder:to_string()
							)
						end
					end

					water.initialize_entity(pos)

					local timer = minetest.get_node_timer(pos)
					timer:start(fillable.fill_time)

					water.add_filling_effects(pos)
				end
			elseif filled then
				-- empty a bucket
				-- TODO error checking and logging
				pinv:remove_item("main", filled.filled)
				pinv:add_item("main", filled.empty)

				minetest.sound_play({ name = s.water_empty }, { pos = entity_pos, gain = 0.5, pitch = 2.0 }, true)
			end
		elseif current_bucket then
			minetest.chat_send_player(player_name, S("Please wait until your bucket has been filled."))
			local timer = minetest.get_node_timer(pos)
			if not timer:is_started() then
				timer:start(settings.well_fill_time)
				water.add_filling_effects(pos)
			end
		elseif current_bucket == ci.bucket_filled then
			node_meta:set_string("bucket", "")

			for _, obj in ipairs(minetest.get_objects_inside_radius(entity_pos, 0.1)) do
				local ent = obj:get_luaentity()
				if ent and ent.name == "cottages:bucket_entity" then
					obj:remove()
				end
			end

			pinv:add_item("main", ci.bucket_filled)
		end
	end
end

function water.add_filling_effects(pos)
	local entity_pos = vector.add(pos, vector.new(0, 1 / 4, 0))

	local spos = minetest.hash_node_position(pos)

	local previous_handle = sound_handles_by_pos[spos]
	if previous_handle then
		minetest.sound_stop(previous_handle)
	end
	sound_handles_by_pos[spos] = minetest.sound_play(
		{ name = s.water_fill },
		{ pos = entity_pos, loop = true, gain = 0.5, pitch = 2.0 }
	)

	local previous_id = particlespawner_ids_by_pos[spos]
	if previous_id then
		minetest.delete_particlespawner(previous_id)
	end
	local particle_pos = vector.add(pos, vector.new(0, 1 / 2 + 1 / 16, 0))
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

function water.fill_bucket(pos)
	local entity_pos = vector.add(pos, vector.new(0, 1 / 4, 0))

	for _, obj in ipairs(minetest.get_objects_inside_radius(entity_pos, 0.1)) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "cottages:bucket_entity" then
			obj:set_properties({ wield_item = ci.bucket_filled })
		end
	end

	local meta = minetest.get_meta(pos)
	meta:set_string("bucket", ci.bucket_filled)

	local spos = minetest.hash_node_position(pos)
	local handle = sound_handles_by_pos[spos]
	if handle then
		minetest.sound_stop(handle)
	end
	local id = particlespawner_ids_by_pos[spos]
	if id then
		minetest.delete_particlespawner(id)
	end
end

function water.initialize_entity(pos)
	local meta = minetest.get_meta(pos)
	local bucket = meta:get("bucket")
	if bucket then
		local entity_pos = vector.add(pos, vector.new(0, 1 / 4, 0))
		minetest.add_entity(entity_pos, "cottages:bucket_entity", bucket)

		if bucket == ci.bucket then
			local timer = minetest.get_node_timer(pos)
			if not timer:is_started() then
				timer:start(settings.well_fill_time)
			end
			water.add_filling_effects(pos)
		end
	end
end

cottages.api.register_machine("cottages:water_gen", {
	description = S("Tree Trunk Well"),
	tiles = { t.tree_top, ("%s^[transformR90"):format(t.tree), ("%s^[transformR90"):format(t.tree) },
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",

	is_ground_content = false,
	groups = { choppy = 2, cracky = 1, flammable = 2 },
	sounds = cottages.sounds.wood,

	inv_info = {
		main = 6,
	},

	node_box = {
		type = "fixed",
		fixed = {
			-- floor of water bassin
			{ -0.5, -0.5 + (3 / 16), -0.5, 0.5, -0.5 + (4 / 16), 0.5 },
			-- walls
			{ -0.5, -0.5 + (3 / 16), -0.5, 0.5, (4 / 16), -0.5 + (2 / 16) },
			{ -0.5, -0.5 + (3 / 16), -0.5, -0.5 + (2 / 16), (4 / 16), 0.5 },
			{ 0.5, -0.5 + (3 / 16), 0.5, 0.5 - (2 / 16), (4 / 16), -0.5 },
			{ 0.5, -0.5 + (3 / 16), 0.5, -0.5 + (2 / 16), (4 / 16), 0.5 - (2 / 16) },
			-- feet
			{ -0.5 + (3 / 16), -0.5, -0.5 + (3 / 16), -0.5 + (6 / 16), -0.5 + (3 / 16), 0.5 - (3 / 16) },
			{ 0.5 - (3 / 16), -0.5, -0.5 + (3 / 16), 0.5 - (6 / 16), -0.5 + (3 / 16), 0.5 - (3 / 16) },
			-- real pump
			{ 0.5 - (4 / 16), -0.5, -(2 / 16), 0.5, 0.5 + (4 / 16), (2 / 16) },
			-- water pipe inside wooden stem
			{ 0.5 - (8 / 16), 0.5 + (1 / 16), -(1 / 16), 0.5, 0.5 + (3 / 16), (1 / 16) },
			-- where the water comes out
			{ 0.5 - (15 / 32), 0.5, -(1 / 32), 0.5 - (12 / 32), 0.5 + (1 / 16), (1 / 32) },
		},
	},
	selection_box = {
		type = "fixed",
		fixed = { -0.5, -0.5, -0.5, 0.5, 0.5 + (4 / 16), 0.5 },
	},

	get_fs_parts = water.get_well_fs_parts,
	get_info = water.get_well_info,

	can_dig = function(pos, player)
		local meta = minetest.get_meta(pos)
		return not meta:get("bucket")
	end,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return 0
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local sname = stack:get_name()
		if sname ~= ci.bucket and sname ~= ci.bucket_filled then
			return 0
		end

		return stack:get_count()
	end,

	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		return stack:get_count()
	end,

	on_timer = function(pos, elapsed)
		water.fill_bucket(pos)
	end,

	use = water.use_well,

	on_destruct = function(pos)
		local entity_pos = vector.add(pos, vector.new(0, 1 / 4, 0))

		for _, obj in ipairs(minetest.get_objects_inside_radius(entity_pos, 0.1)) do
			local ent = obj:get_luaentity()
			if ent and ent.name == "cottages:bucket_entity" then
				minetest.add_item(pos, obj:get_properties().wield_item)
				obj:remove()
			end
		end

		local spos = minetest.hash_node_position(pos)

		local handle = sound_handles_by_pos[spos]
		if handle then
			minetest.sound_stop(handle)
		end

		local id = particlespawner_ids_by_pos[spos]
		if id then
			minetest.delete_particlespawner(id)
		end
	end,
})

if cottages.has.node_entity_queue then
	node_entity_queue.api.register_node_entity_loader("cottages:water_gen", water.initialize_entity)
else
	minetest.register_lbm({
		name = "cottages:add_well_entity",
		label = "Initialize entity to cottages well",
		nodenames = { "cottages:water_gen" },
		run_at_every_load = true,
		action = function(pos, node)
			water.initialize_entity(pos)
		end,
	})
end
