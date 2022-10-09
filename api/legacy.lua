cottages.handmill_product = {
    __newindex = function(t, k, v)
        cottages.straw.register_quern_craft({input = k, output = v})
    end
}
