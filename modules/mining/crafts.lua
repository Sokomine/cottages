local ci = cottages.craftitems

if ci.cotton then
	minetest.register_craft({
		output = "cottages:rope",
		recipe = {
			{ci.cotton, ci.cotton, ci.cotton}
		}
	})
end

if ci.ladder and ci.rail then
	minetest.register_craft({
		output = "cottages:ladder_with_rope_and_rail 3",
		recipe = {
			{ci.ladder, "cottages:rope", ci.rail}
		}
	})
end
