local util = {}

function util.player_can_use(pos, player)
	if not (pos and minetest.is_player(player)) then
		return false
	end

	local player_name = player:get_player_name()
	local meta = minetest.get_meta(pos)

	if meta:get_string("public") == "public" then
		meta:set_int("public", 2)
	end

	local owner = meta:get_string("owner")
	local public = meta:get_int("public")

	return (
		(owner == player_name or owner == "" or owner == " ") or
		public > 0
	)
end

function util.toggle_public(pos, sender)
	local sender_name = sender:get_player_name()
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")
	local public = meta:get_int("public")

	if owner == "" or owner == " " and not minetest.is_protected(pos, sender_name) then
		meta:set_string("owner", sender_name)
	end

	if public == 0 and owner == sender_name then
		-- owner can switch private to protected
		meta:set_int("public", 1)
		return true

	elseif public == 1 and not minetest.is_protected(pos, sender_name) then
		-- player of area can switch protected to public
		meta:set_int("public", 2)
		return true

	elseif public == 2 then
		if owner == sender_name then
			-- owner can switch public to private
			meta:set_int("public", 0)
			return true

		elseif not minetest.is_protected(pos, sender_name) then
			-- player of area can switch public to protected
			meta:set_int("public", 1)
			return true
		end
	end

	return false
end

cottages.util = util
