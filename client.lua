ESX = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(250)
	end
end)

cache = {
    counter = {},
    players = {},
    me = {
        data = {},
        distance = 40,
        admin = false,
        dead = false,
        display = false,
        prop = nil,
        id = 0,
        coords = vector3(0, 0, 0)
    }
}

_in = Citizen.InvokeNative

AddEventHandler("esx:onPlayerDeath", function()
	if not cache['me']['dead'] and cache['me']['job'] and cache['me']['job'] == 'police' then
		TriggerServerEvent('scoreboard:policeDead', true)
        cache['me']['dead'] = true
	end
end)

AddEventHandler("playerSpawned", function()
	if cache['me']['dead'] and cache['me']['job'] and cache['me']['job'] == 'police' then
		TriggerServerEvent('scoreboard:policeDead', false)
        cache['me']['dead'] = false
	end
end)

RegisterNetEvent('scoreboard:updateCache')
AddEventHandler('scoreboard:updateCache', function(updatedCache)
    if updatedCache['isAdmin'] ~= nil then
        cache['me']['admin'] = updatedCache['isAdmin']
        return
    end
    cache['counter'] = updatedCache
    SendNUIMessage({
        type = 'update',
        data = updatedCache
    })
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    updateJob({'job', job})
end)

RegisterNetEvent('esx:setSecondJob')
AddEventHandler('esx:setSecondJob', function(secondjob)
    updateJob({'secondjob', secondjob})
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    updateJob({'job', xPlayer.job})
    updateJob({'secondjob', xPlayer.secondjob})
end)

CreateThread(function()
    while true do
        if cache['me']['display'] then
            if type(cache['players']) == 'table' then
                for k,v in pairs(cache['players']) do
                    if #(cache['me']['coords'] - v[2]) < cache['me']['distance'] then
                        DrawText3D(v[2],k,v[1] and {0,255,0} or {255,255,255})
                    end
                end
            end
        else
            Wait(300)
        end
        Wait(1)
    end
end)

CreateThread(function()
    while true do
        Wait(250)
        if cache['me']['display'] then
            cache['me']['coords'] = GetEntityCoords(cache['me']['id'])
            cache['me']['distance'] = (cache['me']['admin'] and 60 or 40)
        else
            Wait(300)
        end
    end
end)

CreateThread(function()
    while true do
        if cache['me']['display'] then
            for _,__ in ipairs(GetActivePlayers()) do
                ___ = _in(0x43A66C31C68491C0, __)
                ____ = GetWorldPositionOfEntityBone(___, GetPedBoneIndex(___, 0x796E))
                if (_ == cache['me']['id']) or (#(cache['me']['coords'] - ____) < (cache['me']['admin'] and 60 or 40)) and IsEntityVisible(___) then
                    cache['players'][GetPlayerServerId(__)] = {NetworkIsPlayerTalking(__), ____}
                else
                    cache['players'][GetPlayerServerId(__)] = nil
                end
            end
        else
            Wait(300)
        end
        Wait(5)
    end
end)

counter = function(data)
    return cache['counter'][data] or 0
end
exports('counter', counter)

updateJob = function(data)
    cache['me'][data[1]] = data[2].name
    SendNUIMessage({
        type = 'update',
        data = {[data[1]] = data[2].label..' - '..data[2].grade_label}
    })
end

propSpawn = function(toggle)
    cache['me']['id'] = PlayerPedId()
    cache['me']['coords'] = GetEntityCoords(cache['me']['id'])
    cache['me']['distance'] = (cache['me']['admin'] and 60 or 40)
    if toggle then
        cache['me']['display'] = true
        if not cache['me']['admin'] then
            TriggerServerEvent("paradise_narration:draw", "Rozgląda się uważnie", "zetka")
            if GetEntityHealth(cache['me']['id']) > 0 and not IsPedInAnyVehicle(cache['me']['id'], false) and not IsPedFalling(cache['me']['id']) and not IsPedCuffed(cache['me']['id']) and not IsPedDiving(cache['me']['id']) and not IsPedInCover(cache['me']['id'], false) and not IsPedInParachuteFreeFall(cache['me']['id']) and GetPedParachuteState(cache['me']['id']) < 1 then
                ESX.Game.SpawnObject('p_cs_clipboard', cache['me']['coords'], function(object)
                    TaskPlayAnim(cache['me']['id'], 'amb@world_human_clipboard@male@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0.0, false, false, false)
                    AttachEntityToEntity(object, cache['me']['id'], GetPedBoneIndex(cache['me']['id'], 36029), 0.1, 0.015, 0.12, 45.0, -130.0, 180.0, true, false, false, false, 0, true)
                    cache['me']['prop'] = object
                end)
            end
        end
    else
        cache['me']['display'] = false
        StopAnimTask(cache['me']['id'], 'amb@world_human_clipboard@male@idle_a', 'idle_a', 1.0)
        DeleteObject(cache['me']['prop'])
    end
end

DrawText3D = function(coords, id, color)
    local x = coords[1]
    local y = coords[2]
    local z = coords[3] + .8

    local onScreen, _x, _y = World3dToScreen2d(x,y,z)
	
	local scale = (1 / #(GetGameplayCamCoords() - vec3(x, y, z))) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(1.0 * scale, 1.55 * scale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
		SetTextCentre(1)

        SetTextEntry('STRING')
        AddTextComponentString(id)
        DrawText(_x,_y)
    end
end

RegisterCommand('+scoreboard', function()
    while not HasAnimDictLoaded('amb@world_human_clipboard@male@idle_a') do
		RequestAnimDict('amb@world_human_clipboard@male@idle_a')
		Wait(5)
	end
    SendNUIMessage({
        type = 'open',
        data = {}
    })
    propSpawn(true)
end, false)

RegisterCommand('-scoreboard', function()
    SendNUIMessage({
        type = 'close',
        data = {}
    })
    cache['players'] = {}
    propSpawn(false)
end, false)

RegisterKeyMapping('+scoreboard', 'Lista graczy', 'keyboard', 'Z')