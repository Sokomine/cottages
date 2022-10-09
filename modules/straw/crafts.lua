local ci = cottages.craftitems

minetest.register_craft({
	output = "cottages:straw_mat 6",
	recipe = {
		{ci.stone, "", ""},
		{"farming:wheat", "farming:wheat", "farming:wheat", },
	},
	replacements = {{ci.stone, ci.seed_wheat .. " 3"}},
})

-- this is a better way to get straw mats
minetest.register_craft({
	output = "cottages:threshing_floor",
	recipe = {
		{ci.junglewood, ci.chest_locked, ci.junglewood, },
		{ci.junglewood, ci.stone, ci.junglewood, },
	},
})

-- and a way to turn wheat seeds into flour
minetest.register_craft({
	output = "cottages:quern",
	recipe = {
		{ci.stick, ci.stone, "", },
		{"", ci.steel, "", },
		{"", ci.stone, "", },
	},
})

minetest.register_craft({
	output = "cottages:straw_bale",
	recipe = {
		{"cottages:straw_mat"},
		{"cottages:straw_mat"},
		{"cottages:straw_mat"},
	},
})

minetest.register_craft({
	output = "cottages:straw",
	recipe = {
		{"cottages:straw_bale"},
	},
})

minetest.register_craft({
	output = "cottages:straw_bale",
	recipe = {
		{"cottages:straw"},
	},
})

minetest.register_craft({
	output = "cottages:straw_mat 3",
	recipe = {
		{"cottages:straw_bale"},
	},
})

---------------------------------

if ci.flour then
	if ci.seed_barley then
		cottages.straw.register_quern_craft({input = ci.seed_barley, output = ci.flour})
	end
	if ci.seed_oat then
		cottages.straw.register_quern_craft({input = ci.seed_oat, output = ci.flour})
	end
	if ci.seed_rye then
		cottages.straw.register_quern_craft({input = ci.seed_rye, output = ci.flour})
	end
	if ci.seed_wheat then
		cottages.straw.register_quern_craft({input = ci.seed_wheat, output = ci.flour})
	end
end

if ci.rice and ci.rice_flour then
	cottages.straw.register_quern_craft({input = ci.rice, output = ci.rice_flour})
end

if ci.barley and ci.seed_barley then
	cottages.straw.register_threshing_craft({input = ci.barley, output = {ci.seed_barley, ci.straw_mat}})
end
if ci.oat and ci.seed_oat then
	cottages.straw.register_threshing_craft({input = ci.oat, output = {ci.seed_oat, ci.straw_mat}})
end
if ci.rye and ci.seed_rye then
	cottages.straw.register_threshing_craft({input = ci.rye, output = {ci.seed_rye, ci.straw_mat}})
end
if ci.wheat and ci.seed_wheat then
	cottages.straw.register_threshing_craft({input = ci.wheat, output = {ci.seed_wheat, ci.straw_mat}})
end
