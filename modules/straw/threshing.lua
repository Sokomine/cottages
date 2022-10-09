local straw = cottages.straw

local S = cottages.S
local F = minetest.formspec_escape
local FS = function(...) return F(S(...)) end

local get_safe_short_description = futil.get_safe_short_description

local has_stamina = cottages.has.stamina
local stamina_use = cottages.settings.straw.threshing_stamina
local threshing_min_per_punch = cottages.settings.straw.threshing_min_per_punch
local threshing_max_per_punch = cottages.settings.straw.threshing_max_per_punch

function straw.get_threshing_fs_parts()
	return {
		("size[8,8]"),
		("image[3,1;1,1;%s]"):format(F(cottages.textures.stick)),
		("image[0,1;1,1;%s]"):format(F(cottages.textures.wheat)),
		("label[1,0.5;%s]"):format(FS("Input:")),
		("label[3,0.0;%s]"):format(FS("Output:")),
		("label[0,0;%s]"):format(FS("Threshing Floor")),
		("label[0,2.5;%s]"):format(FS("Punch threshing floor with a stick")),
		("label[0,3.0;%s]"):format(FS("to get straw and seeds from wheat.")),
		("list[context;harvest;1,1;2,1;]"),
		("list[context;straw;4,0;2,2;]"),
		("list[context;seeds;4,2;2,2;]"),
		("list[current_player;main;0,4;8,4;]"),
		("listring[current_player;main]"),
		("listring[context;harvest]"),
		("listring[current_player;main]"),
		("listring[context;straw]"),
		("listring[current_player;main]"),
		("listring[context;seeds]"),
	}
end

function straw.get_threshing_info(pos)
	local meta = minetest.get_meta(pos)

	if meta:get_int("used") == 0 then
		return S("threshing floor")

	else
		local inv = meta:get_inventory()
		local input1 = inv:get_stack("harvest", 1)
		local input2 = inv:get_stack("harvest", 2)
		local count = input1:get_count() + input2:get_count()

		if count > 0 then
			local input_description
			if input1:is_empty() then
				input_description = get_safe_short_description(input2)

			else
				input_description = get_safe_short_description(input1)
			end
			return S("threshing floor, @1 @2 remaining", count, input_description)

		else
			return S("threshing floor, none remaining")
		end
	end
end

local function get_threshing_results(input)
	local item = input:get_name()
	local output_def = straw.registered_threshing_crafts[item]
	if type(output_def) == "string" then
		return {ItemStack(output_def)}

	elseif type(output_def) == "table" and #output_def > 0 then
		local outputs = {}
		for _, output_item in ipairs(output_def) do
			if type(output_item) == "string" then
				table.insert(outputs, ItemStack(output_item))

			elseif type(output_item) == "table" then
				local chance
				output_item, chance = unpack(output_item)
				if math.random() <= chance then
					table.insert(outputs, ItemStack(output_item))
				end
			end
		end

		return outputs

	elseif type(output_def) == "function" then
		return output_def()
	end
end

function straw.use_threshing(pos, player)
	-- only punching with a normal stick is supposed to work
	local wielded = player:get_wielded_item()
	if minetest.get_item_group(wielded:get_name(), "stick") == 0 then
		return
	end

	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	local input1 = inv:get_stack("harvest", 1)
	local input2 = inv:get_stack("harvest", 2)

	local input_count = input1:get_count() + input2:get_count()

	if input_count == 0 then
		return
	end

	local number_to_process = math.min(math.random(threshing_min_per_punch, threshing_max_per_punch), input_count)

	for _ = 1, number_to_process do
		local results
		if input1:is_empty() then
			results = get_threshing_results(input2:take_item(1))
		else
			results = get_threshing_results(input1:take_item(1))
		end

		for _, result in ipairs(results) do
			local leftovers = inv:add_item("straw", result)
			if not leftovers:is_empty() then
				leftovers = inv:add_item("seeds", result)
				if not leftovers:is_empty() then
					minetest.add_item(pos, leftovers)
				end
			end
		end
	end

	inv:set_stack("harvest", 1, input1)
	inv:set_stack("harvest", 2, input2)

	local particle_pos = vector.subtract(pos, vector.new(0, 0.25, 0))
	minetest.add_particlespawner({
		amount = 10,
		time = 0.1,
		collisiondetection = true,
		texture = cottages.textures.straw,
		minsize = 1,
		maxsize = 1,
		minexptime = 0.2,
		maxexptime = 0.4,
		minpos = vector.subtract(particle_pos, 0.1),
		maxpos = vector.add(particle_pos, 0.1),
		minvel = vector.new(-3, 1, -3),
		maxvel = vector.new(3, 2, 3),
		minacc = vector.new(0, -10, 0),
		maxacc = vector.new(0, -10, 0),
	})

	minetest.add_particlespawner({
		amount = 10,
		time = 0.1,
		collisiondetection = true,
		texture = cottages.textures.wheat_seed,
		minsize = 1,
		maxsize = 1,
		minexptime = 0.2,
		maxexptime = 0.4,
		minpos = vector.subtract(particle_pos, 0.1),
		maxpos = vector.add(particle_pos, 0.1),
		minvel = vector.new(-3, 0.5, -3),
		maxvel = vector.new(3, 1, 3),
		minacc = vector.new(0, -10, 0),
		maxacc = vector.new(0, -10, 0),
	})

	minetest.sound_play(
		{name = cottages.sounds.use_thresher},
		{pos = particle_pos, gain = 1, pitch = 0.5},
		true
	)

	if has_stamina then
		stamina.exhaust_player(player, stamina_use, "cottages:quern")
	end

	return true
end

cottages.api.register_machine("cottages:threshing_floor", {
	description = S("threshing floor\npunch with a stick to operate"),
	short_description = S("threshing floor"),
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.50, -0.5, -0.50, 0.50, -0.40, 0.50},

			{-0.50, -0.4, -0.50, -0.45, -0.20, 0.50},
			{0.45, -0.4, -0.50, 0.50, -0.20, 0.50},

			{-0.45, -0.4, -0.50, 0.45, -0.20, -0.45},
			{-0.45, -0.4, 0.45, 0.45, -0.20, 0.50},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.50, -0.5, -0.50, 0.50, -0.20, 0.50},
		}
	},
	tiles = {
		"cottages_junglewood.png^farming_wheat.png",
		"cottages_junglewood.png",
		"cottages_junglewood.png^" .. cottages.textures.stick
	},
	groups = {cracky = 2, choppy = 2},
	sounds = cottages.sounds.wood,
	is_ground_content = false,

	inv_info = {
		harvest = 2,
		straw = 4,
		seeds = 4,
	},

	update_infotext = straw.update_threshing_infotext,
	update_formspec = straw.update_threshing_formspec,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return 0
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "straw" or listname == "seeds" then
			return 0
		end

		if not cottages.straw.registered_threshing_crafts[stack:get_name()] then
			return 0
		end

		return stack:get_count()
	end,

	use = straw.use_threshing,
	get_fs_parts = straw.get_threshing_fs_parts,
	get_info = straw.get_threshing_info,
})
