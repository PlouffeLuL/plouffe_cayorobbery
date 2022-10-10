local Utils = exports.plouffe_lib:Get("Utils")
local Lang = exports.plouffe_lib:Get("Lang")
local Interface = exports.plouffe_lib:Get("Interface")

local Animation = {
    Cutting = {dict = "anim@scripted@heist@ig16_glass_cut@male@", ptfxAsset = "scr_ih_fin", ptfx = {}},
    Art = {dict = "ANIM_HEIST@HS3F@IG11_STEAL_PAINTING@MALE@"},
    Hack = {dict = "anim_heist@hs3f@ig1_hack_keypad@male@"},
    Laptop = {dict = "anim@heists@ornate_bank@hack"},
    Thermal = {dict = "anim@heists@ornate_bank@thermal_charge", ptfxAsset = {"scr_ornate_heist", "scr_ch_finale", "pat_heist"}, ptfx = {}}
}

local Wait = Wait
local GetEntityCoords = GetEntityCoords
local PlayerPedId = PlayerPedId
local GetPedBoneIndex = GetPedBoneIndex

local GetGameTimer = GetGameTimer

local GetClosestObjectOfType = GetClosestObjectOfType
local GetEntityHeading = GetEntityHeading
local GetEntityRotation = GetEntityRotation
local GetOffsetFromEntityInWorldCoords = GetOffsetFromEntityInWorldCoords
local SetEntityCoords = SetEntityCoords
local SetEntityHeading = SetEntityHeading
local SetEntityRotation = SetEntityRotation
local SetEntityCollision = SetEntityCollision
local SetEntityVisible = SetEntityVisible
local SetEntityAsNoLongerNeeded = SetEntityAsNoLongerNeeded
local FreezeEntityPosition = FreezeEntityPosition
local DoesEntityExist = DoesEntityExist
local DeleteEntity = DeleteEntity
local DetachEntity = DetachEntity
local TaskPlayAnim = TaskPlayAnim
local RemoveAnimDict = RemoveAnimDict
local RemovePtfxAsset = RemovePtfxAsset
local AttachEntityToEntity = AttachEntityToEntity
local SetPtfxAssetNextCall = SetPtfxAssetNextCall
local StartNetworkedParticleFxLoopedOnEntity = StartNetworkedParticleFxLoopedOnEntity
local SetParticleFxLoopedEvolution = SetParticleFxLoopedEvolution
local RemoveParticleFx = RemoveParticleFx
local StopParticleFxLooped = StopParticleFxLooped

local NetworkCreateSynchronisedScene = NetworkCreateSynchronisedScene
local NetworkAddPedToSynchronisedScene = NetworkAddPedToSynchronisedScene
local NetworkAddEntityToSynchronisedScene = NetworkAddEntityToSynchronisedScene
local NetworkStartSynchronisedScene = NetworkStartSynchronisedScene
local PlaySoundFromEntity = PlaySoundFromEntity
local PlaySoundFromCoord = PlaySoundFromCoord
local RequestScriptAudioBank = RequestScriptAudioBank
local GetSoundId = GetSoundId
local StopSound = StopSound
local ReleaseScriptAudioBank = ReleaseScriptAudioBank

local NetworkGetNetworkIdFromEntity = NetworkGetNetworkIdFromEntity
local NetworkGetEntityFromNetworkId = NetworkGetEntityFromNetworkId

local SetPedAsCop = SetPedAsCop
local SetPedDropsWeaponsWhenDead = SetPedDropsWeaponsWhenDead
local TaskWanderInArea = TaskWanderInArea

local GetEntityModel = GetEntityModel
local IsPedDeadOrDying = IsPedDeadOrDying
local IsPedAPlayer = IsPedAPlayer
local TaskCombatPed = TaskCombatPed

local GetClockHours = GetClockHours

local aiPeds = nil

function Cyr:Start()
    self:ExportAllZones()
    self:RegisterEvents()

    if GetConvar("plouffe_cayorobbery:qtarget", "") == "true" then
        if GetResourceState("qtarget") ~= "missing" then
            local breakCount = 0
            while GetResourceState("qtarget") ~= "started" and breakCount < 30 do
                breakCount += 1
                Wait(1000)
            end

            if GetResourceState("qtarget") ~= "started" then
                return
            end

            exports.qtarget:AddTargetModel({
                joaat("h4_prop_h4_painting_01a"),
                joaat("h4_prop_h4_painting_01b"),
                joaat("h4_prop_h4_painting_01c"),
                joaat("h4_prop_h4_painting_01d"),
                joaat("h4_prop_h4_painting_01e"),
                joaat("h4_prop_h4_painting_01f"),
                joaat("h4_prop_h4_painting_01g"),
                joaat("h4_prop_h4_painting_01h"),
                joaat("ch_prop_vault_painting_01a"),
                joaat("ch_prop_vault_painting_01b"),
                joaat("ch_prop_vault_painting_01c"),
                joaat("ch_prop_vault_painting_01d"),
                joaat("ch_prop_vault_painting_01e"),
                joaat("ch_prop_vault_painting_01f"),
                joaat("ch_prop_vault_painting_01g"),
                joaat("ch_prop_vault_painting_01h"),
                joaat("ch_prop_vault_painting_01i"),
                joaat("ch_prop_vault_painting_01j")
            },{
                distance = 1.5,
                options = {
                    {
                        icon = 'fas fa-info',
                        label = Lang.bank_tryLoot,
                        action = self.RobArt
                    },
                    {
                        icon = 'fas fa-viruses',
                        label = Lang.bank_tryDestroy,
                        action = self.DestroyArt
                    }
                }
            })
        end
    end

end

function Cyr:RegisterEvents()
    Utils.RegisterNetEvent("plouffe_cayorobbery:setGuardsTasks", self.UpdateGuardTask)

    AddEventHandler("plouffe_cayorobbery:onZone", function(params)
        if self[params.fnc] then
            self[params.fnc](self, params)
        end
    end)

    AddStateBagChangeHandler("cayoRobberyState" ,"global", self.HandleState)

    AddEventHandler("plouffe_cayorobbery:inMansion", self.InMansion)
    AddEventHandler("plouffe_cayorobbery:exitMansion", self.ExitMansion)

    AddEventHandler("plouffe_cayorobbery:RobPainting", self.RobArt)
    AddEventHandler("plouffe_cayorobbery:DestroyPainting", self.DestroyArt)

    AddEventHandler("plouffe_cayorobbery:RobJewel", self.RobJewel)
    AddEventHandler("plouffe_cayorobbery:DestroyJewel", self.DestroyJewel)
end

function Cyr:ExportAllZones()
    for k,v in pairs(self.Zones) do
        local registered, reason = exports.plouffe_lib:Register(v)
    end

    if GlobalState.cayoRobberyState == "Started" then
        for k,v in pairs(Cyr.HiddenZones) do
            local registered, reason = exports.plouffe_lib:Register(v)
        end
    end
end

function Cyr.HandleState(bagName,key,value,reserved,replicated)
    if value == "Started" then
        aiPeds = Utils.GetPeds()
        for k,v in pairs(Cyr.HiddenZones) do
            local registered, reason = exports.plouffe_lib:Register(v)
        end
    elseif value == "Finished" then
        aiPeds = nil
        for k,v in pairs(Cyr.HiddenZones) do
            exports.plouffe_lib:DestroyZone(k)
        end
    end
end

function Cyr.UpdateGuardTask(list)
    local coords = vector3(5025.201171875, -5754.1538085938, 16.278739929199)
    local current = 1

    for k,v in pairs(Cyr.Guards.coords) do
        local ped = NetworkGetEntityFromNetworkId(list[current])

        Utils.AssureEntityControl(ped)

        SetEntityCoords(ped, v.x, v.y, v.z - 1.0)
        FreezeEntityPosition(ped, false)

        SetPedAsCop(ped, true)
        SetPedDropsWeaponsWhenDead(ped, false)
        TaskWanderInArea(ped, coords.x, coords.y, coords.z, 50.0, 8, 0.2)

        current = current + 1
    end
end

function Cyr:GetClosestAi()
    local coords = GetEntityCoords(PlayerPedId())

    for k,v in pairs(aiPeds) do
        local pedCoords = GetEntityCoords(v)

        if not IsPedAPlayer(v) and GetEntityModel(v) == self.Utils.aiModel then
            if IsPedDeadOrDying(v) then
                DeleteEntity(v)
            elseif #(pedCoords - coords) < 10 then
                return v
            end
        end
    end
end

function Cyr:SearchKey(params)
    if Interface.Progress.Circle({
        duration = 7500,
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true
        },
        anim = {
            dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
            clip = "machinic_loop_mechandplayer",
            flag = 1
        }
    }) then
        TriggerServerEvent("plouffe_cayorobbery:lootkey", params.zone, Cyr.Utils.MyAuthKey)
    end
end

function Cyr.InMansion()
    Cyr.inMansion = true

    if not aiPeds then
        aiPeds = Utils.GetPeds()
    end

    while Cyr.inMansion do
        local sleepTimer = 1000

        if GlobalState.cayoRobberyState == "Started" then
            if not LocalPlayer.state.dead then
                local guard = Cyr:GetClosestAi()
                if guard then
                    TaskCombatPed(guard, PlayerPedId(), 0, 16)
                end
            end
        end

        Wait(sleepTimer)
    end
end

function Cyr.ExitMansion()
    Cyr.inMansion = nil
    aiPeds = nil
end

function Cyr.GetDoorIndex(key)
    for k,v in pairs(Cyr.Doors[key]) do
        if exports.plouffe_lib:IsInZone(k) then
            return k
        end
    end

    return nil
end

function Cyr:GetAnimVersion(coords)
    for k,v in pairs(Cyr.Art.coords) do
        if #(coords - v.frameCoords) < 3.0 then
            return v.version
        end
    end
    return 2
end

function Cyr:GetClosestPainting(pedCoords)
    for k,v in pairs(self.Art.models) do
        local entity = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 1.0, joaat(v), false, false, false)

        if DoesEntityExist(entity) then
            return entity
        end
    end
end

function Cyr:GetClosestFrame(pedCoords)
    for k,v in pairs(self.Art.frames) do
        local entity = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 2.0, joaat(k), false, false, false)

        if DoesEntityExist(entity) then
            return entity, v.offset
        end
    end
end

function Cyr.RobArt()
    if GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    if Utils.GetItemCount("WEAPON_SWITCHBLADE") < 1 then
        return Interface.Notifications.Show({
            style = "error",
            header = "Cayo heist",
            message = Lang.cayoheist_needSwitchBlade
        })
    end

    local Art = Animation.Art:Enter()
    local steps = {"One", "Two", "Three", "Four"}
    local currentStep = 1

    if not Art then
        return
    end

    repeat
        local succes = Interface.Lockpick.New({
            amount = 0,
            range = 25,
            maxKeys = 4
        })

        Wait(0)
        if succes then
            Art[steps[currentStep]](Art)
            currentStep = currentStep + 1
        end

    until currentStep > #steps or not succes

    if currentStep <= #steps then
        return Art:Failed()
    end

    Art:Succes()
end
exports("RobArt", Cyr.RobArt)

function Cyr.DestroyArt()
    local finished = Interface.Progress.Circle({
        duration = 10000,

        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    })

    if not finished then
        return
    end

    local entity = Cyr:GetClosestPainting(GetEntityCoords(PlayerPedId()))

    TriggerServerEvent("plouffe_cayorobbery:destroyPainting", NetworkGetNetworkIdFromEntity(entity), Cyr.Utils.MyAuthKey)
end
exports("DestroyArt", Cyr.DestroyArt)

function Cyr.DestroyJewel()
    local finished = Interface.Progress.Circle({
        duration = 10000,

        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    })

    if not finished then
        return
    end

    local pedCoords = GetEntityCoords(PlayerPedId())
    local diamondEntity = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 2.0, joaat(Cyr.Diamond.model), false, false, false)
    local diamondEntityNetId = NetworkGetNetworkIdFromEntity(diamondEntity)

    TriggerServerEvent("plouffe_cayorobbery:destroyJewel", diamondEntityNetId, Cyr.Utils.MyAuthKey)
end
exports("DestroyJewel", Cyr.DestroyJewel)

function Cyr.TryThermal()
    if GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    local door = Cyr.GetDoorIndex("Thermal")

    if not door then
        return
    end

    local Thermal = Animation.Thermal:Start()

    if not Thermal then
        return
    end

    TriggerServerEvent("plouffe_cayorobbery:removeItem", Cyr.thermalItem, 1, Cyr.Utils.MyAuthKey)

    local succes = Interface.Lines.New({
        time = 25,
        maxMoves = 8,
        points = 15
    })

    if not succes then
        return Thermal:Finished()
    end

    Thermal:Succes()

    TriggerServerEvent("plouffe_cayorobbery:gate_thermal", succes, door, Cyr.Utils.MyAuthKey)
end
exports("TryThermal", Cyr.TryThermal)

function Cyr.RobJewel()
    if GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    if Utils.GetItemCount(Cyr.glassCutterItem) < 1 then
        return
    end

    local Cutting = Animation.Cutting:Enter()
    local fails = 0
    local wins = 0

    if not Cutting then
        return
    end

    repeat
        Interface.Progress.Circle({
            duration = 10000,

            useWhileDead = false,
            canCancel = false,
            disable = {
                move = true,
                car = true,
                combat = true
            }
        })

        local succes = false
        local randi = math.random(1,2)

        if randi == 1 then
            succes = Interface.MemorySquares.New({
                time = 20,
                amount = 8,
                solutionAmount = 5,
                errors = 1,
                delay = 2
            })
        elseif randi == 2 then
            succes = Interface.MemorySquares.New({
                time = 20,
                amount = 16,
                solutionAmount = 4,
                errors = 1,
                delay = 2
            })
        end

        if not succes then
            fails = fails + 1
            wins = 0
            Cutting:Overheat()
        else
            wins = wins + 1
        end

        Wait(1000)
    until fails >= 3 or wins >= 3

    if fails >= 3 then
        return Cutting:Failed()
    end

    Cutting:Success()
end
exports("RobJewel", Cyr.RobJewel)

function Cyr.TryElevatorHack()
    if not exports.plouffe_lib:IsInZone("cayo_mansion_office_elevator_1") or GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    local Hack = Animation.Laptop:Start()

    if not Hack then
        return false
    end

    Hack:Loop()

    local success = Interface.MovingSquare.New({
        time = 20,
        amount = 4,
        errors = 1,
        delay = 2
    })

    TriggerServerEvent("plouffe_cayorobbery:hacked_elevator", success, Cyr.Utils.MyAuthKey)

    Hack:Exit()
end
exports("TryElevatorHack", Cyr.TryElevatorHack)

function Cyr.TryHack()
    if Utils.GetItemCount(Cyr.hackItem) < 1 then
        return
    end

    local doorIndex = Cyr.GetDoorIndex("Hack")

    if not doorIndex then
        return
    end

    local hours = GetClockHours()

    if hours > 5 and hours < 20 then
        return Interface.Notifications.Show({
            style = "error",
            header = "Cayo heist",
            message = Lang.cayoheist_waitNight
        })
    end

    local Hack = Animation.Hack:Start()

    if not Hack then
        return
    end

    local success = Interface.MovingSquare.New({
        time = 25,
        amount = 4,
        errors = 1,
        delay = 4
    })

    if not success then
        return Hack:Failed()
    end

    if GlobalState.cayoRobberyState == "Ready" and GetResourceState("plouffe_dispatch") == "started" then
        exports.plouffe_dispatch:SendAlert("10-90 F")
    end

    Hack:Succes()

    TriggerServerEvent("plouffe_cayorobbery:doorHacked", doorIndex, "Hack", Cyr.Utils.MyAuthKey)
end
exports("TryHack", Cyr.TryHack)

function Cyr.TryUnlockDoor(data, data2)
    data = data.metadata and data or data2.metadata and data2
    if GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    local door

    if Cyr.inventoryConfig == "ox" then
        local zoneName = ("%s_%s"):format(data.metadata.door, 1)

        if not exports.plouffe_lib:IsInZone(zoneName) then
            return Interface.Notifications.Show({
                style = "error",
                header = "Cayo heist",
                message = Lang.cayoheist_wrongKey
            })
        end

        door = data.metadata.door
    else
        for k,v in pairs(Cyr.Doors.Houses) do
            local name = ("%s_%s"):format(k, 1)
            if exports.plouffe_lib:IsInZone(name) then
                door = k
                break
            end
        end

        if not door then
            return Interface.Notifications.Show({
                style = "error",
                header = "Cayo heist",
                message = Lang.cayoheist_wrongKey
            })
        end
    end

    TriggerServerEvent("plouffe_cayorobbery:unlockDoor", door, Cyr.Utils.MyAuthKey)

    Utils.PlayAnim(1000, "anim@mp_player_intmenu@key_fob@","fob_click",48,2.0, 2.0, 500)
end
exports("TryUnlockDoor", Cyr.TryUnlockDoor)

function Animation.Cutting:Prepare()
    RequestScriptAudioBank("DLC_HEI4/DLCHEI4_GENERIC_01", false)

    local animLoaded = Utils.AssureAnim(self.dict, true)
    local fxLoaded = Utils.AssureFxAsset(self.ptfxAsset, true)

    self.ped = PlayerPedId()
    self.pedCoords = GetEntityCoords(self.ped)

    self.boneIndex = GetPedBoneIndex(self.ped, 0x49D9)

    self.diamondEntity = GetClosestObjectOfType(self.pedCoords.x, self.pedCoords.y, self.pedCoords.z, 2.0, joaat(Cyr.Diamond.model), false, false, false)

    if not DoesEntityExist(self.diamondEntity) then
        return false
    end

    self.diamondNetId = NetworkGetNetworkIdFromEntity(self.diamondEntity)

    self.displayEntity = GetClosestObjectOfType(self.pedCoords.x, self.pedCoords.y, self.pedCoords.z, 1.0, -1714533217, false, false, false)

    Utils.AssureEntityControl(self.displayEntity)

    self.displayEntityCoords = GetEntityCoords(self.displayEntity)
    self.displayEntityRotation = GetEntityRotation(self.displayEntity)

    if not DoesEntityExist(self.displayEntity) then
        return false
    end

    local entityHeading = GetEntityHeading(self.displayEntity)

    self.offset = GetOffsetFromEntityInWorldCoords(self.displayEntity, 0.0, 0.0, 0.0)

    SetEntityHeading(self.ped, entityHeading)
    SetEntityCoords(self.ped, self.offset.x , self.offset.y, self.offset.z)

    self.pedRotation = GetEntityRotation(self.ped)

    self.bagEntity =  Utils.CreateProp("hei_p_m_bag_var22_arm_s",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 4.0}, nil, true, true)
    self.glassEntity =  Utils.CreateProp("h4_prop_h4_glass_cut_01a",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 5.0}, nil, true, true)
    self.cutterEntity = Utils.CreateProp("h4_prop_h4_cutter_01a",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 6.0}, nil, true, true)
    self.newDisplayEntity = Utils.CreateProp("h4_prop_h4_glass_disp_01b",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 8.0}, nil, true, true)

    SetEntityCollision(self.newDisplayEntity, false, true)
    SetEntityCollision(self.bagEntity, false, true)
    SetEntityCollision(self.glassEntity, false, true)
    SetEntityCollision(self.cutterEntity, false, true)

    FreezeEntityPosition(self.newDisplayEntity, true)
    FreezeEntityPosition(self.bagEntity, true)
    FreezeEntityPosition(self.glassEntity, true)
    FreezeEntityPosition(self.cutterEntity, true)

    SetEntityRotation(self.newDisplayEntity, self.displayEntityRotation.x, self.displayEntityRotation.y, self.displayEntityRotation.z )

    return true
end

function Animation.Cutting:Enter()
    if not self:Prepare() then
        return false
    end

    self.state = "Enter"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "enter_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.glassEntity, scene, self.dict, "enter_glass_display", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.cutterEntity, scene, self.dict, "enter_cutter", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)
    Wait(2900)
    scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "idle", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "idle_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.glassEntity, scene, self.dict, "idle_glass_display", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.cutterEntity, scene, self.dict, "idle_cutter", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)

    self:Loop()

    return self
end

function Animation.Cutting:Loop()
    self.state = "Loop"

    if not self.soundId then
        self.soundId = GetSoundId()
        PlaySoundFromEntity(self.soundId, "StartCutting", self.cutterEntity, "DLC_H4_anims_glass_cutter_Sounds", true, 0)
    end

    if not self.ptfx.loop then
        SetPtfxAssetNextCall(self.ptfxAsset)
        self.ptfx.loop = StartNetworkedParticleFxLoopedOnEntity('scr_ih_fin_glass_cutter_cut', self.glassEntity,  0.005, -0.35, 1.29, 0.0, 0.0, 0.0, 1.0, false, false, false, 1065353216, 1065353216, 1065353216, 0)
        SetParticleFxLoopedEvolution(self.ptfx.loop, "power", 1, false)
    end

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "cutting_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "cutting_loop_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.glassEntity, scene, self.dict, "cutting_loop_glass_display", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.cutterEntity, scene, self.dict, "cutting_loop_cutter", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)

    CreateThread(function()
        local i = 0

        while self.state == "Loop" and i <= 900 do
            Wait(0)
            i = i + 1
        end

        if i >= 900 then
            self:Loop()
        end
    end)
end

function Animation.Cutting:Success()
    local init = GetGameTimer()

    SetEntityCoords(self.newDisplayEntity, self.displayEntityCoords.x, self.displayEntityCoords.y, self.displayEntityCoords.z)
    DeleteEntity(self.displayEntity)
    SetEntityCollision(self.newDisplayEntity, true, true)
    SetEntityAsNoLongerNeeded(self.newDisplayEntity)
    self.newDisplayEntity = self.displayEntity

    self.state = "Success"
    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "success", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "success_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.glassEntity, scene, self.dict, "success_glass_display", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.cutterEntity, scene, self.dict, "success_cutter", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)
    Wait(1700)

    AttachEntityToEntity(self.diamondEntity, self.ped, self.boneIndex, 0.0, 0.0, 0.3, 0.0, 180.0, 0.0, false, false, false, false, 0, true)

    Wait(250)
    TriggerServerEvent("plouffe_cayorobbery:LootedDiamond", self.diamondNetId, Cyr.Utils.MyAuthKey)

    while DoesEntityExist(self.diamondEntity) and GetGameTimer() - init < 5000 do
        Wait(0)
    end

    if DoesEntityExist(self.diamondEntity) then
        DetachEntity(self.diamondEntity)
        DeleteEntity(self.diamondEntity)
    end

    self:Finished()
end

function Animation.Cutting:Failed()
    self.state = "Failed"
    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "exit_bag", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.glassEntity, scene, self.dict, "exit_glass_display", 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.cutterEntity, scene, self.dict, "exit_cutter", 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)
    Wait(2000)

    self:Finished()
end

function Animation.Cutting:Overheat()
    local lastState = self.state
    self.state = "Overheat"

    local randi = math.random(1,3)
    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, ("OVERHEAT_REACT_0%s"):format(randi), 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, ("OVERHEAT_REACT_0%s_bag"):format(randi), 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.glassEntity, scene, self.dict, ("OVERHEAT_REACT_0%s_glass_display"):format(randi), 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.cutterEntity, scene, self.dict, ("OVERHEAT_REACT_0%s_cutter"):format(randi), 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)

    Wait(1250)
    RemoveParticleFx(self.ptfx.overheat)
    Animation.Cutting[lastState](Animation.Cutting)
end

function Animation.Cutting:Finished()
    DeleteEntity(self.bagEntity)
    DeleteEntity(self.glassEntity)
    DeleteEntity(self.cutterEntity)
    DeleteEntity(self.newDisplayEntity)
    RemoveAnimDict(self.dict)
    RemovePtfxAsset(self.ptfxAsset)
    StopSound(self.soundId)
    ReleaseScriptAudioBank()
    SetEntityCollision(self.displayEntity, true, true)
    self.ptfx = {}
    self.soundId = nil
end

function Animation.Art:Prepare()
    Utils.AssureAnim(self.dict, true)
    Utils.AssureAnim("anim@heists@ornate_bank@hack", true)

    self.ped = PlayerPedId()
    self.pedCoords = GetEntityCoords(self.ped)

    self.version = Cyr:GetAnimVersion(self.pedCoords)

    self.frameEntity, self.offCoords = Cyr:GetClosestFrame(self.pedCoords)

    if not DoesEntityExist(self.frameEntity) then
        return false
    end

    local entityHeading = GetEntityHeading(self.frameEntity)

    self.offset = GetOffsetFromEntityInWorldCoords(self.frameEntity, self.offCoords.x, self.offCoords.y, self.offCoords.z)

    SetEntityHeading(self.ped, entityHeading)
    SetEntityCoords(self.ped, self.offset.x , self.offset.y, self.offset.z)

    self.pedRotation = GetEntityRotation(self.ped)

    self.bagEntity =  Utils.CreateProp("hei_p_m_bag_var22_arm_s",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 4.0}, nil, true, true)
    self.bladeEntity =  Utils.CreateProp("w_me_switchblade",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 5.0}, nil, true, true)

    SetEntityCollision(self.bagEntity, false, true)
    SetEntityCollision(self.bladeEntity, false, true)

    FreezeEntityPosition(self.bagEntity, true)
    FreezeEntityPosition(self.bladeEntity, true)

    return true
end

function Animation.Art:Enter(skipIntro)
    if not skipIntro then
        if not self:Prepare() then
            return false
        end

        self.state = "Enter"

        local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, ("VER_0%s_TOP_LEFT_ENTER"):format(self.version), 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, ("VER_0%s_TOP_LEFT_ENTER_hei_p_m_bag_var22_arm_s"):format(self.version), 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(self.frameEntity, scene, self.dict, ("VER_0%s_TOP_LEFT_ENTER_ch_Prop_vault_painting_01a"):format(self.version), 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(self.bladeEntity, scene, self.dict, ("VER_0%s_TOP_LEFT_ENTER_W_ME_SWITCHBLADE"):format(self.version), 4.0, -8.0, 1)

        NetworkStartSynchronisedScene(scene)
        Wait(1500)
    end

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, ("VER_0%s_CUTTING_TOP_LEFT_IDLE"):format(self.version), 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, ("VER_0%s_CUTTING_TOP_LEFT_IDLE_hei_p_m_bag_var22_arm_s"):format(self.version), 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.frameEntity, scene, self.dict, ("VER_0%s_CUTTING_TOP_LEFT_IDLE_ch_Prop_vault_painting_01a"):format(self.version), 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.bladeEntity, scene, self.dict, ("VER_0%s_CUTTING_TOP_LEFT_IDLE_W_ME_SWITCHBLADE"):format(self.version), 4.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)

    CreateThread(function()
        local i = 0

        while self.state == "Enter" and i <= 550 do
            Wait(0)
            i = i + 1
        end

        if i >= 550 then
            self:Enter(true)
        end
    end)

    return self
end

function Animation.Art:One(skipIntro)
    local timers = {1900, 1000}

    if not skipIntro then
        self.state = "One"
        local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, ("VER_0%s_CUTTING_TOP_LEFT_TO_RIGHT"):format(self.version), 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, ("VER_0%s_CUTTING_TOP_LEFT_TO_RIGHT_hei_p_m_bag_var22_arm_s"):format(self.version), 1.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(self.frameEntity, scene, self.dict, ("VER_0%s_CUTTING_TOP_LEFT_TO_RIGHT_ch_Prop_vault_painting_01a"):format(self.version), 1.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(self.bladeEntity, scene, self.dict, ("VER_0%s_CUTTING_TOP_LEFT_TO_RIGHT_W_ME_SWITCHBLADE"):format(self.version), 1.0, -8.0, 1)

        NetworkStartSynchronisedScene(scene)
        Wait(timers[self.version])
    end

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, ("VER_0%s_CUTTING_TOP_RIGHT_IDLE"):format(self.version), 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, ("VER_0%s_CUTTING_TOP_RIGHT_IDLE_hei_p_m_bag_var22_arm_s"):format(self.version), 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.frameEntity, scene, self.dict, ("VER_0%s_CUTTING_TOP_RIGHT_IDLE_ch_Prop_vault_painting_01a"):format(self.version), 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.bladeEntity, scene, self.dict, ("VER_0%s_CUTTING_TOP_RIGHT_IDLE_W_ME_SWITCHBLADE"):format(self.version), 1.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    CreateThread(function()
        local i = 0

        while self.state == "One" and i <= 550 do
            Wait(0)
            i = i + 1
        end

        if i >= 550 then
            self:One(true)
        end
    end)
end

function Animation.Art:Two(skipIntro)
    local timers = {1850, 1500}

    if not skipIntro then
        self.state = "Two"

        local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, ("VER_0%s_CUTTING_RIGHT_TOP_TO_BOTTOM"):format(self.version), 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, ("VER_0%s_CUTTING_RIGHT_TOP_TO_BOTTOM_hei_p_m_bag_var22_arm_s"):format(self.version), 1.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(self.frameEntity, scene, self.dict, ("VER_0%s_CUTTING_RIGHT_TOP_TO_BOTTOM_ch_Prop_vault_painting_01a"):format(self.version), 1.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(self.bladeEntity, scene, self.dict, ("VER_0%s_CUTTING_RIGHT_TOP_TO_BOTTOM_W_ME_SWITCHBLADE"):format(self.version), 1.0, -8.0, 1)

        NetworkStartSynchronisedScene(scene)
        Wait(timers[self.version])
    end

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, ("VER_0%s_CUTTING_BOTTOM_RIGHT_IDLE"):format(self.version), 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, ("VER_0%s_CUTTING_BOTTOM_RIGHT_IDLE_hei_p_m_bag_var22_arm_s"):format(self.version), 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.frameEntity, scene, self.dict, ("VER_0%s_CUTTING_BOTTOM_RIGHT_IDLE_ch_Prop_vault_painting_01a"):format(self.version), 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.bladeEntity, scene, self.dict, ("VER_0%s_CUTTING_BOTTOM_RIGHT_IDLE_W_ME_SWITCHBLADE"):format(self.version), 1.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    CreateThread(function()
        local i = 0

        while self.state == "Two" and i <= 550 do
            Wait(0)
            i = i + 1
        end

        if i >= 550 then
            self:Two(true)
        end
    end)
end

function Animation.Art:Three(skipIntro)
    local timers = {1850, 1000}

    if not skipIntro then
        self.state = "Three"

        local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, ("VER_0%s_CUTTING_BOTTOM_RIGHT_TO_LEFT"):format(self.version), 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, ("VER_0%s_CUTTING_BOTTOM_RIGHT_TO_LEFT_hei_p_m_bag_var22_arm_s"):format(self.version), 1.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(self.frameEntity, scene, self.dict, ("VER_0%s_CUTTING_BOTTOM_RIGHT_TO_LEFT_ch_Prop_vault_painting_01a"):format(self.version), 1.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(self.bladeEntity, scene, self.dict, ("VER_0%s_CUTTING_BOTTOM_RIGHT_TO_LEFT_W_ME_SWITCHBLADE"):format(self.version), 1.0, -8.0, 1)

        NetworkStartSynchronisedScene(scene)
        Wait(timers[self.version])
    end

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, ("VER_0%s_CUTTING_TOP_LEFT_IDLE"):format(self.version), 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, ("VER_0%s_CUTTING_TOP_LEFT_IDLE_hei_p_m_bag_var22_arm_s"):format(self.version), 2.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.frameEntity, scene, self.dict, ("VER_0%s_CUTTING_TOP_LEFT_IDLE_ch_Prop_vault_painting_01a"):format(self.version), 2.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.bladeEntity, scene, self.dict, ("VER_0%s_CUTTING_TOP_LEFT_IDLE_W_ME_SWITCHBLADE"):format(self.version), 2.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    CreateThread(function()
        local i = 0

        while self.state == "Three" and i <= 550 do
            Wait(0)
            i = i + 1
        end

        if i >= 550 then
            self:Three(true)
        end
    end)
end

function Animation.Art:Four()
    local timers = {1000, 1000}

    self.state = "Four"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, ("VER_0%s_CUTTING_LEFT_TOP_TO_BOTTOM"):format(self.version), 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, ("VER_0%s_CUTTING_LEFT_TOP_TO_BOTTOM_hei_p_m_bag_var22_arm_s"):format(self.version), 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.frameEntity, scene, self.dict, ("VER_0%s_CUTTING_LEFT_TOP_TO_BOTTOM_ch_Prop_vault_painting_01a"):format(self.version), 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.bladeEntity, scene, self.dict, ("VER_0%s_CUTTING_LEFT_TOP_TO_BOTTOM_W_ME_SWITCHBLADE"):format(self.version), 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)
    Wait(timers[self.version])
end

function Animation.Art:Failed()
    self.state = "Failed"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, ("VER_0%s_TOP_LEFT_EXIT"):format(self.version), 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, ("VER_0%s_TOP_LEFT_EXIT_hei_p_m_bag_var22_arm_s"):format(self.version), 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.frameEntity, scene, self.dict, ("VER_0%s_TOP_LEFT_EXIT_ch_Prop_vault_painting_01a"):format(self.version), 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.bladeEntity, scene, self.dict, ("VER_0%s_TOP_LEFT_EXIT_W_ME_SWITCHBLADE"):format(self.version), 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    Wait(2000)

    self:Finished()
end

function Animation.Art:Succes()
    self.state = "Succes"

    local entity = Cyr:GetClosestPainting(self.offset)

    if not entity then
        return
    end

    local init = GetGameTimer()
    local netId = NetworkGetNetworkIdFromEntity(entity)

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, ("VER_0%s_CUTTING_BOTTOM_LEFT_IDLE"):format(self.version), 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, ("VER_0%s_CUTTING_BOTTOM_LEFT_IDLE_hei_p_m_bag_var22_arm_s"):format(self.version), 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.frameEntity, scene, self.dict, ("VER_0%s_CUTTING_BOTTOM_LEFT_IDLE_ch_Prop_vault_painting_01a"):format(self.version), 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.bladeEntity, scene, self.dict, ("VER_0%s_CUTTING_BOTTOM_LEFT_IDLE_W_ME_SWITCHBLADE"):format(self.version), 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    TriggerServerEvent("plouffe_cayorobbery:paintingLooted", netId, Cyr.Utils.MyAuthKey)

    while DoesEntityExist(entity) and GetGameTimer() - init < 5000 do
        Wait(0)
    end

    if DoesEntityExist(entity) then
        DeleteEntity(entity)
    end

    scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, ("VER_0%s_TOP_LEFT_EXIT"):format(self.version), 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, ("VER_0%s_TOP_LEFT_EXIT_hei_p_m_bag_var22_arm_s"):format(self.version), 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.frameEntity, scene, self.dict, ("VER_0%s_TOP_LEFT_EXIT_ch_Prop_vault_painting_01a"):format(self.version), 4.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.bladeEntity, scene, self.dict, ("VER_0%s_TOP_LEFT_EXIT_W_ME_SWITCHBLADE"):format(self.version), 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    Wait(2000)

    self:Finished()
end

function Animation.Art:Finished()
    self.state = "Finished"

    DeleteEntity(self.bagEntity)
    DeleteEntity(self.bladeEntity)
    RemoveAnimDict(self.dict)
    RemoveAnimDict("anim@heists@ornate_bank@hack")
end

function Animation.Hack:Prepare()
    local animLoaded = Utils.AssureAnim(self.dict, true)

    self.ped = PlayerPedId()
    self.pedCoords = GetEntityCoords(self.ped)
    self.pedRotation = GetEntityRotation(self.ped)

    self.connectorEntity = GetClosestObjectOfType(self.pedCoords.x, self.pedCoords.y, self.pedCoords.z, 1.0, 1321190118, false, false, false)

    if not DoesEntityExist(self.connectorEntity) then
        return false
    end

    self.offset = GetOffsetFromEntityInWorldCoords(self.connectorEntity, 0.018, 0.010, 0.0)

    self.usbEntity =  Utils.CreateProp("ch_prop_ch_usb_drive01x",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 4.0}, nil, true, true)
    self.phoneEntity =  Utils.CreateProp("prop_phone_ing",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 5.0}, nil, true, true)

    SetEntityCollision(self.usbEntity, false, true)
    SetEntityCollision(self.phoneEntity, false, true)

    FreezeEntityPosition(self.usbEntity, true)
    FreezeEntityPosition(self.phoneEntity, true)

    return true
end

function Animation.Hack:Start()
    if not self:Prepare() then
        return false
    end

    self.state = "Start"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "action_var_01", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.usbEntity, scene, self.dict, "action_var_01_ch_prop_ch_usb_drive01x", 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.phoneEntity, scene, self.dict, "action_var_01_prop_phone_ing", 1.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    Wait(3100)

    return self
end

function Animation.Hack:Loop()
    self.state = "Loop"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "hack_loop_var_01", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.usbEntity, scene, self.dict, "hack_loop_var_01_ch_prop_ch_usb_drive01x", 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.phoneEntity, scene, self.dict, "hack_loop_var_01_prop_phone_ing", 1.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    CreateThread(function()
        local i = 0

        while self.state == "Loop" and i <= 800 do
            Wait(0)
            i = i + 1
        end

        if i >= 800 then
            self:Loop()
        end
    end)
end

function Animation.Hack:Succes()
    self.state = "Succes"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "success_react_exit_var_01", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.usbEntity, scene, self.dict, "success_react_exit_var_01_ch_prop_ch_usb_drive01x", 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.phoneEntity, scene, self.dict, "success_react_exit_var_01_prop_phone_ing", 1.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    Wait(2000)

    self:Finished()
end

function Animation.Hack:Failed()
    self.state = "Failed"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "fail_react", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.usbEntity, scene, self.dict, "fail_react_ch_prop_ch_usb_drive01x", 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.phoneEntity, scene, self.dict, "fail_react_prop_phone_ing", 1.0, -8.0, 1)
    NetworkStartSynchronisedScene(scene)

    Wait(2000)

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.usbEntity, scene, self.dict, "exit_ch_prop_ch_usb_drive01x", 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.phoneEntity, scene, self.dict, "exit_prop_phone_ing", 1.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    Wait(2000)

    self:Finished()
end

function Animation.Hack:Finished()
    RemoveAnimDict(self.dict)
    DeleteEntity(self.phoneEntity)
    DeleteEntity(self.usbEntity)
end

function Animation.Laptop:Prepare()
    local animLoaded = Utils.AssureAnim(self.dict, true)

    self.ped = PlayerPedId()
    self.pedCoords = GetEntityCoords(self.ped)
    self.pedRotation = GetEntityRotation(self.ped)

    self.offset = GetOffsetFromEntityInWorldCoords(self.ped, 0.0, 0.8, 0.4)

    self.bagEntity =  Utils.CreateProp("hei_p_m_bag_var22_arm_s",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 5.0}, nil, true, true)
    self.laptopEntity =  Utils.CreateProp("hei_prop_hst_laptop",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 8.0}, nil, true, true)
    self.cardEntity =  Utils.CreateProp("hei_prop_heist_card_hack_02",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 10.0}, nil, true, true)

    SetEntityCollision(self.bagEntity, false, true)
    SetEntityCollision(self.laptopEntity, false, true)

    FreezeEntityPosition(self.bagEntity, true)
    FreezeEntityPosition(self.laptopEntity, true)

    return true
end

function Animation.Laptop:Start()
    if not self:Prepare() then
        return false
    end

    self.state = "Start"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "hack_enter", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "hack_enter_bag", 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.laptopEntity, scene, self.dict, "hack_enter_laptop", 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.cardEntity, scene, self.dict, "hack_enter_card", 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    Wait(6000)

    return self
end

function Animation.Laptop:Loop()
    self.state = "Loop"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "hack_loop_bag", 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.laptopEntity, scene, self.dict, "hack_loop_laptop", 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.cardEntity, scene, self.dict, "hack_loop_card", 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    CreateThread(function()
        local i = 0

        while self.state == "Loop" and i <= 500 do
            Wait(0)
            i = i + 1
        end

        if i >= 500 then
            self:Loop()
        end
    end)
end

function Animation.Laptop:Exit()
    self.state = "Exit"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "hack_exit", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "hack_exit_bag", 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.laptopEntity, scene, self.dict, "hack_exit_laptop", 1.0, -8.0, 1)
    NetworkAddEntityToSynchronisedScene(self.cardEntity, scene, self.dict, "hack_exit_card", 4.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    Wait(4000)

    self:Finished()
end

function Animation.Laptop:Finished()
    RemoveAnimDict(self.dict)
    DeleteEntity(self.bagEntity)
    DeleteEntity(self.laptopEntity)
    DeleteEntity(self.cardEntity)
end

function Animation.Thermal:Prepare()
    Utils.AssureAnim(self.dict, true)

    for k,v in pairs(self.ptfxAsset) do
        Utils.AssureFxAsset(v, true)
    end

    self.ped = PlayerPedId()
    self.pedCoords = GetEntityCoords(self.ped)
    self.pedRotation = GetEntityRotation(self.ped)
    self.boneIndex = GetPedBoneIndex(self.ped, 28422)
    self.offset = GetOffsetFromEntityInWorldCoords(self.ped, 0.3, 0.4, 0.1)

    self.bagEntity =  Utils.CreateProp("hei_p_m_bag_var22_arm_s",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 5.0}, nil, true, true)
    self.bombEntity =  Utils.CreateProp("hei_prop_heist_thermite",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 8.0}, nil, true, true)
    self.flashingBombEntity =  Utils.CreateProp("hei_prop_heist_thermite_flash",  {x = self.offset.x, y = self.offset.y, z = self.offset.z - 9.0}, nil, true, true)

    SetEntityCollision(self.bagEntity, false, true)
    SetEntityCollision(self.bombEntity, false, true)
    SetEntityCollision(self.flashingBombEntity, false, true)

    FreezeEntityPosition(self.bagEntity, true)
    FreezeEntityPosition(self.bombEntity, true)
    FreezeEntityPosition(self.flashingBombEntity, true)

    SetEntityVisible(self.flashingBombEntity, false, 0)

    return true
end

function Animation.Thermal:Start()
    if not self:Prepare() then
        return false
    end

    self.state = "Start"

    local scene = NetworkCreateSynchronisedScene(self.offset.x, self.offset.y, self.offset.z, self.pedRotation.x, self.pedRotation.y, self.pedRotation.z, 2, false, false, 1065353216, 0, 1.3)
    NetworkAddPedToSynchronisedScene(self.ped, scene, self.dict, "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(self.bagEntity, scene, self.dict, "bag_thermal_charge", 1.0, -8.0, 1)

    NetworkStartSynchronisedScene(scene)

    Wait(1500)

    AttachEntityToEntity(self.bombEntity, self.ped, self.boneIndex, 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)

    Wait(4000)

    DeleteEntity(self.bagEntity)
    DetachEntity(self.bombEntity, 1, 1)
    FreezeEntityPosition(self.bombEntity, true)

    local coords = GetEntityCoords(self.bombEntity)
    local rotation = GetEntityRotation(self.bombEntity)

    SetEntityCoords(self.flashingBombEntity, coords.x, coords.y, coords.z)
    SetEntityRotation(self.flashingBombEntity, rotation.x, rotation.y, rotation.z)

    return self
end

function Animation.Thermal:Succes()
    self.state = "Succes"
    local coords = GetEntityCoords(self.flashingBombEntity)

    SetEntityVisible(self.flashingBombEntity, true, 0)
    SetEntityVisible(self.bombEntity, false, 0)
    Wait(5000)

    TaskPlayAnim(self.ped, self.dict, "cover_eyes_intro", 3.0, 3.0, 1000, 36, 1, 0, 0, 0)
    TaskPlayAnim(self.ped, self.dict, "cover_eyes_loop", 3.0, 3.0, 5000, 49, 1, 0, 0, 0)

    SetPtfxAssetNextCall("scr_ch_finale")
    self.ptfx[#self.ptfx + 1] = StartNetworkedParticleFxLoopedOnEntity('scr_ch_finale_thermal_burn', self.bombEntity, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false, 1065353216, 1065353216, 1065353216, 0)
    Wait(3000)

    SetPtfxAssetNextCall("scr_ornate_heist")
    self.ptfx[#self.ptfx + 1] = StartNetworkedParticleFxLoopedOnEntity('scr_heist_ornate_metal_drip', self.bombEntity, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 2.0, false, false, false, 1065353216, 1065353216, 1065353216, 0)
    Wait(10000)

    SetPtfxAssetNextCall("pat_heist")
    self.ptfx[#self.ptfx + 1] = StartNetworkedParticleFxLoopedOnEntity('scr_heist_ornate_thermal_burn_patch', self.bombEntity, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false, 1065353216, 1065353216, 1065353216, 0)
    PlaySoundFromCoord(-1, "Gate_Lock_Break", coords.x, coords.y, coords.z, "DLC_HEISTS_ORNATE_BANK_FINALE_SOUNDS", true, 30, false)


    Wait(2000)

    self:Finished()
end

function Animation.Thermal:Finished()
    RemoveAnimDict(self.dict)

    DeleteEntity(self.bagEntity)
    DeleteEntity(self.bombEntity)
    DeleteEntity(self.flashingBombEntity)

    for k,v in pairs(self.ptfxAsset) do
        RemovePtfxAsset(v)
    end

    for k,v in pairs(self.ptfx) do
        StopParticleFxLooped(v)
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == "plouffe_cayorobbery" then
        Animation.Cutting:Finished()
        Animation.Hack:Finished()
        Animation.Art:Finished()
        Animation.Laptop:Finished()
        Animation.Thermal:Finished()
    end
end)