if GetResourceState('es_extended') ~= 'started' then return end

local ESX = exports['es_extended']:getSharedObject()

function getPlayer(src)
    return ESX.GetPlayerFromId(src)
end

function getCharID(src)
    local player = getPlayer(src)
    return player.identifier
end

function getCharName(src)
    local player = getPlayer(src)
    return ('%s %s'):format(player.firstName, player.lastName)
end

function getPlayerJob(src)
    local player = getPlayer(src)
    return player.job.name, player.job.grade
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