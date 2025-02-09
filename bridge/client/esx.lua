if GetResourceState('es_extended') ~= 'started' then return end

function playerData()
    return ESX.GetPlayerData()
end

function getCharId()
    local PlayerData = playerData()
    return PlayerData.identifier
end

function getCharJob()
    local PlayerData = playerData()
    return PlayerData.job.name
end

AddEventHandler('esx:playerLoaded', function(xPlayer)
    TriggerEvent('xt-duty:client:onLoad')
end)

AddEventHandler('esx:onPlayerLogout', function()
    TriggerEvent('xt-duty:client:onUnload')
end)