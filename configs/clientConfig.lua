Cyr = {}
TriggerServerEvent("plouffe_cayorobbery:sendConfig")

RegisterNetEvent("plouffe_cayorobbery:getConfig",function(list)
	if not list then
		while true do
			Cyr = nil
		end
	else
		for k,v in pairs(list) do
			Cyr[k] = v
		end

		Cyr:Start()
	end
end)