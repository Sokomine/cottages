local S = cottages.S

minetest.register_node("cottages:rope", {
	description = S("Rope"),
	tiles = {"cottages_rope.png"},
	groups = {
		snappy = 3, choppy = 3, oddly_breakable_by_hand = 3,
	},
	walkable = false,
	climbable = true,
	paramtype = "light",
	sunlight_propagates = true,
	drawtype = "plantlike",
	is_ground_content = false,
	can_dig = function(pos, player)
		local below = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})

		if below.name == "cottages:rope" then
			if minetest.is_player(player) then
				minetest.chat_send_player(
					player:get_player_name(),
					S("The entire rope would be too heavy. Start digging at its lowest end!")
				)
			end
			return false
		end
		return true
	end
})

if cottages.has.carts then
	carts:register_rail("cottages:ladder_with_rope_and_rail", {
		description = S("Ladder with \"rail support\""),
		tiles = {
			"default_ladder_wood.png^carts_rail_straight.png^cottages_rope.png"
		},
		inventory_image = "default_ladder_wood.png",
		wield_image = "default_ladder_wood.png",
		groups = carts:get_rail_groups(),
		sounds = cottages.sounds.wood,
		paramtype2 = "wallmounted",
		legacy_wallmounted = true,
	}, {})

else
	minetest.register_node("cottages:ladder_with_rope_and_rail", {
		description = S("Ladder with \"rail support\""),
		inventory_image = "default_ladder_wood.png",
		wield_image = "default_ladder_wood.png",
		drawtype = "raillike",
		tiles = {
			"default_ladder_wood.png^carts_rail_straight.png^cottages_rope.png"
		},
		paramtype = "light",
		paramtype2 = "wallmounted",
		sunlight_propagates = true,
		walkable = false,
		climbable = true,
		is_ground_content = false,
		selection_box = {
			type = "wallmounted",
		},
		groups = {
			choppy = 2, oddly_breakable_by_hand = 3, rail = 1,
			connect_to_raillike = minetest.raillike_group("rail"),
		},
		legacy_wallmounted = true,
		sounds = cottages.sounds.wood,
	})
end
