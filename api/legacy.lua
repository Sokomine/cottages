cottages.handmill_product = {
	__newindex = function(t, k, v)
		cottages.straw.register_quern_craft({ input = k, output = v })
	end,
}
cottages.forbid_repair = {
	__newindex = function(t, k, v)
		cottages.anvil.make_unrepairable(k)
	end,
}
