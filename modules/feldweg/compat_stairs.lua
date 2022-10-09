local S = cottages.S

stairs.register_stair_and_slab(
	"feldweg",
	"cottages:feldweg",
	{crumbly = 3},
	{
		"cottages_feldweg.png",
		"default_dirt.png",
		"default_grass.png",
		"default_grass.png",
		"cottages_feldweg.png",
		"cottages_feldweg.png"
	},
	S("Dirt Road Stairs"),
	S("Dirt Road, half height"),
	cottages.sounds.dirt
)
