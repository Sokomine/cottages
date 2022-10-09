local straw = cottages.straw

local S = cottages.S
local F = minetest.formspec_escape
local FS = function(...) return F(S(...)) end

local get_safe_short_description = futil.get_safe_short_description

local has_stamina = cottages.has.stamina
local stamina_use = cottages.settings.straw.quern_stamina
local quern_min_per_turn = cottages.settings.straw.quern_min_per_turn
local quern_max_per_turn = cottages.settings.straw.quern_max_per_turn


function straw.get_quern_fs_parts()
	return {
		("size[8,8]"),
		("image[0,1;1,1;%s]"):format(F(cottages.textures.wheat_seed)),
		("label[0,0.5;%s]"):format(FS("Input:")),
		("label[3,0.5;%s]"):format(FS("Output:")),
		("label[0,-0.3;%s]"):format(FS("Quern")),
		("label[0,2.5;%s]"):format(FS("Punch this hand-driven quern")),
		("label[0,3.0;%s]"):format(FS("to grind suitable items.")),
		("list[context;seeds;1,1;1,1;]"),
		("list[context;flour;4,1;2,2;]"),
		("list[current_player;main;0,4;8,4;]"),
		("listring[current_player;main]"),
		("listring[context;seeds]"),
		("listring[current_player;main]"),
		("listring[context;flour]"),
	}
end

function straw.get_quern_info(pos)
	local meta = minetest.get_meta(pos)

	if meta:get_int("used") == 0 then
		return S("quern, powered by punching")

	else
		local inv = meta:get_inventory()
		local input = inv:get_stack("seeds", 1)
		local count = input:get_count()

		if count > 0 then
			local input_description = get_safe_short_description(input)
			return S("quern, @1 @2 remaining", count, input_description)

		else
			return S("quern, none remaining")
		end
	end
end

local function get_quern_results(input)
	local item = input:get_name()
	local output_def = straw.registered_quern_crafts[item]
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

function straw.use_quern(pos, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local input = inv:get_stack("seeds", 1)

	if input:is_empty() then
		return
	end

	local input_count = input:get_count()
	local number_to_process = math.min(math.random(quern_min_per_turn, quern_max_per_turn), input_count)

	local above = vector.add(pos, vector.new(0, 1, 0))
	for _ = 1, number_to_process do
		local results = get_quern_results(input:take_item(1))

		for _, result in ipairs(results) do
			local leftovers = inv:add_item("flour", result)
			if not leftovers:is_empty() then
				minetest.add_item(above, leftovers)
			end
		end
	end

	inv:set_stack("seeds", 1, input)

	local node = minetest.get_node(pos)
	node.param2 = (node.param2 + 1) % 4
	minetest.swap_node(pos, node)

	minetest.add_particlespawner({
		amount = 30,
		time = 0.1,
		collisiondetection = true,
		texture = cottages.textures.dust,
		minsize = 1,
		maxsize = 1,
		minexptime = 0.4,
		maxexptime = 0.8,
		minpos = vector.subtract(pos, 0.1),
		maxpos = vector.add(pos, vector.new(0.1, 0, 0.1)),
		minvel = vector.new(-1, -0.5, -1),
		maxvel = vector.new(1, 0.5, 1),
		minacc = vector.new(0, -3, 0),
		maxacc = vector.new(0, -3, 0),
	})

	minetest.sound_play(
		{name = cottages.sounds.use_quern},
		{pos = pos, gain = 1, pitch = 0.25},
		true
	)

	if has_stamina then
		stamina.exhaust_player(player, stamina_use, "cottages:quern")
	end

	return true
end

cottages.api.register_machine("cottages:quern", {
	description = S("quern-stone\npunch to operate"),
	short_description = S("quern-stone"),
	drawtype = "mesh",
	mesh = "cottages_quern.obj",
	tiles = {"cottages_stone.png"},
	selection_box = {type = "fixed", fixed = {{-0.50, -0.5, -0.50, 0.50, 0.25, 0.50}}},
	groups = {cracky = 2},
	sounds = cottages.sounds.stone,

	inv_info = {
		seeds = 1,
		flour = 4,
	},

	update_infotext = straw.update_quern_infotext,
	update_formspec = straw.update_quern_formspec,

	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		return 0
	end,

	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "flour" then
			return 0
		end

		if listname == "seeds" and not cottages.straw.registered_quern_crafts[stack:get_name()] then
			return 0
		end

		return stack:get_count()
	end,

	use = straw.use_quern,
	get_fs_parts = straw.get_quern_fs_parts,
	get_info = straw.get_quern_info,
})
