local ci = cottages.craftitems

if ci.wool and ci.wood and ci.stick then
	minetest.register_craft({
		output = "cottages:bed_foot",
		recipe = {
			{ci.wool, "", "", },
			{ci.wood, "", "", },
			{ci.stick, "", "", }
		}
	})

	minetest.register_craft({
		output = "cottages:bed_head",
		recipe = {
			{"", "", ci.wool, },
			{"", ci.stick, ci.wood, },
			{"", "", ci.stick, }
		}
	})
end

minetest.register_craft({
	output = "cottages:sleeping_mat 3",
	recipe = {
		{"cottages:wool_tent", "cottages:straw_mat", "cottages:straw_mat"}
	}
})

minetest.register_craft({
	output = "cottages:sleeping_mat_head",
	recipe = {
		{"cottages:sleeping_mat", "cottages:straw_mat"}
	}
})

if ci.stick and ci.slab_wood then
	minetest.register_craft({
		output = "cottages:table",
		recipe = {
			{"", ci.slab_wood, "", },
			{"", ci.stick, ""}
		}
	})
end

minetest.register_craft({
	output = "cottages:bench",
	recipe = {
		{"", ci.wood, "", },
		{ci.stick, "", ci.stick, }
	}
})

if ci.stick and ci.wood then
	minetest.register_craft({
		output = "cottages:shelf",
		recipe = {
			{ci.stick, ci.wood, ci.stick, },
			{ci.stick, ci.wood, ci.stick, },
			{ci.stick, "", ci.stick}
		}
	})
end

if ci.stick and ci.clay then
	minetest.register_craft({
		output = "cottages:washing 2",
		recipe = {
			{ci.stick, },
			{ci.clay, },
		}
	})
end

if ci.steel then
	minetest.register_craft({
		output = "cottages:stovepipe 2",
		recipe = {
			{ci.steel, "", ci.steel},
		}
	})
end
