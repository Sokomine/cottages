local f = string.format

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

	if owner == player_name then
		return true
	elseif owner == "" or owner == " " or public == 1 then
		return not minetest.is_protected(pos, player_name)
	else
		return true
	end
end

function util.toggle_public(pos, sender)
	local sender_name = sender:get_player_name()
	local meta = minetest.get_meta(pos)
	local owner = meta:get_string("owner")

	if (owner == "" or owner == " ") and not minetest.is_protected(pos, sender_name) then
		owner = sender_name
		meta:set_string("owner", sender_name)
	end

	if meta:get_string("public") == "public" then
		meta:set_int("public", 2)
	end

	local public = meta:get_int("public")

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

local function tokenize(s)
	local tokens = {}

	local i = 1
	local j = 1

	while true do
		if s:sub(j, j) == "" then
			if i < j then
				table.insert(tokens, s:sub(i, j - 1))
			end
			return tokens
		elseif s:sub(j, j):byte() == 27 then
			if i < j then
				table.insert(tokens, s:sub(i, j - 1))
			end

			i = j
			local n = s:sub(i + 1, i + 1)

			if n == "(" then
				local m = s:sub(i + 2, i + 2)
				local k = s:find(")", i + 3, true)
				if m == "T" then
					table.insert(tokens, {
						type = "translation",
						domain = s:sub(i + 4, k - 1),
					})
				elseif m == "c" then
					table.insert(tokens, {
						type = "color",
						color = s:sub(i + 4, k - 1),
					})
				elseif m == "b" then
					table.insert(tokens, {
						type = "bgcolor",
						color = s:sub(i + 4, k - 1),
					})
				else
					error(("couldn't parse %s"):format(s))
				end
				i = k + 1
				j = k + 1
			elseif n == "F" then
				table.insert(tokens, {
					type = "start",
				})
				i = j + 2
				j = j + 2
			elseif n == "E" then
				table.insert(tokens, {
					type = "stop",
				})
				i = j + 2
				j = j + 2
			else
				error(("couldn't parse %s"):format(s))
			end
		else
			j = j + 1
		end
	end
end

local function parse(tokens, i, parsed)
	parsed = parsed or {}
	i = i or 1
	while i <= #tokens do
		local token = tokens[i]
		if type(token) == "string" then
			table.insert(parsed, token)
			i = i + 1
		elseif token.type == "color" or token.type == "bgcolor" then
			table.insert(parsed, token)
			i = i + 1
		elseif token.type == "translation" then
			local contents = {
				type = "translation",
				domain = token.domain,
			}
			i = i + 1
			contents, i = parse(tokens, i, contents)
			table.insert(parsed, contents)
		elseif token.type == "start" then
			local contents = {
				type = "escape",
			}
			i = i + 1
			contents, i = parse(tokens, i, contents)
			table.insert(parsed, contents)
		elseif token.type == "stop" then
			i = i + 1
			return parsed, i
		else
			error(("couldn't parse %s"):format(dump(token)))
		end
	end
	return parsed, i
end

local function erase_after_newline(parsed, erasing)
	local single_line_parsed = {}

	for _, piece in ipairs(parsed) do
		if type(piece) == "string" then
			if not erasing then
				if piece:find("\n") then
					erasing = true
					local single_line = piece:match("^([^\n]*)\n")
					table.insert(single_line_parsed, single_line)
				else
					table.insert(single_line_parsed, piece)
				end
			end
		elseif piece.type == "bgcolor" or piece.type == "color" then
			table.insert(single_line_parsed, piece)
		elseif piece.type == "escape" then
			table.insert(single_line_parsed, erase_after_newline(piece, erasing))
		elseif piece.type == "translation" then
			local stuff = erase_after_newline(piece, erasing)
			stuff.domain = piece.domain
			table.insert(single_line_parsed, stuff)
		else
			error(("unknown type %s"):format(piece.type))
		end
	end

	return single_line_parsed
end

local function unparse(parsed, parts)
	parts = parts or {}
	for _, part in ipairs(parsed) do
		if type(part) == "string" then
			table.insert(parts, part)
		else
			if part.type == "bgcolor" then
				table.insert(parts, ("\27(b@%s)"):format(part.color))
			elseif part.type == "color" then
				table.insert(parts, ("\27(c@%s)"):format(part.color))
			elseif part.domain then
				table.insert(parts, ("\27(T@%s)"):format(part.domain))
				unparse(part, parts)
				table.insert(parts, "\27E")
			else
				table.insert(parts, "\27F")
				unparse(part, parts)
				table.insert(parts, "\27E")
			end
		end
	end

	return parts
end

function util.get_safe_short_description(item)
	item = type(item) == "userdata" and item or ItemStack(item)
	local description = item:get_description()
	local tokens = tokenize(description)
	local parsed = parse(tokens)
	local single_line_parsed = erase_after_newline(parsed)
	local single_line = table.concat(unparse(single_line_parsed), "")
	return single_line
end

function util.resolve_item(item)
	local item_stack = ItemStack(item)
	local name = item_stack:get_name()

	local seen = { [name] = true }

	local alias = minetest.registered_aliases[name]
	while alias do
		name = alias
		seen[name] = true
		alias = minetest.registered_aliases[name]
		if seen[alias] then
			error(f("alias cycle on %s", name))
		end
	end

	if minetest.registered_items[name] then
		item_stack:set_name(name)
		return item_stack:to_string()
	end
end

-- https://github.com/minetest/minetest/blob/9fc018ded10225589d2559d24a5db739e891fb31/doc/lua_api.txt#L453-L462
function util.escape_texture(texturestring)
	-- store in a variable so we don't return both rvs of gsub
	local v = texturestring:gsub("[%^:]", {
		["^"] = "\\^",
		[":"] = "\\:",
	})
	return v
end

function util.table_size(t)
	local size = 0
	for _ in pairs(t) do
		size = size + 1
	end
	return size
end

local function equals(a, b)
	local t = type(a)

	if t ~= type(b) then
		return false
	end

	if t ~= "table" then
		return a == b
	elseif a == b then
		return true
	end

	local size_a = 0

	for key, value in pairs(a) do
		if not equals(value, b[key]) then
			return false
		end
		size_a = size_a + 1
	end

	return size_a == util.table_size(b)
end

util.equals = equals

if ItemStack().equals then
	-- https://github.com/minetest/minetest/pull/12771
	function util.items_equals(item1, item2)
		item1 = type(item1) == "userdata" and item1 or ItemStack(item1)
		item2 = type(item2) == "userdata" and item2 or ItemStack(item2)

		return item1 == item2
	end
else
	function util.items_equals(item1, item2)
		item1 = type(item1) == "userdata" and item1 or ItemStack(item1)
		item2 = type(item2) == "userdata" and item2 or ItemStack(item2)

		return equals(item1:to_table(), item2:to_table())
	end
end

local has_stamina = cottages.has.stamina
local has_staminoid = cottages.has.staminoid

function util.exhaust_player(player, amount, reason)
	if has_stamina then
		stamina.exhaust_player(player, amount, reason)
	elseif has_staminoid then
		staminoid.exhaust(player, 1, reason)
	end
end

cottages.util = util
