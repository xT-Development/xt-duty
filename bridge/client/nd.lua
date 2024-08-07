if not lib.checkDependency('ND_Core', '2.0.0') then return end

NDCore = {}

lib.load('@ND_Core.init')

local PlayerData = {}

function getCharId()
    return PlayerData.id
end

function getCharJob()
    return PlayerData.groups
end

function initPlayerData()
    PlayerData = NDCore.getPlayer()
end

AddEventHandler('ND:characterLoaded', function(character)
    PlayerData = character

    TriggerEvent('xt-duty:client:onLoad')
end)

AddEventHandler('ND:characterUnloaded', function()
    PlayerData = table.wipe(PlayerData)

    TriggerEvent('xt-duty:client:onUnload')
end)