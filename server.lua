local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

cache = {
    ['gracze'] = 0,
    ['police'] = 0,
    ['ambulance'] = 0,
    ['mecano'] = 0,
    ['cardealer'] = 0
}

AddEventHandler('esx:setJob', function(_,job,lastjob)
    updateCache({job.name, job.grade}, {lastjob.name, lastjob.grade})
end)

AddEventHandler('esx:setSecondJob', function(_,job,lastjob)
    updateCache({job.name, job.grade}, {lastjob.name, lastjob.grade})
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    updateCache({xPlayer.job.name, xPlayer.job.grade})
    updateCache({xPlayer.secondjob.name, xPlayer.secondjob.grade})
    updateCache({'gracze'})
    TriggerClientEvent('scoreboard:updateCache', xPlayer.source, {['isAdmin'] = IsPlayerAceAllowed(xPlayer.source, "easyadmin.ban")})
end)

isDead = {}

AddEventHandler('esx:playerDropped', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not isDead[xPlayer.source] then
        updateCache(nil, {xPlayer.job.name, xPlayer.job.grade})
    end
    updateCache(nil, {xPlayer.secondjob.name, xPlayer.secondjob.grade})
    updateCache(nil, {'gracze'})
end)

RegisterNetEvent('scoreboard:policeDead')
AddEventHandler('scoreboard:policeDead', function(state)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name ~= 'police' then return end
    if state then
        if isDead[xPlayer.source] then return end
        updateCache(nil, {xPlayer.job.name, xPlayer.job.grade})
        isDead[xPlayer.source] = true
    else
        updateCache({xPlayer.job.name, xPlayer.job.grade})
        isDead[xPlayer.source] = nil
    end
end)

updateCache = function(first, second)
    block = {}
    if first then
        if first[1] == 'police' then
            if first[2] < 2 then
                block['first'] = true
            end
        end
        if not block['first'] and cache[first[1]] then
            cache[first[1]] = cache[first[1]] + 1
        end
    end

    if second then
        if second[1] == 'police' then
            if second[2] < 2 then
                block['second'] = true
            end
        end
        if not block['second'] and cache[second[1]] then
            if cache[second[1]] > 0 then
                cache[second[1]] = cache[second[1]] - 1
            end
        end
    end

    TriggerClientEvent('scoreboard:updateCache', -1, cache)
end
