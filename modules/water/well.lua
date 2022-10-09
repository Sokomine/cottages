local F = minetest.formspec_escape
local S = cottages.S
local FS = function(...) return F(S(...)) end

local s = cottages.sounds
local t = cottages.textures
local water = cottages.water
local ci = cottages.craftitems

local well_fill_time = cottages.settings.water.well_fill_time

function water.get_well_fs_parts(pos)
	return {
		("size[8,9]"),
		("label[3.0,0.0;%s]"):format(FS("Tree trunk well")),
		("label[0,0.7;%s]"):format(FS("Punch the well while wielding an empty bucket.")),
		("label[0,1.0;%s]"):format(FS("Your bucket will slowly be filled with river water.")),
		("label[0,1.3;%s]"):format(FS("Punch again to get the bucket back when it is full.")),
		("label[0,1.9;%s]"):format(FS("Punch well with full water bucket in order to empty bucket.")),
		("label[1.0,2.9;%s]"):format(FS("Internal bucket storage (passive storage only):")),
		("item_image[0,2.8;1.0,1.0;%s]"):format(F(ci.bucket)),
		("item_image[0,3.8;1.0,1.0;%s]"):format(F(ci.bucket_filled)),
		("list[context;main;1,3.3;8,1;]"),
		("list[current_player;main;0,4.85;8,4;]"),
		("listring[]"),
	}
end

function water.get_well_info(pos)
	return S("Tree trunk well")
end

function water.use_well(pos, puncher)
	local player_name = puncher:get_player_name()
	local meta = minetest.get_meta(pos)

	local pinv = puncher:get_inventory()
	local bucket = meta:get("bucket")

	local entity_pos = vector.add(pos, vector.new(0, 1/4, 0))

	if not bucket then
		local wielded = puncher:get_wielded_item()
		local wielded_name = wielded:get_name()
		if wielded_name == ci.bucket then
			meta:set_string("bucket", wielded_name)

			minetest.add_entity(entity_pos, "cottages:bucket_entity")

			pinv:remove_item("main", "bucket:bucket_empty")

			local timer = minetest.get_node_timer(pos)
			timer:start(well_fill_time)

			water.add_filling_effects(pos)

		elseif wielded_name == ci.bucket_filled then
			-- empty a bucket
			pinv:remove_item("main", ci.bucket_filled)
			pinv:add_item("main", ci.bucket)

			minetest.sound_play(
				{name = s.water_empty},
				{pos = entity_pos, gain = 0.5, pitch = 2.0},
				true
			)
		end

	elseif bucket == ci.bucket then
		minetest.chat_send_player(player_name, S("Please wait until your bucket has been filled."))
		local timer = minetest.get_node_timer(pos)
		if not timer:is_started() then
			timer:start(well_fill_time)
			water.add_filling_effects(pos)
		end

	elseif bucket == ci.bucket_filled then
		meta:set_string("bucket", "")

		for _, obj in ipairs(minetest.get_objects_inside_radius(entity_pos, .1)) do
			local ent = obj:get_luaentity()
			if ent and ent.name == "cottages:bucket_entity" then
				obj:remove()
			end
		end

		pinv:add_item("main", ci.bucket_filled)
	end
end


cottages.api.register_machine("cottages:water_gen", {
	description = S("Tree Trunk Well"),
	tiles = {t.tree_top, ("%s^[transformR90"):format(t.tree), ("%s^[transformR90"):format(t.tree)},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",

	is_ground_content = false,
	groups = {choppy = 2, cracky = 1, flammable = 2},
	sounds = cottages.sounds.wood,

	inv_info = {
		main = 6,
	},

	node_box = {
		type = "fixed",
		fixed = {
			-- floor of water bassin
			{-0.5, -0.5 + (3 / 16), -0.5, 0.5, -0.5 + (4 / 16), 0.5},
			-- walls
			{-0.5, -0.5 + (3 / 16), -0.5, 0.5, (4 / 16), -0.5 + (2 / 16)},
			{-0.5, -0.5 + (3 / 16), -0.5, -0.5 + (2 / 16), (4 / 16), 0.5},
			{0.5, -0.5 + (3 / 16), 0.5, 0.5 - (2 / 16), (4 / 16), -0.5},
			{0.5, -0.5 + (3 / 16), 0.5, -0.5 + (2 / 16), (4 / 16), 0.5 - (2 / 16)},
			-- feet
			{-0.5 + (3 / 16), -0.5, -0.5 + (3 / 16), -0.5 + (6 / 16), -0.5 + (3 / 16), 0.5 - (3 / 16)},
			{0.5 - (3 / 16), -0.5, -0.5 + (3 / 16), 0.5 - (6 / 16), -0.5 + (3 / 16), 0.5 - (3 / 16)},
			-- real pump
			{0.5 - (4 / 16), -0.5, -(2 / 16), 0.5, 0.5 + (4 / 16), (2 / 16)},
			-- water pipe inside wooden stem
			{0.5 - (8 / 16), 0.5 + (1 / 16), -(1 / 16), 0.5, 0.5 + (3 / 16), (1 / 16)},
			-- where the water comes out
			{0.5 - (15 / 32), 0.5, -(1 / 32), 0.5 - (12 / 32), 0.5 + (1 / 16), (1 / 32)},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, 0.5 + (4 / 16), 0.5}
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
})

minetest.register_lbm({
	name = "cottages:add_well_entity",
	label = "Initialize entity to cottages well",
	nodenames = {"cottages:water_gen"},
	run_at_every_load = true,
	action = function(pos, node)
		water.initialize_entity(pos)
	end
})
