
-- Version: 2.2
-- Autor:   Sokomine
-- License: GPLv3
--
-- Modified:
-- 11.03.19 Adjustments for MT 5.x
--          cottages_feldweg_mode is now a setting in minetest.conf
-- 27.07.15 Moved into its own repository.
--          Made sure textures and craft receipe indigrents are available or can be replaced.
--          Took care of "unregistered globals" warnings.
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

core.log('action','[MOD] loading cottages')
local mod_start_time = minetest.get_us_time()

cottages = {}

-- Boilerplate to support localized strings if intllib mod is installed.
if minetest.get_modpath( "intllib" ) and intllib then
	cottages.S = intllib.Getter()
else
	cottages.S = function(s) return s end
end

cottages.sounds = {}
-- MineClone2 needs special treatment; default is only needed for
-- crafting materials and sounds (less important)
if( not( minetest.get_modpath("default"))) then
	default = {};
	cottages.sounds.wood   = nil
	cottages.sounds.dirt   = nil
	cottages.sounds.leaves = nil
	cottages.sounds.stone  = nil
else
	cottages.sounds.wood   = default.node_sound_wood_defaults()
	cottages.sounds.dirt   = default.node_sound_dirt_defaults()
	cottages.sounds.stone  = default.node_sound_stone_defaults()
	cottages.sounds.leaves = default.node_sound_leaves_defaults()
end

-- the straw from default comes with stairs as well and might replace
-- cottages:roof_connector_straw and cottages:roof_flat_straw
-- however, that does not look very good
if( false and minetest.registered_nodes["farming:straw"]) then
	cottages.straw_texture = "farming_straw.png"
	cottages.use_farming_straw_stairs = true
else
	cottages.straw_texture = "cottages_darkage_straw.png"
end
--cottages.config_use_mesh_barrel   = false;
--cottages.config_use_mesh_handmill = true;

-- set alternate crafting materials and textures where needed
-- (i.e. in combination with realtest)
dofile(minetest.get_modpath("cottages").."/adaptions.lua");

-- add to this table what you want the handmill to convert;
-- add a stack size if you want a higher yield
cottages.handmill_product = {};
cottages.handmill_product[ cottages.craftitem_seed_wheat ] = 'farming:flour 1';
--[[ some examples:
cottages.handmill_product[ 'default:cobble' ] = 'default:gravel';
cottages.handmill_product[ 'default:gravel' ] = 'default:sand';
cottages.handmill_product[ 'default:sand'   ] = 'default:dirt 2';
cottages.handmill_product[ 'flowers:rose'   ] = 'dye:red 6';
cottages.handmill_product[ 'default:cactus' ] = 'dye:green 6';
cottages.handmill_product[ 'default:coal_lump'] = 'dye:black 6';
--]]
-- process that many inputs per turn
cottages.handmill_max_per_turn = 20;
cottages.handmill_min_per_turn = 0;

dofile(minetest.get_modpath("cottages").."/functions.lua");

-- anvil and threshing floor show huds
dofile(minetest.get_modpath("cottages").."/hud_functions.lua");

-- set the setting to false in minetest.conf if you do not want the specific part
if minetest.settings:get_bool("cottages_furniture", true) then
	dofile(minetest.get_modpath("cottages").."/nodes_furniture.lua");
end

if minetest.settings:get_bool("cottages_historic", true) then
	dofile(minetest.get_modpath("cottages").."/nodes_historic.lua");
end

if minetest.settings:get_bool("cottages_feldweg", true) then
	dofile(minetest.get_modpath("cottages").."/nodes_feldweg.lua");
end

if minetest.settings:get_bool("cottages_pitchfork", true) then
	-- allows to dig hay and straw fast
	dofile(minetest.get_modpath("cottages").."/nodes_pitchfork.lua");
end

if minetest.settings:get_bool("cottages_straw", true) then
	dofile(minetest.get_modpath("cottages").."/nodes_straw.lua");
end

if minetest.settings:get_bool("cottages_hay", true) then
	dofile(minetest.get_modpath("cottages").."/nodes_hay.lua");
end

if minetest.settings:get_bool("cottages_anvil", true) then
	dofile(minetest.get_modpath("cottages").."/nodes_anvil.lua");
end

if minetest.settings:get_bool("cottages_doorlike", true) then
	dofile(minetest.get_modpath("cottages").."/nodes_doorlike.lua");
end

if minetest.settings:get_bool("cottages_fences", true) then
	dofile(minetest.get_modpath("cottages").."/nodes_fences.lua");
end

if minetest.settings:get_bool("cottages_roof", true) then
	dofile(minetest.get_modpath("cottages").."/nodes_roof.lua");
end

if minetest.settings:get_bool("cottages_barrel", true) then
	dofile(minetest.get_modpath("cottages").."/nodes_barrel.lua");
end

if minetest.settings:get_bool("cottages_mining", true) then
	dofile(minetest.get_modpath("cottages").."/nodes_mining.lua");
end

if minetest.settings:get_bool("cottages_water", true) then
	dofile(minetest.get_modpath("cottages").."/nodes_water.lua");
end

if minetest.settings:get_bool("cottages_chests", true) then
	--dofile(minetest.get_modpath("cottages").."/nodes_chests.lua");
end

if minetest.settings:get_bool("cottages_unified_inventory_receipes", true) then
	-- add receipes for threshing floor and handmill to unified_inventory
	dofile(minetest.get_modpath("cottages").."/unified_inventory_receipes.lua");
end

if minetest.settings:get_bool("cottages_alias", true) then
	-- this is only required and useful if you run versions of the random_buildings mod where the nodes where defined inside that mod
	dofile(minetest.get_modpath("cottages").."/alias.lua");
end

-- variable no longer needed
cottages.S = nil;

local mod_load_time = (minetest.get_us_time() - mod_start_time) / 1000000
core.log('action','[MOD] cottages loaded.. ['.. mod_load_time ..'s]')
