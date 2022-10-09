local S = cottages.S

local api = cottages.doorlike
local stamina_use = cottages.settings.doorlike.stamina
local has_stamina = cottages.has.stamina

-- propagate shutting/closing of window shutters to window shutters below/above this one
local offsets = {
	vector.new(0, 1, 0),
	vector.new(0, 2, 0),
	vector.new(0, 3, 0),
}

function api.shutter_operate(pos, old_node_state_name, new_node_state_name)
	local new_node = {name = new_node_state_name}
	local old_node = minetest.get_node(pos)
	new_node.param2 = old_node.param2
	minetest.swap_node(pos, {name = new_node_state_name, param2 = old_node.param2})

	local stop_up = false
	local stop_down = false

	for _, offset in ipairs(offsets) do
		local npos = pos + offset
		old_node = minetest.get_node(npos)
		if old_node.name == old_node_state_name and not stop_up then
			new_node.param2 = old_node.param2
			minetest.swap_node(npos, new_node)
		else
			stop_up = true
		end

		npos = pos - offset
		old_node = minetest.get_node(npos)
		if old_node.name == old_node_state_name and not stop_down then
			new_node.param2 = old_node.param2
			minetest.swap_node(npos, new_node)
		else
			stop_down = true
		end
	end
end

function api.shutter_open(pos, puncher)
	api.shutter_operate(pos, "cottages:window_shutter_closed", "cottages:window_shutter_open")
	if has_stamina then
		stamina.exhaust_player(puncher, stamina_use, "cottages:shutter")
	end
end

function api.shutter_close(pos, puncher)
	api.shutter_operate(pos, "cottages:window_shutter_open", "cottages:window_shutter_closed")
	if has_stamina then
		stamina.exhaust_player(puncher, stamina_use, "cottages:shutter")
	end
end

function api.is_night()
	-- at this time, sleeping in a bed is not possible
	return minetest.get_timeofday() < 0.2 or minetest.get_timeofday() > 0.805
end

-----------------------------------------------------------------------------------------------------------
-- a hatch; nodebox definition taken from realtest
-----------------------------------------------------------------------------------------------------------

-- hatches rotate around their axis
--  old facedir:  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19,20,21,22,23
local new_facedirs = {10, 19, 4, 13, 2, 18, 22, 14, 20, 16, 0, 12, 11, 3, 7, 21, 9, 23, 5, 1, 8, 15, 6, 17}

local node_box = {
	{-0.49, -0.55, -0.49, -0.3, -0.45, 0.45},
	{0.3, -0.55, -0.3, 0.49, -0.45, 0.45},
	{0.49, -0.55, -0.49, -0.3, -0.45, -0.3},
	{-0.075, -0.55, -0.3, 0.075, -0.45, 0.3},
	{-0.3, -0.55, -0.075, -0.075, -0.45, 0.075},
	{0.075, -0.55, -0.075, 0.3, -0.45, 0.075},

	{-0.3, -0.55, 0.3, 0.3, -0.45, 0.45},

	-- hinges
	{-0.45, -0.530, 0.45, -0.15, -0.470, 0.525},
	{0.15, -0.530, 0.45, 0.45, -0.470, 0.525},

	-- handle
	{-0.05, -0.60, -0.35, 0.05, -0.40, -0.45},
}

local function rotate(unrotated)
	local rotated = {}
	for _, row in ipairs(unrotated) do
		local x1, y1, z1, x2, y2, z2 = unpack(row)
		local tmp = x1
		x1 = -x2
		x2 = -tmp

		tmp = y1
		y1 = -z2
		z2 = -y2
		y2 = -z1
		z1 = -tmp

		table.insert(rotated, {x1, y1, z1, x2, y2, z2})
	end
	return rotated
end

function api.register_hatch(nodename, description, texture, receipe_item, def)
	if cottages.has.doors then
		def = def or {}
		def.description = S(description)
		def.tile_front = texture
		def.tile_side = texture
		def.groups = def.groups or {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2}
		def.nodebox_closed = {
			type = "fixed",
			fixed = node_box,
		}
		def.nodebox_opened = {
			type = "fixed",
			fixed = rotate(node_box),
		}

		doors.register_trapdoor(nodename, def)

	else
		minetest.register_node(nodename, {
			description = S(description), -- not that there are any other...
			drawtype = "nodebox",
			-- top, bottom, side1, side2, inner, outer
			tiles = {texture},
			paramtype = "light",
			paramtype2 = "facedir",
			groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 2},

			node_box = {
				type = "fixed",
				fixed = node_box,
			},
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.55, -0.5, 0.5, -0.45, 0.5},
			},
			on_rightclick = function(pos, node, puncher)
				if has_stamina then
					stamina.exhaust_player(puncher, stamina_use, nodename)
				end

				minetest.swap_node(pos, {name = node.name, param2 = new_facedirs[node.param2 + 1]})
			end,
			is_ground_content = false,
			on_place = minetest.rotate_node,
		})
	end

	minetest.register_craft({
		output = nodename,
		recipe = {
			{"", "", receipe_item},
			{receipe_item, cottages.craftitems.stick, ""},
		}
	})
end
