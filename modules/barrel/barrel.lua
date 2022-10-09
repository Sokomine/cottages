local S = cottages.S
local F = minetest.formspec_escape
local FS = function(...) return F(S(...)) end

local max_liquid_amount = cottages.settings.barrel.max_liquid_amount

local barrel = cottages.barrel

function barrel.get_barrel_info(pos)
	local liquid = barrel.get_barrel_liquid(pos)
	if liquid then
		return ("%s (%i/%i)"):format(
			barrel.name_by_liquid[liquid],
			barrel.get_liquid_amount(pos),
			max_liquid_amount
		)

	else
		return S("Empty")
	end
end

function barrel.get_barrel_fs_parts(pos)
	local parts = {
		("size[8,9]"),
		("label[0,0.0;%s]"):format(FS("barrel (liquid storage)")),
		("label[3,0;%s]"):format(FS("fill:")),
		("list[context;input;3,0.5;1,1;]"),
		("label[5,3.3;%s]"):format(FS("drain:")),
		("list[context;output;5,3.8;1,1;]"),
		("list[current_player;main;0,5;8,4;]"),
		("listring[context;output]"),
		("listring[current_player;main]"),
		("listring[context;input]"),
		("listring[current_player;main]"),
	}

	local liquid = barrel.get_barrel_liquid(pos)
	local liquid_amount = barrel.get_liquid_amount(pos)

	if liquid then
		local liquid_texture = barrel.texture_by_liquid[liquid]
		table.insert(parts, ("image[2.6,2;2,3;%s^[resize:99x99^[lowpart:%s:%s]"):format(
			F(cottages.textures.furniture),
			math.floor(99 * liquid_amount / max_liquid_amount),
			F(liquid_texture .. futil.escape_texture("^[resize:99x99"))
		))
		table.insert(parts, ("tooltip[2.6,2;2,3;%s]"):format(
			F(("%s (%i/%i)"):format(
				barrel.name_by_liquid[liquid],
				barrel.get_liquid_amount(pos),
				max_liquid_amount
			)))
		)

	else
		table.insert(parts, ("image[2.6,2;2,3;%s^[resize:99x99^[lowpart:%s:%s]"):format(
			F(cottages.textures.furniture),
			0,
			F(cottages.textures.furniture .. futil.escape_texture("^[resize:99x99"))
		))
	end

	return parts
end


function barrel.can_dig(pos, player)
	return barrel.get_liquid_amount(pos) == 0
end

function barrel.allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local to_stack = inv:get_stack(to_list, to_index)

	if not to_stack:is_empty() then
		return 0
	end

	local from_stack = inv:get_stack(from_list, from_index)
	local item = from_stack:get_name()

	if to_list == "input" then
		if barrel.can_drain(pos, item) then
			return 1
		end

	elseif to_list == "output" then
		if barrel.can_fill(pos, item) then
			return 1
		end
	end

	return 0
end

function barrel.allow_metadata_inventory_put(pos, listname, index, stack, player)
	local item = stack:get_name()

	if listname == "input" then
		if barrel.can_drain(pos, item) then
			return 1
		end

	elseif listname == "output" then
		if barrel.can_fill(pos, item) then
			return 1
		end
	end

	return 0
end

function barrel.on_metadata_inventory_put(pos, listname, index, stack, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local name = stack:get_name()

	if listname == "input" then
		local empty = barrel.add_barrel_liquid(pos, name)
		inv:set_stack(listname, index, empty)

	elseif listname == "output" then
		local full = barrel.drain_barrel_liquid(pos, name)
		inv:set_stack(listname, index, full)
	end
end

function barrel.on_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(to_list, to_index)
	barrel.on_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

cottages.api.register_machine("cottages:barrel", {
	description = S("barrel"),
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "mesh",
	mesh = "cottages_barrel_closed.obj",
	tiles = {"cottages_barrel.png"},
	is_ground_content = false,
	groups = {
		snappy = 1,
		choppy = 2,
		oddly_breakable_by_hand = 1,
		flammable = 2
	},
	sounds = cottages.sounds.wood,

	inv_info = {
		input = 1,
		output = 1,
	},

	can_dig = barrel.can_dig,

	get_fs_parts = barrel.get_barrel_fs_parts,
	get_info = barrel.get_barrel_info,

	allow_metadata_inventory_move = barrel.allow_metadata_inventory_move,
	allow_metadata_inventory_put = barrel.allow_metadata_inventory_put,

	on_metadata_inventory_move = barrel.on_metadata_inventory_move,
	on_metadata_inventory_put = barrel.on_metadata_inventory_put,
})
