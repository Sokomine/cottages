-- unified_inventory integration
if (minetest.get_modpath("unified_inventory") == nil) then
	return
end

-- for threshing floor and handmill

assert((type(unified_inventory.register_craft_type) == "function"),
       "register_craft_type does not exist in unified_inventory")
assert((type(unified_inventory.register_craft) == "function"),
       "register_craft does not exist in unified_inventory")


unified_inventory.register_craft_type("cottages_threshing_floor", {
    description = "Threshing",
    icon = "cottages_junglewood.png^farming_wheat.png",
    width = 1,
    height = 1,
    uses_crafting_grid = false
})

for crop_name, seed_name in pairs(cottages.threshing_floor_receipes) do
    unified_inventory.register_craft({
        output = seed_name,
        type = "cottages_threshing_floor",
        items = {crop_name}
    })
end


unified_inventory.register_craft_type("cottages_handmill", {
    description = "Milling",
    icon = "default_stone.png", -- TODO we need a usable image of the handmill here
    width = 1,
    height = 1,
    uses_crafting_grid = false
})

for input_name, product in pairs(cottages.handmill_product) do
    unified_inventory.register_craft({
        output = product,
        type = "cottages_handmill",
        items = {input_name}
    })
end
