local S = cottages.S
local ci = cottages.craftitems

if ci.stick then
	minetest.register_craft({
		output = "cottages:pitchfork",
		recipe = {
			{ci.stick, ci.stick, ci.stick},
			{"", ci.stick, ""},
			{"", ci.stick, ""},
		}
	})
end

if cottages.has.unified_inventory then
	unified_inventory.register_craft_type("cottages:pitchfork", {
		description = S("gathered w/ the pitchfork"),
		icon = "cottages_pitchfork.png",
		width = 1,
		height = 1,
		uses_crafting_grid = false,
	})

	unified_inventory.register_craft({
		output = "cottages:hay_mat",
		type = "cottages:pitchfork",
		items = {"default:dirt_with_grass"},
		width = 1,
	})
end
