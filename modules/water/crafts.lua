local ci = cottages.craftitems

if ci.stick and ci.tree and ci.stick and ci.bucket then
	minetest.register_craft({
		output = "cottages:water_gen",
		recipe = {
			{ci.stick, "", ""},
			{ci.tree, ci.bucket, ci.tree},
			{ci.tree, ci.tree, ci.tree},
		}
	})
end
