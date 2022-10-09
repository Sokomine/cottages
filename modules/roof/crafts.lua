local ci = cottages.craftitems

minetest.register_craft({
	output = "cottages:reet",
	recipe = {{ci.papyrus, ci.papyrus},
	          {ci.papyrus, ci.papyrus},
	},
})

minetest.register_craft({
	output = "cottages:slate_vertical",
	recipe = {{ci.stone, ci.wood}}
})
