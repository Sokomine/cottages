-- search for the workbench from RealTest
local workbench = minetest.registered_nodes["workbench:work_bench_birch"]

if workbench then
	local cottages_table_def = minetest.registered_nodes["cottages:table"]

	minetest.override_item("cottages:table", {
		tiles = {workbench.tiles[1], cottages_table_def.tiles[1]},
		on_construct = workbench.on_construct,
		can_dig = workbench.can_dig,
		on_metadata_inventory_take = workbench.on_metadata_inventory_take,
		on_metadata_inventory_move = workbench.on_metadata_inventory_move,
		on_metadata_inventory_put = workbench.on_metadata_inventory_put,
	})
end
