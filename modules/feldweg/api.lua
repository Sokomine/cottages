local S = cottages.S
local api = cottages.feldweg

local box_slope = {
    type = "fixed",
    fixed = {
        {-0.5,  -0.5,  -0.5, 0.5, -0.25, 0.5},
        {-0.5, -0.25, -0.25, 0.5,     0, 0.5},
        {-0.5,     0,     0, 0.5,  0.25, 0.5},
        {-0.5,  0.25,  0.25, 0.5,   0.5, 0.5}
    }
}

local box_slope_long = {
    type = "fixed",
    fixed = {
        {-0.5,  -0.5,  -1.5, 0.5, -0.10, 0.5},
        {-0.5, -0.25,  -1.3, 0.5, -0.25, 0.5},
        {-0.5, -0.25,  -1.0, 0.5,     0, 0.5},
        {-0.5,     0,  -0.5, 0.5,  0.25, 0.5},
        {-0.5,  0.25,     0, 0.5,   0.5, 0.5}
    }
}

local function simplify_tile(tile)
    if type(tile) == "string" then
        return tile

    elseif type(tile) == "table" then
        if type(tile.name) == "string" then
            return tile.name

        else
            error(("weird tile %q"):dump(tile))
        end

    else
        error(("weird tile %q"):dump(tile))
    end
end

local function get_textures(tiles, special)
    if #tiles == 1 then
        local tile1 = simplify_tile(tiles[1])
        return tile1, tile1, tile1, tile1, "cottages_feldweg_surface.png^" .. (special or tile1)

    elseif #tiles == 2 then
        local tile1 = simplify_tile(tiles[1])
        local tile2 = simplify_tile(tiles[2])
        return tile1, tile2, tile1, tile1, "cottages_feldweg_surface.png^" .. (special or tile1)

    elseif #tiles == 3 then
        local tile1 = simplify_tile(tiles[1])
        local tile2 = simplify_tile(tiles[2])
        local tile3 = simplify_tile(tiles[3])
        return tile1, tile2, tile3, tile3, "cottages_feldweg_surface.png^" .. (special or tile1)

    else
        error(("not implemented: %i tiles"):format(#tiles))
    end
end

local function register_feldweg(name, base_def, def)
    minetest.register_node(name, {
        description = def.description,

        paramtype = "light",
        paramtype2 = "facedir",
        legacy_facedir_simple = true,

        drawtype = "mesh",
        mesh = def.mesh,
        tiles = def.tiles,
        collision_box = def.collision_box,
		selection_box = def.selection_box,

        is_ground_content = false,
        groups = base_def.groups,
        sounds = base_def.sounds,
    })

    minetest.register_craft({
        output = name .. " " .. def.output_amount,
        recipe = def.recipe
    })

    minetest.register_craft({
        output = def.reverts_to,
        recipe = {
            {name},
        }
    })
end

function api.register_feldweg(node, suffix, special)
    local def = minetest.registered_nodes[node]
    local texture_top, texture_bottom, texture_side, texture_side_with_dent, texture_edges =
        get_textures(def.tiles, special)
    local desc = futil.get_safe_short_description(node)
    local feldweg_name = "cottages:feldweg" .. suffix

    register_feldweg(feldweg_name, def, {
        description = S("dirt road on @1", desc),
        mesh = "feldweg.obj",
        tiles = {
            texture_side_with_dent,
			texture_side,
            texture_bottom,
            texture_top,
			"cottages_feldweg_surface.png",
			texture_edges
        },
        recipe = {
            {"", "cottages:wagon_wheel", ""},
            {node, node, node},
        },
        output_amount = 3,
        reverts_to = node,
    })

    register_feldweg("cottages:feldweg_crossing" .. suffix, def, {
        description = S("dirt road crossing on @1", desc),
        mesh = "feldweg-crossing.obj",
        tiles = {
            texture_side_with_dent,
			texture_bottom,
            texture_top,
			"cottages_feldweg_surface.png",
			texture_edges
        },
        recipe = {
            {"", feldweg_name, ""},
            {feldweg_name, feldweg_name, feldweg_name},
            {"", feldweg_name, ""},
        },
        output_amount = 5,
        reverts_to = feldweg_name,
    })

    register_feldweg("cottages:feldweg_t_junction" .. suffix, def, {
        description = S("dirt road t junction on @1", desc),
        mesh = "feldweg-T-junction.obj",
        tiles = {
            texture_side_with_dent,
			texture_side,
            texture_bottom,
            texture_top,
			"cottages_feldweg_surface.png",
			texture_edges
        },
        recipe = {
            {"", feldweg_name, ""},
            {"", feldweg_name, ""},
            {feldweg_name, feldweg_name, feldweg_name},
        },
        output_amount = 5,
        reverts_to = feldweg_name,
    })

    register_feldweg("cottages:feldweg_curve" .. suffix, def, {
        description = S("dirt road curve on @1", desc),
        mesh = "feldweg-curve.obj",
        tiles = {
			texture_side,
            texture_top,
			texture_side,
			"cottages_feldweg_surface.png",
			texture_bottom,
			texture_edges
        },
        recipe = {
            {feldweg_name, "", ""},
            {feldweg_name, "", ""},
            {feldweg_name, feldweg_name, feldweg_name},
        },
        output_amount = 5,
        reverts_to = feldweg_name,
    })

    register_feldweg("cottages:feldweg_end" .. suffix, def, {
        description = S("dirt road end on @1", desc),
        mesh = "feldweg_end.obj",
        tiles = {
            texture_side_with_dent,
			texture_side,
            texture_bottom,
            texture_top,
			texture_edges,
			"cottages_feldweg_surface.png"
        },
        recipe = {
            {feldweg_name, "", feldweg_name},
            {feldweg_name, feldweg_name, feldweg_name},
        },
        output_amount = 5,
        reverts_to = feldweg_name,
    })

    register_feldweg("cottages:feldweg_45" .. suffix, def, {
        description = S("dirt road 45º on @1", desc),
        mesh = "feldweg_45.b3d",
        tiles = {
			"cottages_feldweg_surface.png",
			texture_edges,
			texture_side,
            texture_bottom,
            texture_top,
		},
        recipe = {
            {feldweg_name, "", feldweg_name},
            {"", feldweg_name, ""},
            {feldweg_name, "", feldweg_name},
        },
        output_amount = 5,
        reverts_to = feldweg_name,
    })

    register_feldweg("cottages:feldweg_s_45" .. suffix, def, {
        description = S("dirt road 45º edge on @1", desc),
        mesh = "feldweg_s_45.b3d",
        tiles = {
			texture_top,
            texture_side,
            texture_bottom,
			"cottages_feldweg_surface.png",
			texture_edges,
		},
        recipe = {
            {feldweg_name, ""},
            {"", feldweg_name},
        },
        output_amount = 2,
        reverts_to = feldweg_name,
    })

    register_feldweg("cottages:feldweg_d_45" .. suffix, def, {
        description = S("dirt road 45º double edge on @1", desc),
        mesh = "feldweg_d_45.b3d",
        tiles = {
			texture_side,
            texture_bottom,
            texture_top,
			texture_edges,
			"cottages_feldweg_surface.png",
		},
        recipe = {
            {feldweg_name, "", feldweg_name},
            {"", feldweg_name, ""},
        },
        output_amount = 3,
        reverts_to = feldweg_name,
    })

    register_feldweg("cottages:feldweg_l_curve" .. suffix, def, {
        description = S("dirt road left curve on @1", desc),
        mesh = "feldweg_l_45_curve.b3d",
        tiles = {
			texture_side,
            texture_bottom,
            texture_top,
			texture_edges,
			"cottages_feldweg_surface.png",
		},
        recipe = {
            {"", "", feldweg_name},
            {feldweg_name, feldweg_name, ""},
        },
        output_amount = 3,
        reverts_to = feldweg_name,
    })

    register_feldweg("cottages:feldweg_r_curve" .. suffix, def, {
        description = S("dirt road right curve on @1", desc),
        mesh = "feldweg_r_45_curve.b3d",
        tiles = {
			texture_side,
            texture_bottom,
            texture_top,
			texture_edges,
			"cottages_feldweg_surface.png",
		},
        recipe = {
            {feldweg_name, "", ""},
            {"", feldweg_name, feldweg_name},
        },
        output_amount = 3,
        reverts_to = feldweg_name,
    })

    register_feldweg("cottages:feldweg_slope" .. suffix, def, {
        description = S("dirt road slope on @1", desc),
        mesh = "feldweg_slope.obj",
        tiles = {
            texture_side_with_dent,
			texture_side,
            texture_bottom,
            texture_top,
			"cottages_feldweg_surface.png",
			texture_edges
        },
        collision_box = box_slope,
		selection_box = box_slope,
        recipe = {
            {feldweg_name, ""},
            {feldweg_name, feldweg_name},
        },
        output_amount = 3,
        reverts_to = feldweg_name,
    })

    register_feldweg("cottages:feldweg_slope_long" .. suffix, def, {
        description = S("dirt road slope long on @1", desc),
		mesh = "feldweg_slope_long.obj",
        tiles = {
            texture_side_with_dent,
			texture_side,
            texture_bottom,
            texture_top,
			"cottages_feldweg_surface.png",
			texture_edges
        },
        collision_box = box_slope_long,
		selection_box = box_slope_long,
        recipe = {
            {feldweg_name, "", ""},
            {feldweg_name, feldweg_name, feldweg_name},
        },
        output_amount = 4,
        reverts_to = feldweg_name,
    })
end
