if GetResourceState('qb-core') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()

function playerData()
    return QBCore.Functions.GetPlayerData()
end

function getCharId()
    local PlayerData = playerData()
    return PlayerData.citizenid
end

function getCharJob()
    local PlayerData = playerData()
    return PlayerData.job.name
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('xt-duty:client:onLoad')
end)

AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    TriggerEvent('xt-duty:client:onUnload')
end)