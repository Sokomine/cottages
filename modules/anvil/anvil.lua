local S = cottages.S
local F = minetest.formspec_escape
local FS = function(...) return F(S(...)) end
local anvil = cottages.anvil

local add_entity = minetest.add_entity
local get_node = minetest.get_node
local get_objects_in_area = minetest.get_objects_in_area
local serialize = minetest.serialize

local v_add = vector.add
local v_eq = vector.equals
local v_new = vector.new
local v_sub = vector.subtract

local get_safe_short_description = futil.get_safe_short_description
local resolve_item = futil.resolve_item

local has_stamina = cottages.has.stamina

local repair_amount = cottages.settings.anvil.repair_amount
local hammer_wear = cottages.settings.anvil.hammer_wear
local formspec_enabled = cottages.settings.anvil.formspec_enabled
local tool_hud_enabled = cottages.settings.anvil.tool_hud_enabled
local hud_timeout = cottages.settings.anvil.hud_timeout
local stamina_use = cottages.settings.anvil.stamina
local tool_entity_enabled = cottages.settings.anvil.tool_entity_enabled
local tool_entity_displacement = cottages.settings.anvil.tool_entity_displacement

local hud_info_by_puncher_name = {}

local function get_hud_image(tool)
	local tool_def = tool:get_definition()
	if tool_def then
		return tool_def.inventory_image or tool_def.wield_image
	end
end

function anvil.get_anvil_info(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local input = inv:get_stack("input", 1)
	local wear = math.round((65536 - input:get_wear()) / 655.36)

	if input:is_empty() then
		return S("anvil")

	elseif input:get_wear() > 0 then
		return S("anvil; repairing @1 (@2%)", get_safe_short_description(input), wear)

	else
		return S("anvil; @1 is repaired", get_safe_short_description(input))
	end
end

function anvil.get_anvil_fs_parts()
	return {
		("size[8,8]"),
		("image[7,3;1,1;cottages_tool_steelhammer.png]"),
		("label[2.5,1.0;%s]"):format(FS("Workpiece:")),
		("label[6.0,2.7;%s]"):format(FS("Optional")),
		("label[6.0,3.0;%s]"):format(FS("storage for")),
		("label[6.0,3.3;%s]"):format(FS("your hammer")),
		("label[0,0.0;%s]"):format(FS("Anvil")),
		("label[0,3.0;%s]"):format(FS("Punch anvil with hammer to")),
		("label[0,3.3;%s]"):format(FS("repair tool in workpiece-slot.")),
		("list[context;input;2.5,1.5;1,1;]"),
		("list[context;hammer;5,3;1,1;]"),
		("list[current_player;main;0,4;8,4;]"),
		("listring[context;hammer]"),
		("listring[current_player;main]"),
		("listring[context;input]"),
		("listring[current_player;main]"),
	}
end

local function sparks(pos)
	pos.y = pos.y + tool_entity_displacement
	minetest.add_particlespawner({
		amount = 10,
		time = 0.1,
		minpos = pos,
		maxpos = pos,
		minvel = {x = 2, y = 3, z = 2},
		maxvel = {x = -2, y = 1, z = -2},
		minacc = {x = 0, y = -10, z = 0},
		maxacc = {x = 0, y = -10, z = 0},
		minexptime = 0.5,
		maxexptime = 1,
		minsize = 1,
		maxsize = 1,
		collisiondetection = true,
		vertical = false,
		texture = "cottages_anvil_spark.png",
	})
end

local function update_hud(puncher, tool)
	local puncher_name = puncher:get_player_name()
	local damage_state = 40 - math.floor(40 * tool:get_wear() / 65535)
	local hud_image = get_hud_image(tool)

	local hud1, hud1_def, hud2, hud3, hud3_def

	if hud_info_by_puncher_name[puncher_name] then
		if tool_hud_enabled then
			hud1, hud2, hud3 = unpack(hud_info_by_puncher_name[puncher_name])
			hud1_def = puncher:hud_get(hud1)

		else
			hud2, hud3 = unpack(hud_info_by_puncher_name[puncher_name])
		end
		hud3_def = puncher:hud_get(hud3)
	end

	if hud3_def and hud3_def.name == "anvil_foreground" then
		if tool_hud_enabled and hud1_def and hud1_def.name == "anvil_image" then
			puncher:hud_change(hud1, "text", hud_image)
		end
		puncher:hud_change(hud3, "number", damage_state)

	else
		if tool_hud_enabled and hud_image then
			hud1 = puncher:hud_add({
				hud_elem_type = "image",
				name = "anvil_image",
				text = hud_image,
				scale = {x = 15, y = 15},
				position = {x = 0.5, y = 0.5},
				alignment = {x = 0, y = 0}
			})
		end
		hud2 = puncher:hud_add({
			hud_elem_type = "statbar",
			name = "anvil_background",
			text = "default_cloud.png^[colorize:#ff0000:256",
			number = 40,
			direction = 0, -- left to right
			position = {x = 0.5, y = 0.65},
			alignment = {x = 0, y = 0},
			offset = {x = -320, y = 0},
			size = {x = 32, y = 32},
		})
		hud3 = puncher:hud_add({
			hud_elem_type = "statbar",
			name = "anvil_foreground",
			text = "default_cloud.png^[colorize:#00ff00:256",
			number = damage_state,
			direction = 0, -- left to right
			position = {x = 0.5, y = 0.65},
			alignment = {x = 0, y = 0},
			offset = {x = -320, y = 0},
			size = {x = 32, y = 32},
		})
	end

	if tool_hud_enabled then
		hud_info_by_puncher_name[puncher_name] = {hud1, hud2, hud3, os.time() + hud_timeout}

	else
		hud_info_by_puncher_name[puncher_name] = {hud2, hud3, os.time() + hud_timeout}
	end
end

function anvil.use_anvil(pos, puncher)
	-- only punching with the hammer is supposed to work
	local wielded = puncher:get_wielded_item()

	if wielded:get_name() ~= resolve_item("cottages:hammer") then
		return
	end

	local puncher_name = puncher:get_player_name()
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local tool = inv:get_stack("input", 1)
	local tool_name = tool:get_name()

	if tool:is_empty() then
		return

	elseif not anvil.can_repair(tool) then
		-- just to make sure that tool really can't be repaired if it should not
		-- (if the check of placing the item in the input slot failed somehow)
		minetest.chat_send_player(puncher_name, S("@1 is not repairable by the anvil", tool_name))

	elseif tool:get_wear() > 0 then
		minetest.sound_play({name = "anvil_clang"}, {pos = pos})
		sparks(pos)

		-- do the actual repair
		tool:add_wear(-repair_amount)
		inv:set_stack("input", 1, tool)

		-- damage the hammer slightly
		wielded:add_wear(hammer_wear)
		puncher:set_wielded_item(wielded)

		update_hud(puncher, tool)

		if has_stamina then
			stamina.exhaust_player(puncher, stamina_use, "cottages:anvil")
		end

	else
		-- tell the player when the job is done, but only once
		if meta:get_int("informed") > 0 then
			return
		end

		meta:set_int("informed", 1)

		local tool_desc = tool:get_short_description() or tool:get_description()
		minetest.chat_send_player(puncher_name, S("Your @1 has been repaired successfully.", tool_desc))
	end
end

function anvil.rightclick_anvil(pos, clicker, itemstack)
	if formspec_enabled or not (pos and itemstack) then
		return
	end

	local meta = minetest.get_meta(pos)
	meta:set_string("formspec", "")
	local inv = meta:get_inventory()
	local input_stack = inv:get_stack("input", 1)
	local hammer_stack = inv:get_stack("hammer", 1)

	local taken
	if anvil.allow_metadata_inventory_take(pos, "input", 1, input_stack, clicker) > 0 then
		taken = inv:remove_item("input", input_stack)

	elseif anvil.allow_metadata_inventory_take(pos, "hammer", 1, hammer_stack, clicker) > 0 then
		taken = inv:remove_item("hammer", hammer_stack)
	end

	local can_put = anvil.allow_metadata_inventory_put(pos, "input", 1, itemstack, clicker)

	if can_put == 1 then
		inv:add_item("input", itemstack)
		itemstack:clear()
		meta:set_int("informed", 0)

	elseif taken and not itemstack:is_empty() then
		-- put it back
		inv:add_item("input", input_stack)
		taken = nil
	end

	anvil.update_entity(pos)

	return taken or itemstack
end

function anvil.get_entity(pos)
	local to_return

	for _, obj in ipairs(get_objects_in_area(v_sub(pos, 0.5), v_add(pos, 0.5))) do
		local ent = obj:get_luaentity()
		if ent and ent.name == "cottages:anvil_item" then
			local ent_pos = ent.pos
			if not ent_pos then
				obj:remove()

			elseif v_eq(ent_pos, pos) then
				if to_return then
					obj:remove()

				else
					to_return = obj
				end
			end
		end
	end

	return to_return
end

function anvil.clear_entity(pos)
	local obj = anvil.get_entity(pos)
	if obj then
		obj:remove()
	end
end

function anvil.add_entity(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	if inv:is_empty("input") then
		return
	end

	local tool = inv:get_stack("input", 1)
	local tool_name = tool:get_name()
	local node = get_node(pos)

	local entity_pos = v_add(pos, v_new(0, tool_entity_displacement, 0))

	local obj = add_entity(entity_pos, "cottages:anvil_item", serialize({pos, tool_name}))

	if obj then
		local yaw = math.pi * 2 - node.param2 * math.pi / 2
		obj:set_rotation({ x = -math.pi / 2, y = yaw, z = 0}) -- x is pitch
	end
end

function anvil.update_entity(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local tool = inv:get_stack("input", 1)
	local tool_name = tool:get_name()
	local obj = anvil.get_entity(pos)

	if tool:is_empty() and obj then
		anvil.clear_entity(pos)

	elseif obj then
		local e = obj:get_luaentity()
		if e.item ~= tool_name then
			e.item = tool_name
			obj:set_properties({wield_item = tool_name})
		end

	elseif tool_entity_enabled and not tool:is_empty() then
		anvil.add_entity(pos)
	end
end

function anvil.allow_metadata_inventory_put(pos, listname, index, stack, player)
	local count = stack:get_count()
	if count == 0 then
		return count
	end

	local stack_name = stack:get_name()

	if listname == "hammer" and stack_name ~= resolve_item("cottages:hammer") then
		return 0
	end

	if listname == "input" then
		local wear = stack:get_wear()
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		if stack_name == resolve_item("cottages:hammer") and wear == 0 and inv:is_empty("hammer") then
			-- we will move it to the hammer slot in on_metadata_inventory_put
			return count
		end

		local player_name = player and player:get_player_name()

		if wear == 0 or not stack:is_known() then
			minetest.chat_send_player(player:get_player_name(), S("The workpiece slot is for damaged tools only."))
			return 0
		end

		if not anvil.can_repair(stack) then
			local description = stack:get_short_description() or stack:get_description()
			minetest.chat_send_player(player_name, S("@1 cannot be repaired with an anvil.", description))
			return 0
		end
	end

	return count
end

function anvil.allow_metadata_inventory_take(pos, listname, index, stack, player)
	return stack:get_count()
end

function anvil.allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local from_stack = inv:get_stack(from_list, from_index)

	if anvil.allow_metadata_inventory_take(pos, from_list, from_index, from_stack, player) > 0
		and anvil.allow_metadata_inventory_put(pos, to_list, to_index, from_stack, player) > 0 then
		return count
	end

	return 0
end

function anvil.on_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	if to_list == "input" then
		local meta = minetest.get_meta(pos)
		meta:set_int("informed", 0)
	end

	anvil.update_entity(pos)
end

function anvil.on_metadata_inventory_put(pos, listname, index, stack, player)
	if listname == "input" and stack:get_name() == resolve_item("cottages:hammer") and stack:get_wear() == 0 then
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if inv:is_empty("hammer") then
			inv:set_stack("hammer", 1, stack)
			inv:set_stack("input", 1, ItemStack())
		end
		return
	end

	if listname == "input" then
		local meta = minetest.get_meta(pos)
		meta:set_int("informed", 0)
	end

	anvil.update_entity(pos)
end

function anvil.on_metadata_inventory_take(pos, listname, index, stack, player)
	anvil.update_entity(pos)
end

function anvil.preserve_metadata(pos, oldnode, oldmeta, drops)
	for _, item in ipairs(drops) do
		if item:get_name() == "cottages:anvil" then
			local drop_meta = item:get_meta()
			local owner = oldnode:get_string("owner")

			if owner == "" then
				drop_meta:set_int("shared", 1)
				drop_meta:set_string("description", S("Anvil (public)"))

			elseif owner == " " then
				drop_meta:set_int("shared", 2)
				drop_meta:set_string("description", S("Anvil (protected)"))
			end
		end
	end
	return drops
end

cottages.api.register_machine("cottages:anvil", {
	description = S("anvil"),
	drawtype = "nodebox",
	-- the nodebox model comes from realtest
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.3, 0.5, -0.4, 0.3},
			{-0.35, -0.4, -0.25, 0.35, -0.3, 0.25},
			{-0.3, -0.3, -0.15, 0.3, -0.1, 0.15},
			{-0.35, -0.1, -0.2, 0.35, 0.1, 0.2},
		},
	},
	tiles = {"cottages_stone.png^[colorize:#000:192"},
	groups = {cracky = 2},
	sounds = cottages.sounds.metal,

	inv_info = {
		input = 1,
		hammer = 1,
	},

	use = anvil.use_anvil,
	rightclick = anvil.rightclick_anvil,
	get_fs_parts = formspec_enabled and anvil.get_anvil_fs_parts,
	get_info = anvil.get_anvil_info,

	on_metadata_inventory_move = anvil.on_metadata_inventory_move,
	on_metadata_inventory_put = anvil.on_metadata_inventory_put,
	on_metadata_inventory_take = anvil.on_metadata_inventory_take,

	allow_metadata_inventory_move = anvil.allow_metadata_inventory_move,
	allow_metadata_inventory_put = anvil.allow_metadata_inventory_put,
	allow_metadata_inventory_take = anvil.allow_metadata_inventory_take,
})

-- clear hud info
minetest.register_globalstep(function()
	local now = os.time()

	for puncher_name, hud_info in pairs(hud_info_by_puncher_name) do
		local puncher = minetest.get_player_by_name(puncher_name)
		local hud1, hud2, hud3, hud_expire_time
		if tool_hud_enabled then
			hud1, hud2, hud3, hud_expire_time = unpack(hud_info)

		else
			hud2, hud3, hud_expire_time = unpack(hud_info)
		end

		if puncher then
			if now > hud_expire_time then
				if tool_hud_enabled then
					local hud1_def = puncher:hud_get(hud1)
					if hud1_def and hud1_def.name == "anvil_image" then
						puncher:hud_remove(hud1)
					end
				end

				local hud2_def = puncher:hud_get(hud2)
				if hud2_def and hud2_def.name == "anvil_background" then
					puncher:hud_remove(hud2)
				end

				local hud3_def = puncher:hud_get(hud3)
				if hud3_def and hud3_def.name == "anvil_foreground" then
					puncher:hud_remove(hud3)
				end

				hud_info_by_puncher_name[puncher_name] = nil
			end

		else
			hud_info_by_puncher_name[puncher_name] = nil
		end
	end
end)
