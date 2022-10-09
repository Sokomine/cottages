local api = cottages.anvil

function api.make_unrepairable(itemstring)
	local def = minetest.registered_items[itemstring]
	local groups = table.copy(def.groups or {})
	groups.not_repaired_by_anvil = 1
	minetest.override_item(itemstring, {groups = groups})
end

function api.can_repair(tool_stack)
	if type(tool_stack) == "string" then
		tool_stack = ItemStack(tool_stack)
	end
	return tool_stack:is_known() and minetest.get_item_group(tool_stack:get_name(), "not_repaired_by_anvil") == 0
end
