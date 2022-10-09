local has = cottages.has

local resolve_item = futil.resolve_item

local ci = {}

ci.stick = "group:stick"
ci.wood = "group:wood"
ci.tree = "group:tree"

if has.default then
	ci.chest_locked = resolve_item("default:chest_locked")
	ci.clay_brick = resolve_item("default:clay_brick")
	ci.clay = resolve_item("default:clay")
	ci.coal_lump = resolve_item("default:coal_lump")
	ci.dirt = resolve_item("default:dirt")
	ci.fence = resolve_item("default:fence_wood")
	ci.glass = resolve_item("default:glass")
	ci.iron = resolve_item("default:iron_lump")
	ci.junglewood = resolve_item("default:junglewood")
	ci.ladder = resolve_item("default:ladder")
	ci.paper = resolve_item("default:paper")
	ci.papyrus = resolve_item("default:papyrus")
	ci.rail = resolve_item("default:rail")
	ci.sand = resolve_item("default:sand")
	ci.steel = resolve_item("default:steel_ingot")
	ci.stone = resolve_item("default:stone")
end

if has.bucket then
	ci.bucket = resolve_item("bucket:bucket_empty")
	ci.bucket_filled = resolve_item("bucket:bucket_river_water")
end

if has.carts then
	ci.rail = resolve_item("carts:rail")
end

if has.doors then
	ci.door = resolve_item("doors:door_wood")
end

if has.farming then
	ci.barley = resolve_item("farming:barley")
	ci.cotton = resolve_item("farming:cotton")
	ci.flour = resolve_item("farming:flour")
	ci.oat = resolve_item("farming:oat")
	ci.rice = resolve_item("farming:rice")
	ci.rice_flour = resolve_item("farming:rice_flour")
	ci.rye = resolve_item("farming:rye")
	ci.seed_barley = resolve_item("farming:seed_barley")
	ci.seed_oat = resolve_item("farming:seed_oat")
	ci.seed_rye = resolve_item("farming:seed_rye")
	ci.seed_wheat = resolve_item("farming:seed_wheat")
	ci.string = resolve_item("farming:string")
	ci.wheat = resolve_item("farming:wheat")
end

if has.stairsplus and has.default then
	ci.slab_wood = resolve_item("default:slab_wood_8")

elseif has.moreblocks and resolve_item("moreblocks:slab_wood") then
	ci.slab_wood = resolve_item("moreblocks:slab_wood")

elseif has.stairs then
	ci.slab_wood = resolve_item("stairs:slab_wood")
end

if has.wool then
	ci.wool = resolve_item("wool:white")
else
	ci.wool = "cottages:wool"
end

ci.straw_mat = "cottages:straw_mat"

cottages.craftitems = ci
