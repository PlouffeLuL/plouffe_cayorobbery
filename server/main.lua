CreateThread(Cyr.Init)

RegisterNetEvent("plouffe_cayorobbery:sendConfig",function()
    local playerId = source
    local registred, key = Auth:Register(playerId)

    while not Server.ready do
        Wait(100)
    end

    if registred then
        local cbArray = Cyr:GetData()
        cbArray.Utils.MyAuthKey = key
        TriggerClientEvent("plouffe_cayorobbery:getConfig", playerId, cbArray)
    else
        TriggerClientEvent("plouffe_cayorobbery:getConfig", playerId, nil)
    end
end)

RegisterNetEvent("plouffe_cayorobbery:paintingLooted",function(netId, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_cayorobbery:paintingLooted") then
        Cyr:PlayerRobbedPainting(playerId, netId)
    end
end)

RegisterNetEvent("plouffe_cayorobbery:LootedDiamond",function(netId, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_cayorobbery:LootedDiamond") then
        Cyr:PlayerLootedDiamond(playerId, netId)
    end
end)

RegisterNetEvent("plouffe_cayorobbery:doorHacked",function(doorIndex, type, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_cayorobbery:doorHacked") then
        Cyr:UnlockDoor(playerId, doorIndex, type)
    end
end)

RegisterNetEvent("plouffe_cayorobbery:lootkey",function(zoneIndex, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_cayorobbery:lootkey") then
        Cyr:LootKey(playerId, zoneIndex)
    end
end)

RegisterNetEvent("plouffe_cayorobbery:unlockDoor",function(zoneIndex, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_cayorobbery:unlockDoor") then
        Cyr:Unlockdoor(playerId, zoneIndex)
    end
end)

RegisterNetEvent("plouffe_cayorobbery:hacked_elevator", function(success, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_cayorobbery:hacked_elevator") then
        Cyr:ElevatorHack(playerId, success)
    end
end)

RegisterNetEvent("plouffe_cayorobbery:gate_thermal", function(success, doorIndex, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_cayorobbery:unlockDoor") then
        Cyr:PlayerThermalGate(playerId, success, doorIndex)
    end
end)

RegisterNetEvent("plouffe_cayorobbery:removeItem", function(item, amount, authkey)
    local playerId = source
    if Auth:Validate(playerId,authkey) and Auth:Events(playerId,"plouffe_cayorobbery:removeItem") then
        exports.ox_inventory:RemoveItem(playerId, item, amount)
    end
end)