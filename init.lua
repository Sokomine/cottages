
-- Version: 2.0
-- Autor:   Sokomine
-- License: GPLv3
--
-- Modified:
-- 23.01.14 Added conversion receipes in case of installed castle-mod (has its own anvil)
-- 23.01.14 Added hammer and anvil as decoration and for repairing tools.
--          Added hatches (wood and steel).
--          Changed the texture of the fence/handrail.
-- 17.01.13 Added alternate receipe for fences in case of interference due to xfences
-- 14.01.13 Added alternate receipes for roof parts in case homedecor is not installed.
--          Added receipe for stove pipe, tub and barrel.
--          Added stairs/slabs for dirt road, loam and clay
--          Added fence_small, fence_corner and fence_end, which are useful as handrails and fences
--          If two or more window shutters are placed above each other, they will now all close/open simultaneously.
--          Added threshing floor.
--          Added hand-driven mill.

cottages = {}

--cottages.config_use_mesh_barrel   = false;
--cottages.config_use_mesh_handmill = true;

-- uncomment parts you do not want

-- texture used for fence gate and bed posts
cottages.texture_furniture  = "default_wood.png";
-- texture for the side of roof nodes
cottages.texture_roof_sides = "default_wood.png";
-- if the default wood node does not exist, use an alternate wood texture
-- (which is also used for furnitures and doors in this mod)
if( not( minetest.registered_nodes['default:wood'])) then
	cottages.texture_roof_sides = "cottages_minimal_wood.png";
	cottages.texture_furniture  = "cottages_minimal_wood.png";
end

-- texture for roofs where the tree bark is the main roof texture
cottages.textures_roof_wood = "default_tree.png";
if( not( minetest.registered_nodes["default:tree"])) then
	-- realtest has diffrent barks; the spruce one seems to be the most fitting
	if( minetest.registered_nodes["trees:spruce_log" ]) then
		cottages.textures_roof_wood = "trees_spruce_trunk.png";
	else
		-- does not look so well in this case as it's no bark; but what else shall we do?
		cottages.textures_roof_wood = "cottages_minimal_wood.png";
	end
end

dofile(minetest.get_modpath("cottages").."/nodes_furniture.lua");
dofile(minetest.get_modpath("cottages").."/nodes_historic.lua");
dofile(minetest.get_modpath("cottages").."/nodes_straw.lua");
dofile(minetest.get_modpath("cottages").."/nodes_anvil.lua");
dofile(minetest.get_modpath("cottages").."/nodes_doorlike.lua");
dofile(minetest.get_modpath("cottages").."/nodes_fences.lua");
dofile(minetest.get_modpath("cottages").."/nodes_roof.lua");
dofile(minetest.get_modpath("cottages").."/nodes_barrel.lua");
--dofile(minetest.get_modpath("cottages").."/nodes_chests.lua");

-- this is only required and useful if you run versions of the random_buildings mod where the nodes where defined inside that mod
dofile(minetest.get_modpath("cottages").."/alias.lua");
