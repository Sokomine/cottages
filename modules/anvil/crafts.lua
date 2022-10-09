local S = cottages.S
local ci = cottages.craftitems

if ci.steel then
	minetest.register_craft({
		output = "cottages:anvil",
		recipe = {
			{ci.steel, ci.steel, ci.steel},
			{"", ci.steel, ""},
			{ci.steel, ci.steel, ci.steel}},
	})

	minetest.register_craft({
		output = "cottages:hammer",
		recipe = {
			{ci.steel},
			{"cottages:anvil"},
			{ci.stick}}
	})
end

if ci.paper then
	local function build_public_string()
		local stack = ItemStack("cottages:anvil")
		local meta = stack:get_meta()
		meta:set_int("shared", 1)
		meta:set_string("description", S("Anvil (public)"))
		return stack:to_string()
	end

	local function build_protected_string()
		local stack = ItemStack("cottages:anvil")
		local meta = stack:get_meta()
		meta:set_int("shared", 2)
		meta:set_string("description", S("Anvil (protected)"))
		return stack:to_string()
	end

	minetest.register_craft({
		output = build_protected_string(),
		type = "shapeless",
		recipe = {"anvil:anvil", ci.paper}
	})

	minetest.register_craft({
		output = build_public_string(),
		type = "shapeless",
		recipe = {build_protected_string(), ci.paper}
	})

	minetest.register_craft({
		output = "anvil:anvil",
		type = "shapeless",
		recipe = {build_public_string(), ci.paper}
	})
end
