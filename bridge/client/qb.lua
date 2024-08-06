if GetResourceState('qb-core') ~= 'started' then return end

local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}

function getCharId()
    return PlayerData.citizenid
end

function getCharJob()
    return PlayerData.job.name
end

function initPlayerData()
    PlayerData = QBCore.Functions.GetPlayerData()
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('xt-duty:client:onLoad')
end)

AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    TriggerEvent('xt-duty:client:onUnload')
end)