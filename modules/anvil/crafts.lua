local S = cottages.S
local ci = cottages.craftitems

if ci.steelblock then
	minetest.register_craft({
		output = "cottages:anvil",
		recipe = {
			{ ci.steelblock, ci.steelblock, ci.steelblock },
			{ "", ci.steelblock, "" },
			{ ci.steelblock, ci.steelblock, ci.steelblock },
		},
	})
end

if ci.steel then
	minetest.register_craft({
		output = "cottages:hammer",
		recipe = {
			{ ci.steel },
			{ "cottages:anvil" },
			{ ci.stick },
		},
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

	minetest.register_craft({
		output = build_public_string(),
		type = "shapeless",
		recipe = { "cottages:anvil", ci.paper },
	})
end

-- allows reverting public anvil
minetest.register_craft({
	output = "cottages:anvil",
	type = "shapeless",
	recipe = { "cottages:anvil" },
})
