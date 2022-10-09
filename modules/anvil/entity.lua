local anvil = cottages.anvil

local deserialize = minetest.deserialize
local serialize = minetest.serialize

minetest.register_entity("cottages:anvil_item", {
	hp_max = 1,
	visual = "wielditem",
	visual_size = {x = .33, y = .33},
	collisionbox = {0, 0, 0, 0, 0, 0},
	physical = false,

	get_staticdata = function(self)
		return serialize({self.pos, self.item})
	end,

	on_activate = function(self, staticdata, dtime_s)
		local pos, item = unpack(deserialize(staticdata))
		local obj = self.object

		if not (pos and item and minetest.get_node(pos).name == "cottages:anvil") then
			obj:remove()
			return
		end

		self.pos = pos  -- *MUST* set before calling api.get_entity

		local other_obj = anvil.get_entity(pos)
		if other_obj and obj ~= other_obj then
			obj:remove()
			return
		end

		self.item = item

		obj:set_properties({wield_item = item})
	end,
})

if cottages.settings.anvil.tool_entity_enabled then
	-- automatically restore entities lost due to /clearobjects or similar
	if cottages.has.node_entity_queue then
		node_entity_queue.api.register_node_entity_loader("cottages:anvil", anvil.update_entity)

	else
		minetest.register_lbm({
			name = "cottages:anvil_item_restoration",
			nodenames = {"cottages:anvil"},
			run_at_every_load = true,
			action = function(pos, node, active_object_count, active_object_count_wider)
				anvil.update_entity(pos)
			end,
		})
	end

else
	minetest.register_lbm({
		name = "cottages:anvil_item_removal",
		nodenames = {"cottages:anvil"},
		run_at_every_load = true,
		action = function(pos, node, active_object_count, active_object_count_wider)
			anvil.clear_entity(pos)
		end,
	})
end
