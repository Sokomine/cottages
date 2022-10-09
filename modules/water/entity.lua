local ci = cottages.craftitems

minetest.register_entity("cottages:bucket_entity", {
	initial_properties = {
		visual = "wielditem",
		automatic_rotate = 1,
		wield_item = ci.bucket,
		visual_size = {x = 0.33, y = 0.33},
		collisionbox = {0, 0, 0, 0, 0, 0},
		pointable = false,
		physical = false,
		static_save = false,
	},
})
