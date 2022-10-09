for module, settings in pairs(cottages.settings) do
	if settings.enabled then
		cottages.dofile("modules", module, "init")
	end
end
