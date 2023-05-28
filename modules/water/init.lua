if not cottages.has.bucket then
	return
end

cottages.water = {}

cottages.dofile("modules", "water", "entity")
cottages.dofile("modules", "water", "well")
cottages.dofile("modules", "water", "crafts")
