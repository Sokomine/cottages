local has = cottages.has

local check_exists = futil.check_exists

local textures = {}

if has.default then
	textures.furniture = "default_wood.png"
	textures.roof_sides = "default_wood.png"
	textures.stick = "default_stick.png"
	textures.roof_wood = "default_tree.png"
	textures.tree = "default_tree.png"
	textures.tree_top = "default_tree_top.png"
	textures.dust = "default_item_smoke.png"

else
	textures.furniture = "cottages_minimal_wood.png"
	textures.roof_sides = "cottages_minimal_wood.png"
	textures.stick = "cottages_minimal_wood.png"
	textures.roof_wood = "cottages_minimal_wood.png"
	textures.tree = "cottages_minimal_wood.png"
	textures.tree_top = "cottages_minimal_wood.png"
end

textures.straw = "cottages_darkage_straw.png"

if has.farming then
	textures.wheat_seed = "farming_wheat_seed.png"
	textures.wheat = "farming_wheat.png"

	if cottages.settings.roof.use_farming_straw_stairs and check_exists("farming:straw") then
		textures.straw = "farming_straw.png"
	end
end

cottages.textures = textures
