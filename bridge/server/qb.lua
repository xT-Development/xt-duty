if GetResourceState('qb-core') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

function getPlayer(src)
    return QBCore.Functions.GetPlayer(src)
end

function getCharID(src)
    local player = getPlayer(src)
    return player.PlayerData.citizenid
end

function getCharName(src)
    local player = getPlayer(src)
    return ('%s %s'):format(player.PlayerData.charinfo.firstname, player.PlayerData.charinfo.lastname)
end

function getPlayerJob(src)
    local player = getPlayer(src)
    return player.PlayerData.job.name, player.PlayerData.job.grade.level
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
    local player = getPlayer(src)
    if not player then return end
    
    player.Functions.SetJobDuty(state == 1)
end