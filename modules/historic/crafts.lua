local ci = cottages.craftitems

if ci.iron and ci.stick and ci.steel then
	minetest.register_craft({
		output = "cottages:wagon_wheel 3",
		recipe = {
			{ci.iron, ci.stick, ci.iron},
			{ci.stick, ci.steel, ci.stick},
			{ci.iron, ci.stick, ci.iron}
		}
	})
end

if ci.sand and ci.clay then
	minetest.register_craft({
		output = "cottages:loam 4",
		recipe = {
			{ci.sand},
			{ci.clay}
		}
	})
end

minetest.register_craft({
	output = "cottages:straw_ground 2",
	recipe = {
		{"cottages:straw_mat"},
		{"cottages:loam"}
	}
})

if ci.stick and ci.glass then
	minetest.register_craft({
		output = "cottages:glass_pane 4",
		recipe = {
			{ci.stick, ci.stick, ci.stick},
			{ci.stick, ci.glass, ci.stick},
			{ci.stick, ci.stick, ci.stick}
		}
	})
end

minetest.register_craft({
	output = "cottages:glass_pane_side",
	recipe = {
		{"cottages:glass_pane"},
	}
})

minetest.register_craft({
	output = "cottages:glass_pane",
	recipe = {
		{"cottages:glass_pane_side"},
	}
})

if ci.stick and ci.string then
	minetest.register_craft({
		output = "cottages:wood_flat 16",
		recipe = {
			{ci.stick, ci.string, ci.stick},
			{ci.stick, "", ci.stick},
		}
	})
end

if ci.stick then
	minetest.register_craft({
		output = "cottages:wool_tent 2",
		recipe = {
			{ci.string, ci.string},
			{"", ci.stick}
		}
	})
end

minetest.register_craft({
	output = "cottages:wool",
	recipe = {
		{"cottages:wool_tent", "cottages:wool_tent"}
	}
})
