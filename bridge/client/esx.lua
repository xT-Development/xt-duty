if GetResourceState('es_extended') ~= 'started' then return end

local PlayerData = {}

function getCharId()
    return PlayerData.identifier
end

function getCharJob()
    return PlayerData.job.name
end

function initPlayerData()
    PlayerData = ESX.GetPlayerData()
end

AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer

    TriggerEvent('xt-duty:client:onLoad')
end)

AddEventHandler('esx:onPlayerLogout', function()
    PlayerData = table.wipe(PlayerData)

    TriggerEvent('xt-duty:client:onUnload')
end)