ESX = exports['es_extended']:getSharedObject()
isStore = false 
lastCoords = nil 
cam = nil
OutfitKeys = {}
outfitData = {}
lastWorking = nil 
currentSex = nil 
Citizen.CreateThread(function()


    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end

    outfitData = ESX.GetConfig("Outfit")
    OutfitKeys = ESX.GetConfig().OutfitKeys
    for k,v in pairs(Config.Stores) do
		CreateBlip("Clothes Shop", v.Coords, 73, 0.8, 30)
        exports['rep-talkNPC']:CreateNPC({
            npc = v.Model,
            coords = v.Coords,
			heading = v.Heading,
            name = 'Manager',
			animName ="amb@world_human_stand_impatient@male@no_sign@idle_a",
			animDist = "idle_a",
            startMSG = 'Hello, I am a sales associate at this store. I assure you that our clothing selection is complete and the most up-to-date in this city. How may I help you?'
        }, {
            {label = "I'd like to buy some clothes.", value = 1},
            {label = "Have a conversation", value = 2},
        }, function(ped, data, menu)
            if data then
                if data.value == 1 then
                    menu.close()
                    hideNUI()
                    OpenComponentStore(v)
                elseif data.value == 2 then
                    menu.addMessage({msg = "I can't help you with anything right now.", from = "npc"})
                    Wait(1000)
                    menu.close()
                end
            end
        end)
	end
end)

function OpenComponentStore(storeData)
    local sex = ESX.CreatePromise(function(cb) TriggerEvent("skinchanger:getSkin", function(data) cb(data.sex) end) end)
    if sex == 0 then currentSex = "male" else currentSex = "female" end
    lastWorking = exports["buzzer_outfit"]:getWorking()
    exports["buzzer_outfit"]:setWorking(nil)
    local ped = PlayerPedId()
    lastCoords = GetEntityCoords(ped)
    SetEntityCoords(ped, storeData.InStore.Coords)
    SetEntityHeading(ped, storeData.InStore.Heading)
    Wait(500)
    ToggleUI(true)
    local plyCam =  CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", lastCoords.x, lastCoords.y, lastCoords.z, 0.00, 0.00, 0.00, 50.00, false, 0)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", storeData.InStore.Coords.x, storeData.InStore.Coords.y, storeData.InStore.Coords.z, 0.00, 0.00, 0.00, 50.00, false, 0)
    SetCamActiveWithInterp(cam, plyCam, 2000, true, true)
    SetCamFocusAt(cam, "body")
    RenderScriptCams(true, false, 0, true, true)
    while isStore do
        Wait(100)
    end
    SetEntityCoords(ped, lastCoords)
    SetCamActive(cam,  false)
    DestroyAllCams(true)
    RenderScriptCams(false,  false,  0,  true,  true)
    exports["buzzer_outfit"]:setWorking(nil)
    exports["buzzer_outfit"]:setWorking(lastWorking)
end



RegisterNUICallback("request_component", function(data)
    local component = data.component
    local group
    for k,v in pairs(OutfitKeys) do
        for k2,v2 in pairs(v) do
            if k2 == component then
                group = k
                break
            end
        end
    end
    local key = ESX.GetOutfitKey(group, currentSex, component)
    local componentData = outfitData[key]
    SendNUIMessage({
        action = "set_component_data",
        group = group,
        component = component,
        data = componentData,
    })
end)


RegisterNUICallback("set_component", function(data)
    exports["buzzer_outfit"]:setWorking(nil)
    local outfitConfig = OutfitKeys[data.group][data.component]
    local previewData = {}
    previewData[outfitConfig.Key[1]] = tonumber(data.value_1)
    previewData[outfitConfig.Key[2]] = tonumber(data.value_2)
    exports["buzzer_outfit"]:setWorking({
        [0] = previewData,
        [1] = previewData,
    })
end)


RegisterNUICallback("buy_component", function(data)
    TriggerServerEvent("buzzer_clotheshop:buyComponent", data.group, currentSex, data.component, data.value_1, data.value_2)
end)


RegisterNUICallback('set_cam', function(data)
    SetCamFocusAt(cam, data.focus)
end)

RegisterNUICallback('rot_cam', function(data)
    local Ped = GetPlayerPed(-1)
	local heading = GetEntityHeading(Ped) + tonumber(data.rot_z) + 0.0
	SetEntityHeading(Ped, heading)
end)

RegisterNUICallback("close", function(data, cb)
    ToggleUI(false)
end)


function ToggleUI(bool)
    isStore = bool
    TriggerEvent("hm_server:toggleAllHud", not bool)
    if bool then 
        SendNUIMessage({action = "show"})
    else
        SendNUIMessage({action = "hide"})
    end
    SetNuiFocus(bool, bool)
end

function CreateBlip(name, Coords, sprite, scale, colour)
    blip = AddBlipForCoord(Coords)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 2)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blip)
    return blip 
end


function SetCamFocusAt(cam, focus)
    local ped = PlayerPedId()
    local camCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 1.2, 0.0)
    local zAdd = -0.7
    if focus == "up_body" then 
        zAdd = 0.35
    elseif focus == 'low_body' then
        zAdd = -0.3
    elseif focus == "head" then 
        zAdd = 0.7
    elseif focus == "foot" then 
        zAdd = -0.7
    end
    camCoords = camCoords + vector3(0, 0, zAdd)
    SetCamCoord(cam,  camCoords.x,  camCoords.y,  camCoords.z)
    PointCamAtEntity(cam,  ped, 0.0, 0.0, zAdd, true)
end