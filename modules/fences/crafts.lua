local ci = cottages.craftitems

if ci.fence then
	minetest.register_craft({
		output = "cottages:fence_small 3",
		recipe = {
			{ci.fence, ci.fence},
		}
	})
end

-- xfences can be configured to replace normal fences - which makes them uncraftable
if minetest.get_modpath("xfences") then
	minetest.register_craft({
		output = "cottages:fence_small 3",
		recipe = {
			{"xfences:fence", "xfences:fence"},
		}
	})
end

minetest.register_craft({
	output = "cottages:fence_corner",
	recipe = {
		{"cottages:fence_small", "cottages:fence_small"},
	}
})

minetest.register_craft({
	output = "cottages:fence_small 2",
	recipe = {
		{"cottages:fence_corner"},
	}
})

minetest.register_craft({
	output = "cottages:fence_end",
	recipe = {
		{"cottages:fence_small", "cottages:fence_small", "cottages:fence_small"},
	}
})

minetest.register_craft({
	output = "cottages:fence_small 3",
	recipe = {
		{"cottages:fence_end"},
	}
})
