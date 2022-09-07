---------------------------------------------------------------------------------------
-- decoration and building material
---------------------------------------------------------------------------------------
-- * includes a wagon wheel that can be used as decoration on walls or to build (stationary) wagons
-- * dirt road - those are more natural in small old villages than cobble roads
-- * loam - no, old buildings are usually not built out of clay; loam was used
-- * straw - useful material for roofs
-- * glass pane - an improvement compared to fence posts as windows :-)
---------------------------------------------------------------------------------------

local S = cottages.S

-- supported modes:
-- * simple: only a straight dirt road; no curves, junctions etc.
-- * flat: each node is a full node; junction, t-junction and corner are included
-- * nodebox: like flat - except that each node has a nodebox that fits to that road node
-- * mesh: like nodebox - except that it uses a nice roundish model
local cottages_feldweg_mode = minetest.settings:get("cottages_feldweg_mode")
if(     cottages_feldweg_mode ~= "mesh"
    and cottages_feldweg_mode ~= "flat"
    and cottages_feldweg_mode ~= "nodebox"
    and cottages_feldweg_mode ~= "mesh_incl_45") then
	cottages_feldweg_mode = "mesh";
    -- add the setting to the minetest.conf so that the player can set it there
    minetest.settings:set("cottages_feldweg_mode", "mesh")
end


local function register_recipes(include_end, postfix, base_craftitem)
	
	if(not(postfix)) then
		postfix = ""
	end
	if(not(base_craftitem)) then
		base_craftitem = cottages.craftitem_dirt
	end
	local base_node = "cottages:feldweg"..postfix

	-- run a wagon wheel over dirt :-)
	minetest.register_craft({
		output = "cottages:feldweg"..postfix.." 4",
		recipe = {
			{"", "cottages:wagon_wheel", "" },
			{base_craftitem, base_craftitem, base_craftitem}
		},
	        replacements = { {'cottages:wagon_wheel', 'cottages:wagon_wheel'}, }
	})


	minetest.register_craft({
		output = "cottages:feldweg_crossing"..postfix.." 5",
		recipe = {
			{"", base_node, "" },
			{base_node, base_node, base_node},
			{"", base_node, "" },
		},
	})
	                                          
	minetest.register_craft({
		output = "cottages:feldweg_t_junction"..postfix.." 5",
		recipe = {
			{"", base_node, "" },
			{"", base_node, "" },
			{base_node, base_node, base_node}
			
		},
	})										
	             
	minetest.register_craft({
		output = "cottages:feldweg_curve"..postfix.." 5",
		recipe = {
			{base_node, "", "" },
			{base_node, "", ""},
			{base_node, base_node, base_node}
		},
	})									                                       
	               
	if include_end then
		minetest.register_craft({
			output = "cottages:feldweg_end"..postfix.." 5",
			recipe = {
				{base_node, "", base_node },
				{base_node, base_node, base_node}
			},
		})	
	end

	-- if the 45 degree version is loaded
	if(minetest.registered_nodes["cottages:feldweg_45"..postfix]) then
	    minetest.register_craft({
		output = "cottages:feldweg_45"..postfix,
		recipe = {{base_node}}
	    })
	    minetest.register_craft({
		output = "cottages:feldweg_l_curve"..postfix,
		recipe = {{"cottages:feldweg_45"..postfix}}
	    })
	    minetest.register_craft({
		output = "cottages:feldweg_r_curve"..postfix,
		recipe = {{"cottages:feldweg_l_curve"..postfix}}
	    })
	    minetest.register_craft({
		output = "cottages:feldweg_s_45"..postfix,
		recipe = {{"cottages:feldweg_r_curve"..postfix}}
	    })
	    minetest.register_craft({
		output = "cottages:feldweg_d_45"..postfix,
		recipe = {{"cottages:feldweg_s_45"..postfix}}
	    })
	    minetest.register_craft({
		output = "cottages:feldweg"..postfix,
		recipe = {{"cottages:feldweg_d_45"..postfix}}
	    })
	end
end


-- those can be offered in diffrent variants...
cottages.register_nodes_mesh = function(postfix, texture_top, texture_bottom, texture_side, cottages_feldweg_mode, name_postfix)
	-- a nice dirt road for small villages or paths to fields
	minetest.register_node("cottages:feldweg"..postfix, {
		description = S("dirt road"..name_postfix),
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,
		tiles = {"cottages_feldweg_end.png",
			-- "default_dirt.png^default_grass_side.png", "default_dirt.png", "default_grass.png",
			texture_side, texture_bottom, texture_top,
			"cottages_feldweg_surface.png",
			"cottages_feldweg_surface.png^cottages_feldweg_edges.png"},
		paramtype = "light",
		drawtype = "mesh",
		mesh = "feldweg.obj",
	})


	minetest.register_node("cottages:feldweg_crossing"..postfix, {
		description = S("dirt road crossing"..name_postfix),
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,
		tiles = {"cottages_feldweg_end.png",
			--"default_dirt.png", "default_grass.png",
			texture_bottom, texture_top,
			"cottages_feldweg_surface.png",
			"cottages_feldweg_surface.png^cottages_feldweg_edges.png"},
		paramtype = "light",
		drawtype = "mesh",
		mesh = "feldweg-crossing.obj",
	})

	minetest.register_node("cottages:feldweg_t_junction"..postfix, {
		description = S("dirt road t junction"..name_postfix),
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,
		tiles = {"cottages_feldweg_end.png",
			-- "default_dirt.png^default_grass_side.png", "default_dirt.png", "default_grass.png",
			texture_side, texture_bottom, texture_top,
			"cottages_feldweg_surface.png",
			"cottages_feldweg_surface.png^cottages_feldweg_edges.png"},
		paramtype = "light",
		drawtype = "mesh",
		mesh = "feldweg-T-junction.obj",
	})

	minetest.register_node("cottages:feldweg_curve"..postfix, {
		description = S("dirt road curve"..name_postfix),
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,
		tiles = {
			-- "default_dirt.png^default_grass_side.png","default_grass.png",
			texture_side, texture_top,
			-- "default_dirt.png^default_grass_side.png",
			texture_side,
			"cottages_feldweg_surface.png",
			-- "default_dirt.png",
			texture_bottom,
			"cottages_feldweg_surface.png^cottages_feldweg_edges.png"},
			-- "default_dirt.png^default_grass_side.png", "default_dirt.png", "default_grass.png",
			texture_side, texture_bottom, texture_top,
		paramtype = "light",
		drawtype = "mesh",
		mesh = "feldweg-curve.obj",
	})

	minetest.register_node("cottages:feldweg_end"..postfix, {
		description = S("dirt road end"..name_postfix),
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,
		tiles = {"cottages_feldweg_end.png",
			-- "default_dirt.png^default_grass_side.png", "default_dirt.png", "default_grass.png",
			texture_side, texture_bottom, texture_top,
			"cottages_feldweg_surface.png^cottages_feldweg_edges.png",
			"cottages_feldweg_surface.png"},
		paramtype = "light",
		drawtype = "mesh",
		mesh = "feldweg_end.obj",
	})

	if( cottages_feldweg_mode ~= "mesh_incl_45" ) then
		return
	end

	-- new feldweg
	minetest.register_node("cottages:feldweg_45"..postfix, {
		description = S("dirt road 45º"..name_postfix),
		tiles = {
			"cottages_feldweg_surface.png",
			"cottages_feldweg_surface.png^cottages_feldweg_edges.png",
			-- "default_dirt.png^default_grass_side.png", "default_dirt.png", "default_grass.png",
			texture_side, texture_bottom, texture_top,
		},
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,crumbly=3},
		drawtype = "mesh",
		mesh = "feldweg_45.b3d",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		is_ground_content = true,
	})

	minetest.register_node("cottages:feldweg_s_45"..postfix, {
		description = S("dirt road 45º edge"..name_postfix),
		tiles = {
			-- "default_grass.png", "default_dirt.png^default_grass_side.png", "default_dirt.png",
			texture_top, texture_side, texture_bottom,
			"cottages_feldweg_surface.png",
			"cottages_feldweg_surface.png^cottages_feldweg_edges.png",
		},
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,crumbly=3},
		drawtype = "mesh",
		mesh = "feldweg_s_45.b3d",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		is_ground_content = true,
	})

	minetest.register_node("cottages:feldweg_d_45"..postfix, {
		description = S("dirt road 45º double edge"..name_postfix),
		tiles = {
			-- "default_dirt.png^default_grass_side.png", "default_dirt.png", "default_grass.png",
			texture_side, texture_bottom, texture_top,
			"cottages_feldweg_surface.png^cottages_feldweg_edges.png",
			"cottages_feldweg_surface.png",
		},
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,crumbly=3},
		drawtype = "mesh",
		mesh = "feldweg_d_45.b3d",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		is_ground_content = true,
	})

	minetest.register_node("cottages:feldweg_l_curve"..postfix, {
		description = S("dirt road left curve"..name_postfix),
		tiles = {
			-- "default_dirt.png^default_grass_side.png", "default_dirt.png", "default_grass.png",
			texture_side, texture_bottom, texture_top,
			"cottages_feldweg_surface.png^cottages_feldweg_edges.png",
			"cottages_feldweg_surface.png",
		},
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,crumbly=3},
		drawtype = "mesh",
		mesh = "feldweg_l_45_curve.b3d",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		is_ground_content = true,
	})

	minetest.register_node("cottages:feldweg_r_curve"..postfix, {
		description = S("dirt road right curve"..name_postfix),
		tiles = {
			-- "default_dirt.png^default_grass_side.png", "default_dirt.png", "default_grass.png",
			texture_side, texture_bottom, texture_top,
			"cottages_feldweg_surface.png^cottages_feldweg_edges.png",
			"cottages_feldweg_surface.png",
		},
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2,crumbly=3},
		drawtype = "mesh",
		mesh = "feldweg_r_45_curve.b3d",
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		is_ground_content = true,
	})
end




--- a nice dirt road for small villages or paths to fields
if( cottages_feldweg_mode == "simple" or cottages_feldweg_mode == "flat" ) then
	minetest.register_node("cottages:feldweg", {
		description = S("dirt road"),
		tiles = {"cottages_feldweg.png","default_dirt.png", "default_dirt.png^default_grass_side.png"},
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,
	})
end

-- add crossing, t-junction and corner

--
-- flat - just textures, full blocks
--
if( cottages_feldweg_mode == "flat" ) then

	minetest.register_node("cottages:feldweg_crossing", {
		description = S("dirt road crossing"),
		tiles = {"cottages_feldweg_kreuzung.png","default_dirt.png", "default_dirt.png^default_grass_side.png"},
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,
	})

	minetest.register_node("cottages:feldweg_t_junction", {
		description = S("dirt road t junction"),
		tiles = {"cottages_feldweg_t-kreuzung.png^[transform2","default_dirt.png", "default_dirt.png^default_grass_side.png"},
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,
	})

	minetest.register_node("cottages:feldweg_curve", {
		description = S("dirt road curve"),
		tiles = {"cottages_feldweg_ecke.png^[transform2","default_dirt.png", "default_dirt.png^default_grass_side.png"},
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,
	})
	                                          
	register_recipes(false)
--
-- cube-style nodebox version
--
elseif( cottages_feldweg_mode == "nodebox" ) then
	minetest.register_node("cottages:feldweg", {
	        description = S("dirt road"),
		tiles = {"cottages_feldweg_orig.png","default_dirt.png", "default_dirt.png^default_grass_side.png"},
		paramtype2 = "facedir",
		roups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,
		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.5-2/16,  0.5},
				-- Rasenkanten
				{ -0.5,      0.5-2/16, -0.5,  -0.5+3/16, 0.5,  0.5},
				{  0.5-3/16, 0.5-2/16, -0.5,   0.5,      0.5,  0.5},
				-- uebergang zwischen Wagenspur und Rasenkante
				{ -0.5+3/16, 0.5-2/16, -0.5,  -0.5+4/16, 0.5-1/16,  0.5},
				{  0.5-4/16, 0.5-2/16, -0.5,   0.5-3/16, 0.5-1/16,  0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.5,  0.5},
			},
		},
	})

	minetest.register_node("cottages:feldweg_crossing", {
		description = S("dirt road crossing"),
		tiles = {"cottages_feldweg_kreuzung.png","default_dirt.png", "default_dirt.png^default_grass_side.png"},
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,

		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.5-2/16,  0.5},
				-- Rasenkanten
				{ -0.5,      0.5-2/16, -0.5,  -0.5+3/16, 0.5, -0.5+3/16},
				{  0.5-3/16, 0.5-2/16, -0.5,   0.5,      0.5, -0.5+3/16},

				{ -0.5,      0.5-2/16, 0.5-3/16,  -0.5+3/16, 0.5,  0.5},
				{  0.5-3/16, 0.5-2/16, 0.5-3/16,   0.5,      0.5,  0.5},
				-- uebergang zwischen Wagenspur und Rasenkante
				{ -0.5+3/16, 0.5-2/16, -0.5,  -0.5+4/16, 0.5-1/16, -0.5+4/16},
				{  0.5-4/16, 0.5-2/16, -0.5,   0.5-3/16, 0.5-1/16, -0.5+4/16},

				{ -0.5+3/16, 0.5-2/16, 0.5-4/16,  -0.5+4/16, 0.5-1/16,  0.5},
				{  0.5-4/16, 0.5-2/16, 0.5-4/16,   0.5-3/16, 0.5-1/16,  0.5},


				{ -0.5,      0.5-2/16, -0.5+3/16, -0.5+3/16, 0.5-1/16, -0.5+4/16},
				{  0.5-3/16, 0.5-2/16, -0.5+3/16,  0.5,      0.5-1/16, -0.5+4/16},

				{ -0.5,      0.5-2/16, 0.5-4/16,  -0.5+3/16, 0.5-1/16,  0.5-3/16},
				{  0.5-3/16, 0.5-2/16, 0.5-4/16,   0.5,      0.5-1/16,  0.5-3/16},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.5,  0.5},
			},
		},
	})

	minetest.register_node("cottages:feldweg_t_junction", {
		description = S("dirt road t junction"),
		tiles = {"cottages_feldweg_t-kreuzung.png^[transform2","default_dirt.png", "default_dirt.png^default_grass_side.png"},
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,

		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.5-2/16,  0.5},
				-- Rasenkanten
				{ -0.5,      0.5-2/16, -0.5,  -0.5+3/16, 0.5, -0.5+3/16},

				{ -0.5,      0.5-2/16, 0.5-3/16,  -0.5+3/16, 0.5,  0.5},
				-- Rasenkante seitlich durchgehend
				{  0.5-3/16, 0.5-2/16, -0.5,   0.5,      0.5,  0.5},
				-- uebergang zwischen Wagenspur und Rasenkante
				{ -0.5+3/16, 0.5-2/16, -0.5,  -0.5+4/16, 0.5-1/16, -0.5+4/16},

				{ -0.5+3/16, 0.5-2/16, 0.5-4/16,  -0.5+4/16, 0.5-1/16,  0.5},


				{ -0.5,      0.5-2/16, -0.5+3/16, -0.5+3/16, 0.5-1/16, -0.5+4/16},

				{ -0.5,      0.5-2/16, 0.5-4/16,  -0.5+3/16, 0.5-1/16,  0.5-3/16},
				-- Ueberganng seitlich durchgehend
				{  0.5-4/16, 0.5-2/16, -0.5,   0.5-3/16, 0.5-1/16,  0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.5,  0.5},
			},
		},
	})

	minetest.register_node("cottages:feldweg_curve", {
		description = S("dirt road curve"),
		tiles = {"cottages_feldweg_ecke.png^[transform2","default_dirt.png", "default_dirt.png^default_grass_side.png"},
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,

		drawtype = "nodebox",
                -- top, bottom, side1, side2, inner, outer
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.5-2/16,  0.5},
				-- Rasenkante vorne durchgehend
				{ -0.5,      0.5-2/16, -0.5,  0.5-3/16, 0.5, -0.5+3/16},

				-- Rasenkanten
				{ -0.5,      0.5-2/16, 0.5-3/16,  -0.5+3/16, 0.5,  0.5},
				-- Rasenkante seitlich durchgehend
				{  0.5-3/16, 0.5-2/16, -0.5,   0.5,      0.5,  0.5},
				-- uebergang zwischen Wagenspur und Rasenkante
				{ -0.5+3/16, 0.5-2/16, 0.5-4/16,  -0.5+4/16, 0.5-1/16,  0.5},


				-- Uebergang vorne durchgehend
				{ -0.5,      0.5-2/16, -0.5+3/16, 0.5-3/16, 0.5-1/16, -0.5+4/16},

				{ -0.5,      0.5-2/16, 0.5-4/16,  -0.5+3/16, 0.5-1/16,  0.5-3/16},
				-- Ueberganng seitlich durchgehend
				{  0.5-4/16, 0.5-2/16, -0.5,   0.5-3/16, 0.5-1/16,  0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,  0.5, 0.5,  0.5},
			},
		},
	})

	register_recipes(false)                               
	                                          

--
-- the mesh version (rounded); provided and created by VanessaE
--
elseif( cottages_feldweg_mode == "mesh"
	or cottages_feldweg_mode == "mesh_incl_45" ) then


	local variants = {}
	variants["grass"] = {
		"default_grass.png", -- grass top
		"default_dirt.png", -- bottom
		"default_dirt.png^default_grass_side.png", -- side
		"",
		"default:dirt",
		""
	}
	variants["gravel"] = {
		"default_gravel.png", -- grass top
		"default_gravel.png", -- bottom
		"default_gravel.png", -- side
		"_gravel",
		"default:gravel",
		" on gravel",
	}
	variants["coniferous"] = {
		"default_coniferous_litter.png", -- grass top
		"default_dirt.png", -- bottom
		"default_dirt.png^default_coniferous_litter_side.png", -- side
		"_coniferous",
		"default:dirt_with_coniferous_litter",
		" on coniferious litter",
	}
	variants["snow"] = {
		"default_snow.png", -- grass top
		"default_dirt.png", -- bottom
		"default_dirt.png^default_snow_side.png", -- side
		"_snow",
		"default:dirt_with_snow",
		" on snow", }
	variants["dry"] = {
		"default_dry_grass.png", -- grass top
		"default_dirt.png", -- bottom
		"default_dirt.png^default_dry_grass_side.png", -- side
		"_dry",
		"default:dry_dirt",
		" on dry dirt",
	}
	variants["bamboo"] = {
		"ethereal_grass_bamboo_top.png", -- grass top
		"default_dirt.png", -- bottom
		"default_dirt.png^ethereal_grass_bamboo_side.png", -- side
		"_bamboo",
		"ethereal:bamboo_dirt",
		" on bamboo dirt",
	}

	for k, v in pairs(variants) do
		cottages.register_nodes_mesh(v[4], v[1], v[2], v[3], cottages_feldweg_mode, v[6])
		register_recipes(true, v[4], v[5])
	end
end



-- create stairs if possible
if( minetest.get_modpath("stairs") and stairs and stairs.register_stair_and_slab) then
   stairs.register_stair_and_slab("feldweg", "cottages:feldweg",
		{snappy=2,choppy=2,oddly_breakable_by_hand=2},
		{"cottages_feldweg.png","default_dirt.png", "default_grass.png","default_grass.png","cottages_feldweg.png","cottages_feldweg.png"},
		S("Dirt Road Stairs"),
		S("Dirt Road, half height"),
		cottages.sounds.dirt)
end

if( cottages_feldweg_mode == "nodebox"
 or cottages_feldweg_mode == "mesh"
 or cottages_feldweg_mode == "mesh_incl_45") then
        local box_slope = {
			type = "fixed",
			fixed = {
				{-0.5,  -0.5,  -0.5, 0.5, -0.25, 0.5},
				{-0.5, -0.25, -0.25, 0.5,     0, 0.5},
				{-0.5,     0,     0, 0.5,  0.25, 0.5},
				{-0.5,  0.25,  0.25, 0.5,   0.5, 0.5}
			}};

	local box_slope_long = {
			type = "fixed",
			fixed = {
				{-0.5,  -0.5,  -1.5, 0.5, -0.10, 0.5},
				{-0.5, -0.25,  -1.3, 0.5, -0.25, 0.5},
				{-0.5, -0.25,  -1.0, 0.5,     0, 0.5},
				{-0.5,     0,  -0.5, 0.5,  0.25, 0.5},
				{-0.5,  0.25,     0, 0.5,   0.5, 0.5}
			}};

	minetest.register_node("cottages:feldweg_slope", {
		description = S("dirt road slope"),
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,
		tiles = {"cottages_feldweg_end.png","default_dirt.png^default_grass_side.png",
			"default_dirt.png", "default_grass.png",
			"cottages_feldweg_surface.png",
			"cottages_feldweg_surface.png^cottages_feldweg_edges.png"},
		paramtype = "light",
		drawtype = "mesh",
		mesh = "feldweg_slope.obj",

                collision_box = box_slope,
		selection_box = box_slope,
	})

                                 
	                                          
	minetest.register_node("cottages:feldweg_slope_long", {
		description = S("dirt road slope long"),
		paramtype2 = "facedir",
		groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
		legacy_facedir_simple = true,
		groups = {crumbly=3},
		sounds = cottages.sounds.dirt,
		is_ground_content = false,
		tiles = {"cottages_feldweg_end.png","default_dirt.png^default_grass_side.png",
			"default_dirt.png", "default_grass.png",
			"cottages_feldweg_surface.png",
			"cottages_feldweg_surface.png^cottages_feldweg_edges.png"},
		paramtype = "light",
		drawtype = "mesh",
		mesh = "feldweg_slope_long.obj",
                collision_box = box_slope_long,
		selection_box = box_slope_long,
	})
	        
	                                          
	minetest.register_craft({
		output = "cottages:feldweg_slope 3",
		recipe = {
			{"cottages:feldweg", "", "" },
			{"cottages:feldweg", "cottages:feldweg", ""}
		},
	})	     
	                                          
	minetest.register_craft({
		output = "cottages:feldweg_slope_long 4",
		recipe = {
			{"cottages:feldweg", "", "" },
			{"cottages:feldweg", "cottages:feldweg", "cottages:feldweg"}
		},
	})
end
