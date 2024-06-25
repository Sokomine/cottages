if cottages.has.technic then
	-- make rechargeable technic tools unrepairable`
	cottages.anvil.make_unrepairable("technic:water_can")
	cottages.anvil.make_unrepairable("technic:lava_can")
	cottages.anvil.make_unrepairable("technic:flashlight")
	cottages.anvil.make_unrepairable("technic:battery")
	cottages.anvil.make_unrepairable("technic:vacuum")
	cottages.anvil.make_unrepairable("technic:prospector")
	cottages.anvil.make_unrepairable("technic:sonic_screwdriver")
	cottages.anvil.make_unrepairable("technic:chainsaw")
	cottages.anvil.make_unrepairable("technic:laser_mk1")
	cottages.anvil.make_unrepairable("technic:laser_mk2")
	cottages.anvil.make_unrepairable("technic:laser_mk3")
	cottages.anvil.make_unrepairable("technic:mining_drill")
	cottages.anvil.make_unrepairable("technic:mining_drill_mk2")
	cottages.anvil.make_unrepairable("technic:mining_drill_mk2_1")
	cottages.anvil.make_unrepairable("technic:mining_drill_mk2_2")
	cottages.anvil.make_unrepairable("technic:mining_drill_mk2_3")
	cottages.anvil.make_unrepairable("technic:mining_drill_mk2_4")
	cottages.anvil.make_unrepairable("technic:mining_drill_mk3")
	cottages.anvil.make_unrepairable("technic:mining_drill_mk3_1")
	cottages.anvil.make_unrepairable("technic:mining_drill_mk3_2")
	cottages.anvil.make_unrepairable("technic:mining_drill_mk3_3")
	cottages.anvil.make_unrepairable("technic:mining_drill_mk3_4")
	cottages.anvil.make_unrepairable("technic:mining_drill_mk3_5")
end

if cottages.has.anvil then
	minetest.clear_craft({ output = "anvil:anvil" })
	minetest.register_alias_force("anvil:anvil", "cottages:anvil")
	minetest.clear_craft({ output = "anvil:hammer" })
	minetest.register_alias_force("anvil:hammer", "cottages:hammer")
else
	minetest.register_alias("anvil:anvil", "cottages:anvil")
	minetest.register_alias("anvil:hammer", "cottages:hammer")
end
