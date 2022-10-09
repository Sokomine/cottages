if not (cottages.craftitems.bucket and cottages.craftitems.bucket_filled) then
	return
end

cottages.water = {}

cottages.dofile("modules", "water", "api")
cottages.dofile("modules", "water", "entity")
cottages.dofile("modules", "water", "well")
cottages.dofile("modules", "water", "crafts")
