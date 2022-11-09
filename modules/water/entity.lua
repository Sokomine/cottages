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

	get_staticdata = function(self)
		-- note: static_save is false, so this won't get called, but i may revise that decision
		return self.object:get_properties().wield_item
	end,

	on_activate = function(self, staticdata, dtime_s)
		if not staticdata or staticdata == "" then
			self.object:remove()
			return
		end

		local obj = self.object

		obj:set_properties({wield_item = staticdata})
		obj:set_armor_groups({immortal = 1})
	end,

	on_punch = function()
		return true
	end,

	on_blast = function(self, damage)
		return false, false, {}
	end,
})
