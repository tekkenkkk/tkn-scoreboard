lib = {
    func = {},
    using = {},
    cache = {
        counter = {
            ['players'] = 0,
            ['police'] = 0,
            ['ambulance'] = 0,
            ['mechanic'] = 0,
            ['cardealer'] = 0,
        }
    }
}

lib.func.updateCounter = function(data)
    if not data then
        return
    end

    if data.source == '*' then
        for k,v in pairs(ESX.GetExtendedPlayers()) do
            lib.func.updateCounter({add = {'players', v.job.name}})
        end
        return
    end

    local xPlayer = data.xPlayer or ESX.GetPlayerFromId(data.source)

    if data.disconnect then
        lib.func.updateCounter({source = data.source, remove = {'players', xPlayer.job.name}})
        return
    end

    local add = data.add or {}
    local remove = data.remove or {}

    for i=1, #add do
        if lib.cache.counter[add[i]] then
            lib.cache.counter[add[i]] = lib.cache.counter[add[i]] + 1
        end
    end

    for i=1, #remove do
        if lib.cache.counter[remove[i]] then
            lib.cache.counter[remove[i]] = lib.cache.counter[remove[i]] - 1
        end
    end

    GlobalState.counter = lib.cache.counter
end

exports('serverCounter', function(name)
    return lib.cache.counter[name]
end)