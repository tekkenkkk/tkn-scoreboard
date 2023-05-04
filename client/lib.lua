exports('counter', function(key)
    return GlobalState.counter and GlobalState.counter[key] or 0
end)