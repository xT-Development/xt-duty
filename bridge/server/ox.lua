if GetResourceState('ox_core') ~= 'started' then return end

local Ox = require '@ox_core.lib.init'

function getPlayer(id)
    return Ox.GetPlayer(id)
end

function getCharID(src)
    local player = getPlayer(src)
    return player.charId
end

function getCharName(src)
    local player = getPlayer(src)
    return player.name
end

function getPlayerJob(src)
    local player = getPlayer(src)
    return player.getGroup()
end

function hasGroup(src, group)
    local player = getPlayer(src)
    local pJob = getPlayerJob(src)
    local callback = false

    if not player then
        return callback
    end

    if (pJob == group) then
        callback = true
    end

    return callback
end

function handleBridgeDutyChange(src, state)
    return true
end