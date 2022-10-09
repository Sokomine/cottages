local S = cottages.S
local F = minetest.formspec_escape
local FS = function(...) return F(S(...)) end

local player_can_use = cottages.util.player_can_use
local toggle_public = cottages.util.toggle_public

local items_equals = futil.items_equals

function cottages.api.update_formspec(pos)

end

function cottages.api.register_machine(name, def)
	local update_formspec

	if def.get_fs_parts then
		function update_formspec(pos)
			-- TODO instead create "public button formspec" api call, to generate this. works better w/ fs_layout
			local fs_parts = def.get_fs_parts(pos)

			table.insert(fs_parts, ("button[6.0,1.5;1.5,0.5;public;%s]"):format(FS("public?")))

			local meta = minetest.get_meta(pos)
			local public = meta:get_int("public")

			if public == 0 then
				local owner = meta:get_string("owner")
				table.insert(fs_parts, ("label[6.1,2.1;%s]"):format(FS("owner: @1", owner)))

			elseif public == 1 then
				table.insert(fs_parts, ("label[6.1,2.1;%s]"):format(FS("(protected)")))

			elseif public == 2 then
				table.insert(fs_parts, ("label[6.1,2.1;%s]"):format(FS("(public)")))
			end

			meta:set_string("formspec", table.concat(fs_parts, ""))
		end
	end

	local update_infotext
	if def.get_info then
		function update_infotext(pos)
			local info = def.get_info(pos)

			local meta = minetest.get_meta(pos)
			local public = meta:get_int("public")
			if public == 0 then
				local owner = meta:get("owner")
				meta:set_string("infotext", S("@1 (owned by @2)", info, owner))

			elseif public == 1 then
				meta:set_string("infotext", S("protected @1", info))

			elseif public == 2 then
				meta:set_string("infotext", S("public @1", info))

			else
				meta:set_string("infotext", "ERROR IN INFOTEXT")
			end
		end
	end

	minetest.register_node(name, {
		description = def.description,
		short_description = def.short_description,
		drawtype = def.drawtype or "normal",
		mesh = def.mesh,
		node_box = def.node_box,
		selection_box = def.selection_box or def.node_box,
		collision_box = def.collision_box or def.selection_box or def.node_box,
		paramtype = def.paramtype or "light",
		paramtype2 = def.paramtype2 or "facedir",
		tiles = def.tiles,
		is_ground_content = false,
		groups = def.groups,
		sounds = def.sounds,

		after_place_node = function(pos, placer)
			local meta = minetest.get_meta(pos)

			if def.inv_info then
				local inv = meta:get_inventory()
				for inv_name, size in pairs(def.inv_info) do
					inv:set_size(inv_name, size)
				end
			end

			local owner = placer:get_player_name()
			meta:set_string("owner", owner or "")
			if update_infotext then update_infotext(pos) end
			if update_formspec then update_formspec(pos) end
		end,

		on_receive_fields = function(pos, formname, fields, sender)
			if fields.public and toggle_public(pos, sender) then
				if update_infotext then update_infotext(pos) end
				if update_formspec then update_formspec(pos) end
			end
		end,

		can_dig = function(pos, player)
			if not minetest.is_player(player) then
				return false
			end

			local meta = minetest.get_meta(pos)

			if def.inv_info then
				local inv = meta:get_inventory()
				for inv_name in pairs(def.inv_info) do
					if not inv:is_empty(inv_name) then
						return false
					end
				end
			end

			if def.can_dig and not def.can_dig(pos, player) then
				return false
			end

			local player_name = player:get_player_name()
			local owner = meta:get("owner")
			local public = meta:get_int("public")

			return owner == player_name or (
				(public > 0 or owner == "" or owner == " ") and not minetest.is_protected(pos, player_name)
			)
		end,

		allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
			if not player_can_use(pos, player) then
				return 0
			end

			if def.allow_metadata_inventory_move then
				return def.allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
			end

			return count
		end,

		allow_metadata_inventory_put = function(pos, listname, index, stack, player)
			if not player_can_use(pos, player) then
				return 0
			end

			if def.allow_metadata_inventory_put then
				return def.allow_metadata_inventory_put(pos, listname, index, stack, player)
			end

			return stack:get_count()
		end,

		allow_metadata_inventory_take = function(pos, listname, index, stack, player)
			if not player_can_use(pos, player) then
				return 0
			end

			if def.allow_metadata_inventory_take then
				return def.allow_metadata_inventory_take(pos, listname, index, stack, player)
			end

			return stack:get_count()
		end,

		on_metadata_inventory_put = function(pos, listname, index, stack, player)
			local meta = minetest.get_meta(pos)
			meta:set_int("used", 0)

			if def.on_metadata_inventory_put then
				def.on_metadata_inventory_put(pos, listname, index, stack, player)
			end

			if update_infotext then update_infotext(pos) end
			if update_formspec then update_formspec(pos) end
		end,

		on_metadata_inventory_take = function(pos, listname, index, stack, player)
			local meta = minetest.get_meta(pos)
			meta:set_int("used", 0)

			if def.on_metadata_inventory_take then
				def.on_metadata_inventory_take(pos, listname, index, stack, player)
			end

			if update_infotext then update_infotext(pos) end
			if update_formspec then update_formspec(pos) end
		end,

		on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
			local meta = minetest.get_meta(pos)
			meta:set_int("used", 0)

			if def.on_metadata_inventory_move then
				def.on_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
			end

			if update_infotext then update_infotext(pos) end
			if update_formspec then update_formspec(pos) end
		end,

		on_punch = function(pos, node, puncher, pointed_thing)
			if not (def.use and pos and puncher and player_can_use(pos, puncher)) then
				return
			end

			if def.use(pos, puncher) then
				local meta = minetest.get_meta(pos)
				meta:set_int("used", 1)
				if update_infotext then update_infotext(pos) end
				if update_formspec then update_formspec(pos) end
			end
		end,

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			if not (def.rightclick and pos and clicker and itemstack and player_can_use(pos, clicker)) then
				return
			end

			local rv = def.rightclick(pos, clicker, ItemStack(itemstack))

			if rv and not items_equals(rv, itemstack) then
				local meta = minetest.get_meta(pos)
				meta:set_int("used", 1)
				if update_infotext then update_infotext(pos) end
				if update_formspec then update_formspec(pos) end
			end

			return rv
		end,

		on_timer = def.on_timer,

		on_blast = function()
		end,
	})

	if update_formspec then
		minetest.register_lbm({
			name = ("cottages:update_formspec_%s"):format(name:gsub(":", "_")),
			label = ("update %s formspec"):format(name),
			nodenames = {name},
			run_at_every_load = true,
			action = update_formspec,
		})

	else
		minetest.register_lbm({
			name = ("cottages:update_formspec_%s"):format(name:gsub(":", "_")),
			label = ("remove %s formspec"):format(name),
			nodenames = {name},
			run_at_every_load = true,
			action = function(pos)
				local meta = minetest.get_meta(pos)
				meta:set_string("formspec", "")
			end,
		})
	end
end
