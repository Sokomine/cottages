local S = cottages.S

-- the hammer for the anvil
minetest.register_tool("cottages:hammer", {
	description = S("Steel hammer for repairing tools on the anvil"),
	image = "cottages_tool_steelhammer.png",
	inventory_image = "cottages_tool_steelhammer.png",

	tool_capabilities = {
		full_punch_interval = 0.8,
		max_drop_level = 1,
		groupcaps = {
			-- about equal to a stone pick (it's not intended as a tool)
			cracky = {times = {[2] = 2.00, [3] = 1.20}, uses = 30, maxlevel = 1},
		},
		damage_groups = {fleshy = 6},
	}
})

if cottages.settings.anvil.disable_hammer_repair then
	cottages.anvil.make_unrepairable("cottages:hammer")
end
