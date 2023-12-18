cottages.feldweg = {}

cottages.dofile("modules", "feldweg", "api")

if cottages.has.default then
	cottages.dofile("modules", "feldweg", "compat_default")
end

if cottages.has.ethereal then
	cottages.dofile("modules", "feldweg", "compat_ethereal")
end

if cottages.has.stairs then
	cottages.dofile("modules", "feldweg", "compat_stairs")
end
