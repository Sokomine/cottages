local S = cottages.S

local api = cottages.straw

local has_ui = cottages.has.unified_inventory

if has_ui then
	unified_inventory.register_craft_type("cottages:quern", {
		description = S("quern-stone"),
		icon = "cottages_quern.png",
		width = 1,
		height = 1,
		uses_crafting_grid = false,
	})

	unified_inventory.register_craft_type("cottages:threshing", {
		description = S("threshing floor"),
		icon = "cottages_junglewood.png^farming_wheat.png",
		width = 1,
		height = 1,
		uses_crafting_grid = false,
	})
end

api.registered_quern_crafts = {}

function api.register_quern_craft(recipe)
	api.registered_quern_crafts[recipe.input] = recipe.output

	if has_ui then
		unified_inventory.register_craft({
			output = recipe.output,
			type = "cottages:quern",
			items = {recipe.input},
			width = 1,
		})
	end
end

api.registered_threshing_crafts = {}

function api.register_threshing_craft(recipe)
	api.registered_threshing_crafts[recipe.input] = recipe.output

	if has_ui then
		for _, output in ipairs(recipe.output) do
			unified_inventory.register_craft({
				output = output,
				type = "cottages:threshing",
				items = {recipe.input},
				width = 1,
			})
		end
	end
end
