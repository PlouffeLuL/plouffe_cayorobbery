local Auth = exports.plouffe_lib:Get("Auth")
local Utils = exports.plouffe_lib:Get("Utils")
local Groups = exports.plouffe_lib:Get("Groups")
local Lang = exports.plouffe_lib:Get("Lang")
local Inventory = exports.plouffe_lib:Get("Inventory")

local keyZones = {}
local activePeds = {}

local doors = {
	cayo_mansion_side_entrance_right_1 = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(4959.162109375, -5786.4965820313, 20.838098526001), maxDst = 1.0}
		},
		doors = {
			{model = -1439869581, coords = vec3(4960.498047, -5785.047363, 21.108732)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_side_entrance_right_2 = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(4964.3979492188, -5786.37109375, 20.877752304077), maxDst = 1.0}
		},
		doors = {
			{model = -1439869581, coords = vec3(4965.725586, -5787.680176, 21.108732)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_side_entrance_left_1 = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(5084.4311523438, -5731.5751953125, 15.772498130798), maxDst = 1.0}
		},
		doors = {
			{model = -1439869581, coords = vec3(5085.587891, -5733.124023, 15.952604)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_side_entrance_left_2 = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(5083.5986328125, -5736.7416992188, 15.677476882935), maxDst = 1.0}
		},
		doors = {
			{model = -1439869581, coords = vec3(5082.087891, -5737.809082, 15.952604)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_appartment_1 = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(5009.876953125, -5791.0517578125, 17.826713562012), maxDst = 1.5}
		},
		doors = {
			{model = -607013269, coords = vec3(5009.137695, -5791.290039, 18.027788)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_appartment_2 = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(5011.5522460938, -5784.3911132813, 17.831623077393), maxDst = 1.5}
		},
		doors = {
			{model = -607013269, coords = vec3(5011.866211, -5784.910156, 18.027788)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_mini_appartment_1 = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(5078.748046875, -5758.8715820313, 15.828651428223), maxDst = 1.5}
		},
		doors = {
			{model = -607013269, coords = vec3(5078.166016, -5758.353516, 16.025780)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_mini_appartment_2 = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(5085.2983398438, -5758.0112304688, 15.829655647278), maxDst = 1.5}
		},
		doors = {
			{model = -607013269, coords = vec3(5084.900879, -5758.598145, 16.025780)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_midle_appartment_1 = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(5026.73828125, -5733.2314453125, 17.864805221558), maxDst = 1.5}
		},
		doors = {
			{model = -607013269, coords = vec3(5027.139648, -5732.875977, 18.061674)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_midle_appartment_2 = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(5032.1484375, -5735.2143554688, 17.8570728302), maxDst = 1.5}
		},
		doors = {
			{model = -607013269, coords = vec3(5032.533691, -5735.610352, 18.061674)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_maingate_1 = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(4982.5517578125, -5711.1665039063, 19.880226135254), maxDst = 3.0}
		},
		doors = {
			{model = -1574151574, coords = vec3(4981.012207, -5712.747070, 20.781033)},
			{model = 1215477734, coords = vec3(4984.133789, -5709.248535, 20.781033)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_maingate_2 = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(4989.1352539063, -5717.013671875, 19.880226135254), maxDst = 3.0}
		},
		doors = {
			{model = -1574151574, coords = vec3(4990.681152, -5715.105957, 20.781033)},
			{model = 1215477734, coords = vec3(4987.587402, -5718.634766, 20.781033)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_office_entrance = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(5005.916015625, -5750.947265625, 28.84496307373), maxDst = 1.5}
		},
		doors = {
			{model = -607013269, coords = vec3(5006.242188, -5750.410645, 29.040907)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_office_elevator = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(5011.7055664063, -5749.9252929688, 28.939210891724), maxDst = 1.5}
		},
		doors = {
			{model = -576022807, coords = vec3(5011.749023, -5750.071289, 27.944746), auto = { distance = 5.0, rate = 1.0 }}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_vault_main = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(5008.0849609375, -5754.1049804688, 15.484435081482), maxDst = 0.8}
		},
		doors = {
			{model = -630812075, coords = vec3(5007.619629, -5753.608398, 15.572952)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_vault_room = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(5001.7587890625, -5746.4907226563, 14.840528488159), maxDst = 0.8}
		},
		doors = {
			{model = -1360938964, coords = vec3(5002.29, -5746.74, 14.9)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_vault_entrance_middle = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(4998.3110351563, -5742.5517578125, 14.840617179871), maxDst = 0.8}
		},
		doors = {
			{model = -2058786200, coords = vec3(4998.08, -5743.132, 14.94)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_vault_fuck_all = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(4989.6928710938, -5735.673828125, 14.840592384338), maxDst = 1.5}
		},
		doors = {
			{model = -607013269, coords = vec3(4989.270996, -5735.334961, 15.071644)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_vault_entrance_right = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(4992.2719726563, -5756.3447265625, 15.893159866333), maxDst = 0.8}
		},
		doors = {
			{model = -1360938964, coords = vec3(4992.82, -5756.65, 15.98)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_vault_entrance_left = {
		lock = true,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(5006.060546875, -5734.0522460938, 15.838903427124), maxDst = 0.8}
		},
		doors = {
			{model = -1360938964, coords = vec3(5006.60, -5734.46, 15.93)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_cage_panther = {
		lock = false,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(4977.5395507813, -5765.201171875, 20.981952667236), maxDst = 1.5}
		},
		doors = {
			{model = -1697935936, coords = vec3(4977.377, -5765.718, 21.083)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    },

	cayo_mansion_cage_box = {
		lock = false,
		lockOnly = true,
        interactCoords = {
			{coords = vector3(4972.359375, -5763.5771484375, 20.981658935547), maxDst = 1.5}
		},
		doors = {
			{model = -1697935936, coords = vec3(4972.14, -5764.13, 21.08)}
		},
        access = {
			groups = {
				police = {rankSpecific = 7}
			}
        }
    }
}

function Cyr.Init()
    local isValid = GetResourceKvpString("validated")

    if not isValid then
        print("^1=========== Please read =================^0")
        print("This resource requires advanced configuration ")
        print("Please make sure you read the documentation properly ")
        print("Once you have done so and understand you can type 'validate_cayo' in your server console and restart the resource ")

        RegisterCommand("validate_cayo", function ()
            print("Thank you for understanding, resource is validate")
            SetResourceKvp("validated", "true")
        end)

        return
    end

    Cyr.ValidateConfig()

    Utils.CreateDepencie("plouffe_doorlock", Cyr.ExportsAllDoors)
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

function Cyr.ValidateConfig()
    Cyr.thermalItem = GetConvar("plouffe_cayorobbery:thermal_item", "")
    Cyr.glassCutterItem = GetConvar("plouffe_cayorobbery:glass_cutter_item", "")
    Cyr.hackItem = GetConvar("plouffe_cayorobbery:hack_item", "")
    Cyr.elevatorHackItem = GetConvar("plouffe_cayorobbery:elevator_hack_item", "")
    Cyr.keyItem =  GetConvar("plouffe_cayorobbery:key_item", "")
    Cyr.diamondItem = GetConvar("plouffe_cayorobbery:diamond_item", "")
    Cyr.policeGroups = json.decode(GetConvar("plouffe_cayorobbery:police_groups", ""))
    Cyr.minCops = tonumber(GetConvar("plouffe_cayorobbery:min_cops", ""))
    Cyr.timeToRob = tonumber(GetConvar("plouffe_cayorobbery:time_to_rob", "")) -- hours
    Cyr.inventoryConfig = GetConvar("plouffe_lib:inventoryFramework", "")

    if not Cyr.thermalItem then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'thermal_item' convar. Refer to documentation")
        end
    elseif not Cyr.glassCutterItem then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'glass_cutter_item' convar. Refer to documentation")
        end
    elseif not Cyr.hackItem then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'hack_item' convar. Refer to documentation")
        end
    elseif not Cyr.elevatorHackItem then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'elevator_hack_item' convar. Refer to documentation")
        end
    elseif not Cyr.diamondItem then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'diamond_item' convar. Refer to documentation")
        end
    elseif not Cyr.policeGroups then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'police_groups' convar. Refer to documentation")
        end
    elseif not Cyr.minCops then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'min_cops' convar. Refer to documentation")
        end
    elseif not Cyr.timeToRob then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'time_to_rob' convar. Refer to documentation")
        end
    elseif not Cyr.keyItem then
        while true do
            Wait(1000)
            print("^1 [ERROR] ^0 Invalid configuration, missing 'key_item' convar. Refer to documentation")
        end
    end

    Cyr.timeToRob *= (60 * 60)

    return true
end

function Cyr.ExportsAllDoors()
    for k,v in pairs(doors) do
        exports.plouffe_doorlock:RegisterDoor(k,v, false)
    end
end

function Cyr.LoadPlayer()
    local playerId = source
    local registred, key = Auth.Register(playerId)

    while not Server.ready do
        Wait(100)
    end

    if registred then
        local data = Cyr:GetData()
        data.Utils.MyAuthKey = key
        TriggerClientEvent("plouffe_cayorobbery:getConfig", playerId, data)
    else
        TriggerClientEvent("plouffe_cayorobbery:getConfig", playerId, nil)
    end
end

function Cyr.PlayerRobbedPainting(netId, authkey)
    local playerId = source

    if not Auth.Validate(playerId,authkey) or not Auth.Events(playerId,"plouffe_cayorobbery:paintingLooted") then
        return
    end

    if GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    for k,v in pairs(Cyr.Art.coords) do
        if v.paintingNetId == netId then
            local paintingEntity = NetworkGetEntityFromNetworkId(v.paintingNetId)
            DeleteEntity(paintingEntity)
            v.paintingNetId = nil

            local one, two = v.model:find("prop_")
            local itemName = v.model:sub(two + 1,v.model:len())

            Inventory.AddItem(playerId, itemName, 1)

            if not Cyr:IsAnyEntityNotLooted() then
                GlobalState.cayoRobberyState = "Finished"
            end
            break
        end
    end
end

function Cyr.DestroyPainting(netId, authkey)
    local playerId = source

    if not Auth.Validate(playerId,authkey) or not Auth.Events(playerId,"plouffe_cayorobbery:destroyPainting") then
        return
    end

    if GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    for k,v in pairs(Cyr.Art.coords) do
        if v.paintingNetId and v.paintingNetId == netId then
            local paintingEntity = NetworkGetEntityFromNetworkId(v.paintingNetId)
            DeleteEntity(paintingEntity)
            v.paintingNetId = nil

            if not Cyr:IsAnyEntityNotLooted() then
                GlobalState.cayoRobberyState = "Finished"
            end
            break
        end
    end
end

function Cyr.PlayerLootedDiamond(netId, authkey)
    local playerId = source

    if not Auth.Validate(playerId,authkey) or not Auth.Events(playerId,"plouffe_cayorobbery:LootedDiamond") then
        return
    end

    if GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    if Cyr.Diamond.diamondNetId and Cyr.Diamond.diamondNetId == netId then
        local displayEntity = NetworkGetEntityFromNetworkId(Cyr.Diamond.diamondNetId)
        Cyr.Diamond.diamondNetId = nil

        DeleteEntity(displayEntity)

        Inventory.AddItem(playerId, Cyr.diamondItem, 1)

        if not Cyr:IsAnyEntityNotLooted() then
            GlobalState.cayoRobberyState = "Finished"
        end
    end
end

function Cyr.DestroyJewel(netId, authkey)
    local playerId = source

    if not Auth.Validate(playerId,authkey) or not Auth.Events(playerId,"plouffe_cayorobbery:destroyJewel") then
        return
    end

    if GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    if Cyr.Diamond.diamondNetId and Cyr.Diamond.diamondNetId == netId then
        local displayEntity = NetworkGetEntityFromNetworkId(Cyr.Diamond.diamondNetId)
        Cyr.Diamond.diamondNetId = nil

        DeleteEntity(displayEntity)

        if not Cyr:IsAnyEntityNotLooted() then
            GlobalState.cayoRobberyState = "Finished"
        end
    end
end

function Cyr.LootKey(zoneIndex, authkey)
    local playerId = source

    if not Auth.Validate(playerId,authkey) or not Auth.Events(playerId,"plouffe_cayorobbery:lootkey") then
        return
    end

    if keyZones[zoneIndex] then
        if Cyr.inventoryConfig == "ox" then
            Inventory.AddItem(playerId, Cyr.keyItem, 1, {door = keyZones[zoneIndex]})
        else
            Inventory.AddItem(playerId, Cyr.keyItem, 1)
        end
    end
end

function Cyr.ElevatorHack(success, authkey)
    local playerId = source

    if not Auth.Validate(playerId,authkey) or not Auth.Events(playerId,"plouffe_cayorobbery:hacked_elevator") then
        return
    end

    if GlobalState.cayoRobberyState ~= "Started" then
        return
    end

    if not success then
        return Inventory.ReduceDurability(playerId, Cyr.elevatorHackItem, 60 * 60 * 24)
    end

    Inventory.ReduceDurability(playerId, Cyr.elevatorHackItem, 60 * 60 * 48)

    exports.plouffe_doorlock:UpdateDoorState("cayo_mansion_office_elevator",false)
end

function Cyr.PlayerThermalGate(success, doorIndex, authkey)
    local playerId = source

    if not Auth.Validate(playerId,authkey) or not Auth.Events(playerId,"plouffe_cayorobbery:gate_thermal") then
        return
    end

    if GlobalState.cayoRobberyState ~= "Started" or not success then
        return
    end

    exports.plouffe_doorlock:UpdateDoorStateTable(Cyr.Doors.Thermal[doorIndex], false)
end

function Cyr.RemoveItem(item, amount, authkey)
    local playerId = source

    if not Auth.Validate(playerId,authkey) or not Auth.Events(playerId,"plouffe_cayorobbery:removeItem") then
        return
    end

    Inventory.RemoveItem(playerId, item, amount)
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

function Cyr:StartRobbery(playerId)
    local startTime = os.time()

    if GlobalState.cayoRobberyState ~= "Ready" then
        return false, Utils.Notify(playerId,{style = "inform", message = Lang.cayoheist_alreadyStolen, header = "Cayo perico"} )
    end

    local count = 0

    for k,v in pairs(self.policeGroups) do
        local cops = Groups.GetGroupPlayers(v)
        count += cops.len
    end

    if count < self.minCops then
        return false, Utils.Notify(playerId, Lang.bank_notEnoughCop)
    end

    Utils.Notify(playerId,{style = "succes", message = Lang.cayoheist_waitAfterHack, header = "Cayo perico"})

    self:RelockAllDoors()
    self:SetUpKeys()
    self:CreateAllFrames()
    self:CreateDiamond()
    self:CreateAllGuards()

    Utils.Notify(playerId,{style = "succes", message = Lang.cayoheist_finishedHack, header = "Cayo perico"})

    CreateThread(function()
        local sleepTimer = 1000 * 30

        while os.time() - startTime < self.timeToRob and GlobalState.cayoRobberyState == "Started" and self:IsAnyEntityNotLooted() do
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

    return true
end

function Cyr.UnlockDoor(doorIndex, doorType, authkey)
    local playerId = source

    if not Auth.Validate(playerId,authkey) or not Auth.Events(playerId,"plouffe_cayorobbery:doorHacked") then
       return
    end

    if GlobalState.cayoRobberyState == "Finished" then
        return
    end

    if not Cyr.Doors[doorType][doorIndex] then
        return
    end

    if doorType:lower() == "hack" and GlobalState.cayoRobberyState == "Ready" then
        if not Cyr:StartRobbery(playerId) then
            return
        end
    end

    for k,v in pairs(Cyr.Doors[doorType][doorIndex]) do
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

function Cyr:SetUpKeys()
    local usedRandi = {}

    for k,v in pairs(self.KeysMeta) do
        local len = Utils.TableLen(self.HiddenZones)
        local randi = math.random(1, len)

        repeat
            randi = math.random(1, len)
        until not usedRandi[randi]

        usedRandi[randi] = true

        local keyString = ("cyr_hidden_key_%s"):format(randi)

        keyZones[keyString] = k
    end
end

function Cyr.UsedKey(zoneIndex, authkey)
    local playerId = source

    if not Auth.Validate(playerId,authkey) or not Auth.Events(playerId,"plouffe_cayorobbery:unlockDoor") then
        return
    end

    if Cyr.KeysMeta[zoneIndex] then
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

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == "plouffe_cayorobbery" then
        Cyr:RemoveDiamond()
        Cyr:DeleteAllFrames()
        Cyr:DeleteAllGuards()
    end
end)

CreateThread(Cyr.Init)

-- RegisterCommand("CayoPed", function(s,a,r)
--     if a[1] then
--         return Cyr:DeleteAllGuards()
--     end

--     Cyr:CreateAllGuards()
-- end, true)

-- RegisterCommand("StartCayo", function(s,a,r)
--     if a[1] then
--         GlobalState.cayoRobberyState = "Finished"
--         return
--     end

--     Cyr:StartRobbery(s)
-- end, true)

-- RegisterCommand("Frame", function(s,a,r)
--     if a[1] then
--         return Cyr:DeleteAllFrames()
--     end

--     Cyr:CreateAllFrames()
-- end, true)

-- RegisterCommand("Diamond", function(s,a,r)
--     if a[1] then
--         return Cyr:RemoveDiamond()
--     end

--     Cyr:CreateDiamond()
-- end, true)