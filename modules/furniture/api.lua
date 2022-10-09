local S = cottages.S
local pts = minetest.pos_to_string

local api = cottages.furniture

local attached_to = {}
local attached_at = {}

function api.allow_attach(pos, player)
	if not minetest.is_player(player) then
		return false
	end

	if attached_to[player] then
		-- allow re-attaching to the same spot, but not a different spot
		for _, p2 in ipairs(attached_to[player]) do
			if vector.equals(pos, p2) then
				return true
			end
		end

		return false
	end

	local ps = pts(pos)
	if attached_at[ps] and attached_at[ps] ~= player then
		-- disallow multiple people to attach to the same spot
		return false
	end

	return true
end

function api.get_up(player)
	local player_name = player:get_player_name()

	if cottages.has.player_monoids then
		player_monoids.speed:del_change(player, "cottages:furniture")
		player_monoids.jump:del_change(player, "cottages:furniture")
		player_monoids.gravity:del_change(player, "cottages:furniture")

	else
		player:set_physics_override(1, 1, 1)
	end

	player_api.player_attached[player_name] = nil
	player_api.set_animation(player, "stand")

	if attached_to[player] then
		for _, pos in ipairs(attached_to[player]) do
			attached_at[pos] = nil
		end
		attached_to[player] = nil
	end

	player:set_eye_offset({x = 0, y = 0, z = 0}, {x = 0, y = 0, z = 0})
end

function api.stop_moving(player)
	if cottages.has.player_monoids then
		player_monoids.speed:add_change(player, 0, "cottages:furniture")
		player_monoids.jump:add_change(player, 0, "cottages:furniture")
		player_monoids.gravity:add_change(player, 0, "cottages:furniture")

	else
		player:set_physics_override(0, 0, 0)
	end
end

function api.sit_on_bench(pos, node, player)
	if not (cottages.has.player_api and api.allow_attach(pos, player)) then
		return
	end

	local animation = player_api.get_animation(player)

	if not animation then
		-- certain versions of minetest have a broken API
		return
	elseif animation.animation == "sit" then
		api.get_up(player)

	else
		-- the bench is not centered; prevent the player from sitting on air
		local player_pos = {x = pos.x, y = pos.y, z = pos.z}
		local player_name = player:get_player_name()

		if node.param2 == 0 then
			player_pos.z = player_pos.z + 0.3
		elseif node.param2 == 1 then
			player_pos.x = player_pos.x + 0.3
		elseif node.param2 == 2 then
			player_pos.z = player_pos.z - 0.3
		elseif node.param2 == 3 then
			player_pos.x = player_pos.x - 0.3
		end

		api.stop_moving(player)

		player_api.set_animation(player, "sit")
		player_api.player_attached[player_name] = true

		player:set_eye_offset({x = 0, y = -7, z = 2}, {x = 0, y = 0, z = 0})
		player:set_pos(player_pos)

		attached_to[player] = {pos}
		attached_at[pts(pos)] = player
	end
end

function api.is_head(node_name)
	return node_name == "cottages:bed_head" or node_name == "cottages:sleeping_mat_head"
end

function api.is_bed(node_name)
	return node_name == "cottages:bed_head" or node_name == "cottages:bed_foot"
end

function api.is_mat(node_name)
	return node_name == "cottages:sleeping_mat_head" or node_name == "cottages:sleeping_mat"
end

function api.is_head_of(foot_name, head_name)
	if foot_name == "cottages:bed_foot" then
		return head_name == "cottages:bed_head"
	elseif foot_name == "cottages:sleeping_mat" then
		return head_name == "cottages:sleeping_mat_head"
	end
end

function api.is_foot_of(head_name, foot_name)
	if head_name == "cottages:bed_head" then
		return foot_name == "cottages:bed_foot"
	elseif head_name == "cottages:sleeping_mat_head" then
		return foot_name == "cottages:sleeping_mat"
	end
end

function api.is_valid_bed(pos, node)
	local head_pos = vector.copy(pos)
	local foot_pos = vector.copy(pos)

	if api.is_head(node.name) then
		if node.param2 == 0 then
			foot_pos.z = foot_pos.z - 1
		elseif node.param2 == 1 then
			foot_pos.x = foot_pos.x - 1
		elseif node.param2 == 2 then
			foot_pos.z = foot_pos.z + 1
		elseif node.param2 == 3 then
			foot_pos.x = foot_pos.x + 1
		end

		local foot_node = minetest.get_node(foot_pos)

		if api.is_foot_of(node.name, foot_node.name) and node.param2 == foot_node.param2 then
			return head_pos, foot_pos
		end

	else
		if node.param2 == 2 then
			head_pos.z = pos.z - 1
		elseif node.param2 == 3 then
			head_pos.x = pos.x - 1
		elseif node.param2 == 0 then
			head_pos.z = pos.z + 1
		elseif node.param2 == 1 then
			head_pos.x = pos.x + 1
		end

		local head_node = minetest.get_node(head_pos)

		if api.is_head_of(node.name, head_node.name) and node.param2 == head_node.param2 then
			return head_pos, foot_pos
		end
	end
end

function api.sleep_in_bed(pos, node, player)
	if not (cottages.has.player_api and api.allow_attach(pos, player)) then
		return
	end

	local player_name = player:get_player_name()
	local head_pos, foot_pos = api.is_valid_bed(pos, node)

	for _, p in ipairs({head_pos, foot_pos}) do
		if p then
			for y = 1, 2 do
				local node_above = minetest.get_node(vector.add(p, {x = 0, y = y, z = 0}))

				if node_above.name ~= "air" then
					minetest.chat_send_player(
						player_name,
						S("This place is too narrow for sleeping. At least for you!")
					)
					return
				end
			end
		end
	end

	local animation = player_api.get_animation(player)

	if not animation then
		-- certain versions of minetest have a broken API
		return
	end

	if attached_to[player] then
		if animation.animation == "lay" then
			api.get_up(player)
			minetest.chat_send_player(player_name, "That was enough sleep for now. You stand up again.")

		elseif animation.animation == "sit" then
			if head_pos and foot_pos then
				player_api.set_animation(player, "lay")
				player:set_eye_offset({x = 0, y = -14, z = 2}, {x = 0, y = 0, z = 0})
				minetest.chat_send_player(player_name, S("You lie down and take a nap. A right-click will wake you up."))

			else
				api.get_up(player)
				minetest.chat_send_player(player_name, S("That was enough sitting around for now. You stand up again."))
			end
		end

	else
		-- sit on the bed before lying down
		api.stop_moving(player)

		player_api.set_animation(player, "sit")
		player_api.player_attached[player_name] = true

		local sleep_pos = vector.copy(pos)
		local bed_type = api.is_bed(node.name) and "bed" or "mat"

		if bed_type == "bed" then
			-- set the right height for the bed
			sleep_pos.y = sleep_pos.y + 0.4

		elseif bed_type == "mat" then
			sleep_pos.y = sleep_pos.y - 0.4
		end

		if head_pos and foot_pos then
			sleep_pos.x = (head_pos.x + foot_pos.x) / 2
			sleep_pos.z = (head_pos.z + foot_pos.z) / 2
		end

		player:set_eye_offset({x = 0, y = -7, z = 2}, {x = 0, y = 0, z = 0})
		player:set_pos(sleep_pos)

		if head_pos and foot_pos then
			attached_to[player] = {head_pos, foot_pos}
			attached_at[pts(head_pos)] = player
			attached_at[pts(foot_pos)] = player

			minetest.chat_send_player(
				player_name,
				S("Aaah! What a comfortable @1. A second right-click will let you sleep.", bed_type)
			)
		else
			attached_to[player] = {pos}
			attached_at[pts(pos)] = player

			minetest.chat_send_player(
				player_name,
				S("Comfortable, but not good enough for a nap. Right-click again if you want to get back up.")
			)
		end
	end
end

function api.break_attach(pos)
	local player = attached_at[pts(pos)]
	if player then
		api.get_up(player)
	end
end

minetest.register_on_leaveplayer(function(player)
	if attached_to[player] then
		api.get_up(player)
	end
end)

minetest.register_globalstep(function(dtime)
	for player in pairs(attached_to) do
		local c = player:get_player_control()
		if c.up or c.down or c.left or c.right or c.jump then
			api.get_up(player)
		end
	end
end)
