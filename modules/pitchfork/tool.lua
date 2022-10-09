local S = cottages.S

local has_stamina = cottages.has.stamina
local stamina_use = cottages.settings.pitchfork.stamina

minetest.register_node("cottages:pitchfork", {
	description = S("Pitchfork (dig dirt with grass to get hay, place with right-click)"),
	short_description = S("Pitchfork"),
	inventory_image = "cottages_pitchfork.png",
	wield_image = "cottages_pitchfork.png^[transformFYR180",
	wield_scale = {x = 1.5, y = 1.5, z = 0.5},
	stack_max = 1,
	liquids_pointable = false,

	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {times={[2]=3.00, [3]=0.70}, maxlevel = 1, uses = 0, punch_attack_uses = 0, },
			snappy = {times = {[2] = 0.40, [3] = 0.20}, maxlevel = 1, uses = 0, punch_attack_uses = 0, },
			hay = {times = {[2] = 0.10, [3] = 0.10}, maxlevel = 1, uses = 0, punch_attack_uses = 0, },
		},
		damage_groups = {fleshy = 5}, -- slightly stronger than a stone sword
	},

	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = false,
	drop = "cottages:pitchfork",

	groups = {snappy = 2, dig_immediate = 3, falling_node = 1, attached_node = 1},

	sounds = cottages.sounds.wood,

	visual_scale = 1.0,
	tiles = {"default_wood.png^[transformR90"},
	special_tiles = {},
	post_effect_color = {a=0, r=0, g=0, b=0},
	node_box = {
		type = "fixed",
		fixed = {
			-- handle (goes a bit into the ground)
			{-(1 / 32), -(11 / 16), -(1 / 32), (1 / 32), 16 / 16, (1 / 32)},
			-- middle connection
			{-(7 / 32), -(4 / 16), -(1 / 32), (7 / 32), -(2 / 16), (1 / 32)},
			-- thongs
			{-(7 / 32), -(11 / 16), -(1 / 32), -(5 / 32), -(4 / 16), (1 / 32)},
			{(5 / 32), -(11 / 16), -(1 / 32), (7 / 32), -(4 / 16), (1 / 32)},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.1, 0.3, 1.0, 0.1}
	},
})

local function override_on_dig(node_name, replacement)
	local node_def = minetest.registered_nodes[node_name]

	if not node_def and minetest.registered_nodes[replacement] then
		return
	end

	local old_on_dig = node_def.on_dig

	minetest.override_item(node_name, {
		on_dig = function(pos, node, digger)
			if not minetest.is_player(digger) then
				return old_on_dig(pos, node, digger)
			end

			local wielded = digger:get_wielded_item()

			if wielded:get_name() ~= "cottages:pitchfork" then
				return old_on_dig(pos, node, digger)
			end

			local digger_name = digger:get_player_name()
			if minetest.is_protected(pos, digger_name) then
				return old_on_dig(pos, node, digger)
			end

			local pos_above = vector.add(pos, {x=0, y=1, z=0})
			local node_above = minetest.get_node(pos_above)

			if minetest.is_protected(pos_above, digger_name) or node_above.name ~= "air" then
				return old_on_dig(pos, node, digger)
			end

			minetest.swap_node(pos, {name = replacement})
			minetest.swap_node(pos_above, {name = "cottages:hay_mat", param2 = math.random(2, 25)})

			if has_stamina then
				stamina.exhaust_player(digger, stamina_use, "cottages:pitchfork")
			end

			return true
		end,
	})
end

override_on_dig("default:dirt_with_grass", "default:dirt")

minetest.register_alias("cottages:pitchfork_placed", "cottages:pitchfork")
