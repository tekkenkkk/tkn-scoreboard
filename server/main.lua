AddEventHandler('esx:setJob', function(source, job, lastjob)
    lib.func.updateCounter({source = source, add = {job.name}, remove = {lastjob.name}})
end)

-- AddEventHandler('esx:setSecondJob', function(source, job, lastjob)
--     lib.func.updateCounter({source = source, add = {job.name}, remove = {lastjob.name}})
-- end)

AddEventHandler('esx:setGroup', function(source, group)
    Player(source).state.admin = (group ~= 'user')
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    lib.func.updateCounter({source = source, add = {'players', xPlayer.job.name}})
    Player(xPlayer.source).state.admin = (xPlayer.group ~= 'user')
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Wait(500)

        lib.func.updateCounter({source = '*'})
    end
end)

AddEventHandler('esx:playerDropped', function(source)
    lib.func.updateCounter({source = source, disconnect = true})
end)

RegisterNetEvent('tkn-scoreboard:toggle')
AddEventHandler('tkn-scoreboard:toggle', function(toggle)
    lib.using[source] = toggle
    GlobalState.using = lib.using
end)