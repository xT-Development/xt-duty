if GetResourceState('ox_core') ~= 'started' then return end

local Ox = require '@ox_core.lib.init'

local PlayerData = {}

function getCharId()
    return PlayerData.charId
end

function getCharJob()
    return PlayerData.job.name, PlayerData.job.grade.level
end

function initPlayerData()
    PlayerData = Ox.GetPlayerData()
end

AddEventHandler('ox:playerLoaded', function()
    PlayerData = Ox.GetPlayerData()

    TriggerEvent('xt-duty:client:onLoad')
end)

AddEventHandler('ox:playerLogout', function()
    PlayerData = {}

    TriggerEvent('xt-duty:client:onUnload')
end)