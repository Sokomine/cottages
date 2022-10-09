-- search for the workbench in AdventureTest
local workbench = minetest.registered_nodes["workbench:3x3"]
if workbench then
	local cottages_table_def = minetest.registered_nodes["cottages:table"]

	minetest.override_item("cottages:table", {
		tiles = {workbench.tiles[1], cottages_table_def.tiles[1]},
		on_rightclick = workbench.on_rightclick
	})
end
