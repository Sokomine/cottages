---------------------------------------------------------------------------------------
-- furniture
---------------------------------------------------------------------------------------
-- contains:
--  * a bed seperated into foot and head reagion so that it can be placed manually; it has
--    no other functionality than decoration!
--  * a sleeping mat - mostly for NPC that cannot afford a bet yet
--  * bench - if you don't have 3dforniture:chair, then this is the next best thing
--  * table - very simple one
--  * shelf - for stroring things; this one is 3d
--  * stovepipe - so that the smoke from the furnace can get away
--  * washing place - put it over a water source and you can 'wash' yourshelf
---------------------------------------------------------------------------------------
-- TODO: change the textures of the bed (make the clothing white, foot path not entirely covered with cloth)

local S = cottages.S

-- a bed without functionality - just decoration
minetest.register_node("cottages:bed_foot", {
	description = S("Bed (foot region)"),
	drawtype = "nodebox",
	tiles = {"cottages_beds_bed_top_bottom.png", cottages.texture_furniture,  "cottages_beds_bed_side.png",  "cottages_beds_bed_side.png",  "cottages_beds_bed_side.png",  "cottages_beds_bed_side.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,animates_player=1},
	sounds = cottages.sounds.wood,
	node_box = {
		type = "fixed",
		fixed = {
					-- bed
					{-0.5, 0.0, -0.5, 0.5, 0.3, 0.5},
					
					-- stützen
					{-0.5, -0.5, -0.5, -0.4, 0.5, -0.4},
					{  0.4,-0.5, -0.5, 0.5,  0.5, -0.4},
                               
                                        -- Querstrebe
					{-0.4,  0.3, -0.5, 0.4, 0.5, -0.4}
				}
	},
	selection_box = {
		type = "fixed",
		fixed = {
					{-0.5, -0.5, -0.5, 0.5, 0.3, 0.5},
				}
	},
	is_ground_content = false,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				return cottages.sleep_in_bed( pos, node, clicker, itemstack, pointed_thing );
			end
})

-- the bed is split up in two parts to avoid destruction of blocks on placement
minetest.register_node("cottages:bed_head", {
	description = S("Bed (head region)"),
	drawtype = "nodebox",
	tiles = {"cottages_beds_bed_top_top.png", cottages.texture_furniture,  "cottages_beds_bed_side_top_r.png",  "cottages_beds_bed_side_top_l.png",  cottages.texture_furniture,  "cottages_beds_bed_side.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,animates_player=1},
	sounds = cottages.sounds.wood,
	node_box = {
		type = "fixed",
		fixed = {
					-- bed
					{-0.5, 0.0, -0.5, 0.5, 0.3, 0.5},
					
					-- stützen
					{-0.5,-0.5, 0.4, -0.4, 0.5, 0.5},
					{ 0.4,-0.5, 0.4,  0.5, 0.5, 0.5},

                                        -- Querstrebe
					{-0.4,  0.3,  0.4, 0.4, 0.5,  0.5}
				}
	},
	selection_box = {
		type = "fixed",
		fixed = {
					{-0.5, -0.5, -0.5, 0.5, 0.3, 0.5},
				}
	},
	is_ground_content = false,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				return cottages.sleep_in_bed( pos, node, clicker, itemstack, pointed_thing );
			end
})


-- the basic version of a bed - a sleeping mat
-- to facilitate upgrade path straw mat -> sleeping mat -> bed, this uses a nodebox
minetest.register_node("cottages:sleeping_mat", {
        description = S("sleeping mat"),
        drawtype = 'nodebox',
        tiles = { 'cottages_sleepingmat.png' }, -- done by VanessaE
        wield_image = 'cottages_sleepingmat.png',
        inventory_image = 'cottages_sleepingmat.png',
        sunlight_propagates = true,
        paramtype = 'light',
        paramtype2 = "facedir",
        walkable = false,
        groups = { snappy = 3, sleeping_mat = 1, animates_player = 1},
	sounds = cottages.sounds.leaves,
        selection_box = {
                        type = "wallmounted",
                        },
        node_box = {
                type = "fixed",
                fixed = {
                                        {-0.48, -0.5,-0.48,  0.48, -0.5+1/16, 0.48},
                        }
        },
        selection_box = {
                type = "fixed",
                fixed = {
                                        {-0.48, -0.5,-0.48,  0.48, -0.5+2/16, 0.48},
                        }
        },
	is_ground_content = false,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				return cottages.sleep_in_bed( pos, node, clicker, itemstack, pointed_thing );
			end
})


-- this one has a pillow for the head; thus, param2 becomes visible to the builder, and mobs may use it as a bed
minetest.register_node("cottages:sleeping_mat_head", {
        description = S("sleeping mat with pillow"),
        drawtype = 'nodebox',
        tiles = { 'cottages_sleepingmat.png' }, -- done by VanessaE
        wield_image = 'cottages_sleepingmat.png',
        inventory_image = 'cottages_sleepingmat.png',
        sunlight_propagates = true,
        paramtype = 'light',
        paramtype2 = "facedir",
        groups = { snappy = 3, sleeping_mat = 1, animates_player = 1 },
	sounds = cottages.sounds.leaves,
        node_box = {
                type = "fixed",
                fixed = {
                                        {-0.48, -0.5,-0.48,  0.48, -0.5+1/16, 0.48},
                                        {-0.34, -0.5+1/16,-0.12,  0.34, -0.5+2/16, 0.34},
                        }
        },
        selection_box = {
                type = "fixed",
                fixed = {
                                        {-0.48, -0.5,-0.48,  0.48, -0.5+2/16, 0.48},
                        }
        },
	is_ground_content = false,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				return cottages.sleep_in_bed( pos, node, clicker, itemstack, pointed_thing );
			end
})


-- furniture; possible replacement: 3dforniture:chair
minetest.register_node("cottages:bench", {
	drawtype = "nodebox",
	description = S("simple wooden bench"),
	tiles = {"cottages_minimal_wood.png", "cottages_minimal_wood.png",  "cottages_minimal_wood.png",  "cottages_minimal_wood.png",  "cottages_minimal_wood.png",  "cottages_minimal_wood.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=3,animates_player=1},
	sounds = cottages.sounds.wood,
	node_box = {
		type = "fixed",
		fixed = {
					-- sitting area
					{-0.5, -0.15, 0.1,  0.5,  -0.05, 0.5},
					
					-- stützen
					{-0.4, -0.5,  0.2, -0.3, -0.15, 0.4},
					{ 0.3, -0.5,  0.2,  0.4, -0.15, 0.4},
				}
	},
	selection_box = {
		type = "fixed",
		fixed = {
					{-0.5, -0.5, 0, 0.5, 0, 0.5},
				}
	},
	is_ground_content = false,
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				return cottages.sit_on_bench( pos, node, clicker, itemstack, pointed_thing );
			end,
})


-- a simple table; possible replacement: 3dforniture:table
local cottages_table_def = {
		description = S("table"),
		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		tiles = {"cottages_minimal_wood.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.1, -0.5, -0.1,  0.1, 0.3,  0.1},
				{ -0.5,  0.48, -0.5,  0.5, 0.4,  0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.4,  0.5},
			},
		},
		is_ground_content = false,
}


-- search for the workbench in AdventureTest
local workbench = minetest.registered_nodes[ "workbench:3x3"];
if( workbench ) then
	cottages_table_def.tiles        = {workbench.tiles[1], cottages_table_def.tiles[1]};
	cottages_table_def.on_rightclick = workbench.on_rightclick;
end
-- search for the workbench from RealTEst
workbench = minetest.registered_nodes[ "workbench:work_bench_birch"];
if( workbench ) then
	cottages_table_def.tiles	= {workbench.tiles[1], cottages_table_def.tiles[1]};
	cottages_table_def.on_construct = workbench.on_construct;
	cottages_table_def.can_dig      = workbench.can_dig;
	cottages_table_def.on_metadata_inventory_take = workbench.on_metadata_inventory_take;
	cottages_table_def.on_metadata_inventory_move = workbench.on_metadata_inventory_move;
	cottages_table_def.on_metadata_inventory_put  = workbench.on_metadata_inventory_put;
end

minetest.register_node("cottages:table", cottages_table_def );

-- looks better than two slabs impersonating a shelf; also more 3d than a bookshelf 
-- the infotext shows if it's empty or not
minetest.register_node("cottages:shelf", {
		description = S("open storage shelf"),
		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		tiles = {"cottages_minimal_wood.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		node_box = {
			type = "fixed",
			fixed = {

 				{ -0.5, -0.5, -0.3, -0.4,  0.5,  0.5},
 				{  0.4, -0.5, -0.3,  0.5,  0.5,  0.5},

				{ -0.5, -0.2, -0.3,  0.5, -0.1,  0.5},
				{ -0.5,  0.3, -0.3,  0.5,  0.4,  0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.5,  0.5},
			},
		},

		on_construct = function(pos)

                	local meta = minetest.get_meta(pos);

			local spos = pos.x .. "," .. pos.y .. "," .. pos.z
	                meta:set_string("formspec",
                                "size[8,8]"..
                                "list[current_name;main;0,0;8,3;]"..
                                "list[current_player;main;0,4;8,4;]"..
				"listring[nodemeta:" .. spos .. ";main]" ..
				"listring[current_player;main]")
                	meta:set_string("infotext", S("open storage shelf"))
                	local inv = meta:get_inventory();
                	inv:set_size("main", 24);
        	end,

	        can_dig = function( pos,player )
	                local  meta = minetest.get_meta( pos );
	                local  inv = meta:get_inventory();
	                return inv:is_empty("main");
	        end,

                on_metadata_inventory_put  = function(pos, listname, index, stack, player)
	                local  meta = minetest.get_meta( pos );
                        meta:set_string('infotext', S('open storage shelf (in use)'));
                end,
                on_metadata_inventory_take = function(pos, listname, index, stack, player)
	                local  meta = minetest.get_meta( pos );
	                local  inv = meta:get_inventory();
	                if( inv:is_empty("main")) then
                           meta:set_string('infotext', S('open storage shelf (empty)'));
                        end
                end,
		is_ground_content = false,


})

-- so that the smoke from a furnace can get out of a building
minetest.register_node("cottages:stovepipe", {
		description = S("stovepipe"),
		drawtype = "nodebox",
		tiles = {"cottages_steel_block.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		node_box = {
			type = "fixed",
			fixed = {
				{  0.20, -0.5, 0.20,  0.45, 0.5,  0.45},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{  0.20, -0.5, 0.20,  0.45, 0.5,  0.45},
			},
		},
		is_ground_content = false,
})


-- this washing place can be put over a water source (it is open at the bottom)
minetest.register_node("cottages:washing", {
		description = S("washing place"),
		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		tiles = {"cottages_clay.png"},
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, -0.2, -0.2},

				{ -0.5, -0.5, -0.2, -0.4, 0.2,  0.5},
				{  0.4, -0.5, -0.2,  0.5, 0.2,  0.5},

				{ -0.4, -0.5,  0.4,  0.4, 0.2,  0.5},
				{ -0.4, -0.5, -0.2,  0.4, 0.2, -0.1},

			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.2,  0.5},
			},
		},
                on_rightclick = function(pos, node, player)
                   -- works only with water beneath
                   local node_under = minetest.get_node( {x=pos.x, y=(pos.y-1), z=pos.z} );
		   if( not( node_under ) or node_under.name == "ignore" or (node_under.name ~= 'default:water_source' and node_under.name ~= 'default:water_flowing')) then
                      minetest.chat_send_player( player:get_player_name(), S("Sorry. This washing place is out of water. Please place it above water!"));
		   else
                      minetest.chat_send_player( player:get_player_name(), S("You feel much cleaner after some washing."));
		   end
                end,
		is_ground_content = false,

})


---------------------------------------------------------------------------------------
-- functions for sitting or sleeping
---------------------------------------------------------------------------------------

cottages.allow_sit = function( player, pos )
	-- no check possible
	if not minetest.is_player(player) then
		return false;
	end

	local pname = player:get_player_name()

	local p_above = minetest.get_node( {x=pos.x, y=pos.y+1, z=pos.z});
	if( not( p_above) or not( p_above.name ) or p_above.name ~= 'air' ) then
		minetest.chat_send_player( pname, "This place is too narrow for sitting. At least for you!")
		return
	end

	local velo = player:get_player_velocity()
	local max_velo = 0.0001;
	if vector.length(velo) < max_velo then
		return true;
	end
	return false;
end

cottages.is_bed = function(pos, node)
	if node.name == "cottages:bed_head" then
		local second_pos = vector.subtract(pos, minetest.facedir_to_dir(node.param2))
		local second_node = minetest.get_node(second_pos)
		return second_node.name == "cottages:bed_foot", second_pos
	elseif node.name == "cottages:bed_foot" then
		local second_pos = vector.add(pos, minetest.facedir_to_dir(node.param2))
		local second_node = minetest.get_node(second_pos)
		return second_node.name == "cottages:bed_head", second_pos
	elseif minetest.get_item_group(node.name, "sleeping_mat") ~= 0 then
		local search_offsets = {
			vector.new(1, 0, 0),
			vector.new(-1, 0, 0),
			vector.new(0, 0, 1),
			vector.new(0, 0, -1)
		}
		for _, offset in ipairs(search_offsets) do
			local second_pos = vector.add(pos, offset)
			local second_node = minetest.get_node(second_pos)
			if minetest.get_item_group(second_node.name, "sleeping_mat") ~= 0 then
				return true, second_pos
			end
		end
	end
	return false
end


-- players might leave beds/benches in unintended ways (or other mods mess up with the logic)
-- we need to make sure they won't be stuck with their last animation
local attached_players = {}
local fix_player_animation_job

local function fix_player_animations(active_loop)
	if fix_player_animation_job and not active_loop then -- we already have a loop running
		return
	end
	local continue_looping = false
	for playername, last_pos in pairs(attached_players) do
		-- is the player still at the position where we expect him to be
		local player = minetest.get_player_by_name(playername)
		local player_pos = player and vector.round(player:get_pos())
		local same_position = player_pos and vector.equals(player_pos, last_pos)

		-- is the node still around (might be dug/whatever)
		local nodename = minetest.get_node(last_pos).name
		local node_animates_player = minetest.get_item_group(nodename, "animates_player") ~= 0
		
		if same_position and node_animates_player then
			continue_looping = true
		else
			if player then
				cottages.stand(player)
			end
			attached_players[playername] = nil
		end
	end
	if continue_looping then
		fix_player_animation_job = minetest.after(1, fix_player_animations, true)
	else
		fix_player_animation_job = nil
	end
end

cottages.stand = function (player)
	local pname = player:get_player_name()
	player_api.player_attached[pname] = false
	player:set_physics_override({speed = 1, jump = 1, gravity = 1})
	player_api.set_animation(player, "stand", 30)
	attached_players[pname] = nil
end

cottages.sit = function (player)
	local pname = player:get_player_name()
	player_api.set_animation(player, "sit", 30)
	player:set_physics_override({speed = 0, jump = 0, gravity = 0})
	player_api.player_attached[pname] = true
	attached_players[pname] = vector.round(player:get_pos())
	fix_player_animations()
end

cottages.lay = function (player)
	local pname = player:get_player_name()
	player_api.set_animation(player, "lay", 30)
	player:set_physics_override({speed = 0, jump = 0, gravity = 0})
	player_api.player_attached[pname] = true
	attached_players[pname] = vector.round(player:get_pos())
	fix_player_animations()
end

cottages.sit_on_bench = function( pos, node, clicker, itemstack, pointed_thing )
	if not(player_api and cottages.allow_sit(clicker, pos)) then
		return;
	end 

	local animation = player_api.get_animation(clicker)

	if (animation and animation.animation=="sit") then
		clicker:set_pos({x=pos.x,y=pos.y-0.5,z=pos.z})
		cottages.stand(clicker, pos)
	else
		-- the bench is not centered; prevent the player from sitting on air
		local offset = minetest.facedir_to_dir(node.param2)
		local p2 = vector.add(pos, vector.multiply(offset, 0.3))

		clicker:set_pos( p2 )
		cottages.sit(clicker)
	end
end

cottages.sleep_in_bed = function( pos, node, clicker, itemstack, pointed_thing )
	if not(player_api and cottages.allow_sit(clicker, pos)) then
		return;
	end

	local animation = player_api.get_animation(clicker)
	local pname = clicker:get_player_name()

	-- if only one node is present, the player can only sit;
	-- sleeping requires a bed head+foot or two sleeping mats
	local is_bed, second_pos = cottages.is_bed(pos, node)

	local player_pos = vector.copy(pos)
	local place_name = "place"
	if is_bed then
		player_pos = vector.divide(vector.add(pos, second_pos), 2)
	end
	if minetest.get_item_group(node.name, "sleeping_mat") ~= 0 then
		player_pos.y = player_pos.y - 0.5 + 1/16
		place_name = "mat"
	else
		player_pos.y = player_pos.y + 0.3
		place_name = "bed"
	end

	if is_bed then 
		if (animation and (animation.animation=="lay")) then -- let the player up
			clicker:set_pos({x=pos.x,y=pos.y-0.5,z=pos.z})
			cottages.stand(clicker)
			minetest.chat_send_player( pname, 'That was enough sleep for now. You stand up again.');
		elseif (animation and animation.animation=="sit") then
			clicker:set_pos( player_pos )
			cottages.lay(clicker)
			minetest.chat_send_player( pname, 'You lie down and take a nap. A right-click will wake you up.');
		else
			clicker:set_pos( player_pos )
			cottages.sit(clicker)
			minetest.chat_send_player( pname, 'Aaah! What a comftable '..place_name..'. A second right-click will let you sleep.');
		end
	else
		if (animation and animation.animation=="sit") then -- let the player up
			clicker:set_pos({x=pos.x,y=pos.y-0.5,z=pos.z})
			cottages.stand(clicker)
			minetest.chat_send_player( pname, 'That was enough sitting around for now. You stand up again.')
		else
			clicker:set_pos( player_pos )
			cottages.sit(clicker)
			minetest.chat_send_player( pname, 'Comftable, but not good enough for a nap. Right-click again if you want to get back up.');
		end
	end
end

---------------------------------------------------------------------------------------
-- crafting receipes
---------------------------------------------------------------------------------------
minetest.register_craft({
	output = "cottages:bed_foot",
	recipe = {
		{cottages.craftitem_wool,    "", "", },
		{cottages.craftitem_wood,  "", "", },
		{cottages.craftitem_stick, "", "", }
	}
})

minetest.register_craft({
	output = "cottages:bed_head",
	recipe = {
		{"", "",              cottages.craftitem_wool, },
		{"", cottages.craftitem_stick, cottages.craftitem_wood, },
		{"", "",              cottages.craftitem_stick, }
	}
})

minetest.register_craft({
	output = "cottages:sleeping_mat 3",
	recipe = {
		{"cottages:wool_tent", "cottages:straw_mat","cottages:straw_mat" }
	}
})


minetest.register_craft({
	output = "cottages:sleeping_mat_head",
	recipe = {
		{"cottages:sleeping_mat","cottages:straw_mat" }
	}
})

minetest.register_craft({
	output = "cottages:table",
	recipe = {
		{"", cottages.craftitem_slab_wood, "", },
		{"", cottages.craftitem_stick, "" }
	}
})

minetest.register_craft({
	output = "cottages:bench",
	recipe = {
		{"",              cottages.craftitem_wood, "", },
		{cottages.craftitem_stick, "",             cottages.craftitem_stick, }
	}
})


minetest.register_craft({
	output = "cottages:shelf",
	recipe = {
		{cottages.craftitem_stick,  cottages.craftitem_wood, cottages.craftitem_stick, },
		{cottages.craftitem_stick, cottages.craftitem_wood, cottages.craftitem_stick, },
		{cottages.craftitem_stick, "",             cottages.craftitem_stick}
	}
})

minetest.register_craft({
	output = "cottages:washing 2",
	recipe = {
		{cottages.craftitem_stick, },
		{cottages.craftitem_clay,  },
	}
})

minetest.register_craft({
	output = "cottages:stovepipe 2",
	recipe = {
		{cottages.craftitem_steel, '', cottages.craftitem_steel},
	}
})
