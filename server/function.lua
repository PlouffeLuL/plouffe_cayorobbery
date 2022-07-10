local timeToRob = 60 * 60 * 1
local keyZones = {}
local activePeds = {}

function Cyr.Init()
    Cyr:RelockAllDoors()
    GlobalState.cayoRobberyState = "Ready"
    Server.ready = true
end

function Cyr:GetData()
    local retval = {}

    for k,v in pairs(self) do
        if type(v) ~= "function" then
            retval[k] = v
        end
    end

    return retval
end

function Cyr:RelockAllDoors()
    local data = {}

    for k,v in pairs(Cyr.Doors) do
        for x,y in pairs(v) do
            for _,door in pairs(y) do
                data[#data + 1] = door
            end
        end
    end

    exports.plouffe_doorlock:UpdateDoorStateTable(data, true)
end

function Cyr:CreateAllFrames()
    for k,v in pairs(self.Art.coords) do
        local init = os.time()
        v.model = self.Art.models[math.random(1, #self.Art.models)]
        local paintingModel = joaat(v.model)

        local paintingEntity = CreateObject(paintingModel, v.paintingCoords.x, v.paintingCoords.y, v.paintingCoords.z, true, true, false)
        
        while not DoesEntityExist(paintingEntity) and os.time() - init < 5 do
            Wait(0)
        end
        
        if DoesEntityExist(paintingEntity) then
            FreezeEntityPosition(paintingEntity, true)
            SetEntityRotation(paintingEntity, v.paintingRotation.x, v.paintingRotation.y, v.paintingRotation.z, 2, true)
            v.paintingNetId = NetworkGetNetworkIdFromEntity(paintingEntity)
        end

        local frameEntity = CreateObject(joaat(v.frameModel), v.frameCoords.x, v.frameCoords.y, v.frameCoords.z, true, true, false)

        while not DoesEntityExist(frameEntity) and os.time() - init < 5 do
            Wait(0)
        end

        if DoesEntityExist(frameEntity) then
            FreezeEntityPosition(frameEntity, true)
            SetEntityRotation(frameEntity, v.frameRotation.x, v.frameRotation.y, v.frameRotation.z, 2, true)
            v.frameNetId = NetworkGetNetworkIdFromEntity(frameEntity)
        end
    end
end

function Cyr:DeleteAllFrames()
    for k,v in pairs(self.Art.coords) do
        if v.frameNetId then
            local frameEntity = NetworkGetEntityFromNetworkId(v.frameNetId)
            v.frameNetId = nil
            
            DeleteEntity(frameEntity)
        end

        if v.paintingNetId then
            local paintingEntity = NetworkGetEntityFromNetworkId(v.paintingNetId)
            v.paintingNetId = nil
            DeleteEntity(paintingEntity)
        end
    end
end

function Cyr:PlayerRobbedPainting(playerId, netId)
    if GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    for k,v in pairs(self.Art.coords) do
        if v.paintingNetId == netId then
            local paintingEntity = NetworkGetEntityFromNetworkId(v.paintingNetId)
            DeleteEntity(paintingEntity)
            v.paintingNetId = nil
            
            local one, two = v.model:find("prop_")
            local itemName = v.model:sub(two + 1,v.model:len())

            exports.ox_inventory:AddItem(playerId, itemName, 1)

            if not self:IsAnyEntityNotLooted() then
                GlobalState.cayoRobberyState = "Finished"
            end
            break
        end            
    end
end

function Cyr:CreateDiamond()
    local init = os.time()
    local data = self.Diamond

    local displayEntity = CreateObject(joaat(data.display), data.displayCoords.x, data.displayCoords.y, data.displayCoords.z, true, true, false)
    
    while not DoesEntityExist(displayEntity) and os.time() - init < 5 do
        Wait(0)
    end
    
    if DoesEntityExist(displayEntity) then
        FreezeEntityPosition(displayEntity, true)
        SetEntityRotation(displayEntity, data.displayRotation.x, data.displayRotation.y, data.displayRotation.z, 2, true)
        self.Diamond.displayNetId = NetworkGetNetworkIdFromEntity(displayEntity)
    end

    local diamondEntity = CreateObject(joaat(data.model), data.diamondCoords.x, data.diamondCoords.y, data.diamondCoords.z, true, true, false)

    while not DoesEntityExist(diamondEntity) and os.time() - init < 5 do
        Wait(0)
    end

    if DoesEntityExist(diamondEntity) then
        FreezeEntityPosition(diamondEntity, true)
        SetEntityRotation(diamondEntity, data.diamondRotation.x, data.diamondRotation.y, data.diamondRotation.z, 2, true)
        self.Diamond.diamondNetId = NetworkGetNetworkIdFromEntity(diamondEntity)
    end
end

function Cyr:RemoveDiamond()
    if self.Diamond.displayNetId then
        local displayEntity = NetworkGetEntityFromNetworkId(self.Diamond.displayNetId)
        self.Diamond.displayNetId = nil
        
        DeleteEntity(displayEntity)
    end

    if self.Diamond.diamondNetId then
        local diamondEntity = NetworkGetEntityFromNetworkId(self.Diamond.diamondNetId)
        self.Diamond.diamondNetId = nil
        DeleteEntity(diamondEntity)
    end
end

function Cyr:PlayerLootedDiamond(playerId, netId)
    if GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    if self.Diamond.diamondNetId and self.Diamond.diamondNetId == netId then
        local displayEntity = NetworkGetEntityFromNetworkId(self.Diamond.diamondNetId)
        self.Diamond.diamondNetId = nil
        
        DeleteEntity(displayEntity)

        exports.ox_inventory:AddItem(playerId, "huge_diamond", 1)

        if not self:IsAnyEntityNotLooted() then
            GlobalState.cayoRobberyState = "Finished"
        end
    end
end

function Cyr:UnlockDoor(playerId, doorIndex, doorType)
    if GlobalState.cayoRobberyState == "Finished" then
        return
    end

    if not self.Doors[doorType][doorIndex] then
        return
    end

    if doorType:lower() == "hack" and GlobalState.cayoRobberyState == "Ready" then
        if not self:StartRobbery() then
            return
        end
    end

    for k,v in pairs(self.Doors[doorType][doorIndex]) do
        exports.plouffe_doorlock:UpdateDoorState(v,false)
        Wait(5000)
    end
end

function Cyr:IsAnyEntityNotLooted()
    if self.Diamond.diamondNetId then
        return true
    end

    for k,v in pairs(self.Art.coords) do
        if v.paintingNetId then
            return true
        end
    end

    return false
end

function Cyr:StartRobbery()
    local startTime = os.time()
    
    if GlobalState.cayoRobberyState ~= "Ready" then
        return false, ("Déjà volée")
    end

    local cops = exports.plouffe_society:GetPlayersPerJob("police")

    if not cops or Utils:TableLen(cops) < 6 then
        return false, ("Il n'y a pas asser de policier en service présentement")
    end
        
    self:RelockAllDoors()
    self:SetUpKeys()
    self:CreateAllFrames()
    self:CreateDiamond()
    self:CreateAllGuards()

    CreateThread(function()
        local sleepTimer = 1000 * 30
        
        while os.time() - startTime < timeToRob and GlobalState.cayoRobberyState == "Started" and self:IsAnyEntityNotLooted() do    
            Wait(sleepTimer)
        end

        if GlobalState.cayoRobberyState ~= "Finished" then
            GlobalState.cayoRobberyState = "Finished"
        end

        self:RemoveDiamond()
        self:DeleteAllFrames()
        self:DeleteAllGuards()

        keyZones = {}
    end)

    GlobalState.cayoRobberyState = "Started"
end

function Cyr:SetUpKeys()
    local usedRandi = {}

    for k,v in pairs(self.KeysMeta) do
        local len = Utils:TableLen(self.HiddenZones)
        local randi = math.random(1, len)
        
        repeat
            randi = math.random(1, len)
        until not usedRandi[randi]
        
        usedRandi[randi] = true

        local keyString = ("cyr_hidden_key_%s"):format(randi) 

        keyZones[keyString] = k
    end
end

function Cyr:LootKey(playerId, zoneIndex)
    if keyZones[zoneIndex] then
        exports.ox_inventory:AddItem(playerId, "cayo_keys", 1, {door = keyZones[zoneIndex]})
    end
end

function Cyr:Unlockdoor(playerId, zoneIndex)
    if self.KeysMeta[zoneIndex] then
        exports.plouffe_doorlock:UpdateDoorState(zoneIndex,false)
    end
end

function Cyr:GetPlayersInMansion(amount)
    local retval = {}
    local players = GetPlayers()

    for k,v in pairs(players) do
        local ped = GetPlayerPed(v)

        if DoesEntityExist(ped) then
            local pedCoords = GetEntityCoords(ped)
            local distance = #(vector3(5025.9790039063, -5755.3364257813, 16.27833366394) - pedCoords)

            if distance < 150 then
                retval[#retval + 1] = v
                
                if #retval == amount then
                    return retval
                end
            end
        end
    end

    return retval
end

function Cyr:CreateAllGuards()
    local players = self:GetPlayersInMansion(1)
    
    if not players[1] then
        return
    end

    local guardModel = self.Utils.aiModel
    local coords = vector3(5017.2690429688, -5746.8500976563, -17.51983833313)

    for k,v in pairs(Cyr.Guards.coords) do
        local ped = CreatePed(1, guardModel, coords.x, coords.y, coords.z, 0.0, true, true)
        GiveWeaponToPed(ped, joaat("WEAPON_ASSAULTRIFLE_MK2"), 999, false, true)
        FreezeEntityPosition(ped,true)

        Wait(1000)

        activePeds[#activePeds + 1] = NetworkGetNetworkIdFromEntity(ped)

        Entity(ped).state:set("killed", false, true)
    end

    TriggerClientEvent("plouffe_cayorobbery:setGuardsTasks", players[1], activePeds)
end

function Cyr:DeleteAllGuards()
    for k,v in pairs(activePeds) do
        local ped = NetworkGetEntityFromNetworkId(v)
        
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end    
    end
end

function Cyr:PlayerThermalGate(playerId, success, doorIndex)
    if GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    if not success then
        return
    end
    
    exports.plouffe_doorlock:UpdateDoorStateTable(Cyr.Doors.Thermal[doorIndex], false)
end

function Cyr:ElevatorHack(playerId, success)
    if GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    if not success then
        return Utils:ReduceDurability(playerId, "laptop", 60 * 60 * 24)
    end

    Utils:ReduceDurability(playerId, "laptop", 60 * 60 * 48)

    exports.plouffe_doorlock:UpdateDoorState("cayo_mansion_office_elevator",false)
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == "plouffe_cayorobbery" then
        Cyr:RemoveDiamond()
        Cyr:DeleteAllFrames()
        Cyr:DeleteAllGuards()
    end
end)

RegisterCommand("CayoPed", function(s,a,r)
    if a[1] then
        return Cyr:DeleteAllGuards()
    end

    Cyr:CreateAllGuards()
end, true)

RegisterCommand("StartCayo", function(s,a,r)
    if a[1] then
        GlobalState.cayoRobberyState = "Finished"
        return
    end

    Cyr:StartRobbery()
end, true)

RegisterCommand("Frame", function(s,a,r)
    if a[1] then
        return Cyr:DeleteAllFrames()
    end

    Cyr:CreateAllFrames()
end, true)

RegisterCommand("Diamond", function(s,a,r)
    if a[1] then
        return Cyr:RemoveDiamond()
    end

    Cyr:CreateDiamond()
end, true)