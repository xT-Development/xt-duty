if not lib.checkDependency('ND_Core', '2.0.0') then return end

NDCore = {}

lib.load('@ND_Core.init')

function playerData()
    return NDCore.getPlayer()
end

function getCharId()
    local PlayerData = playerData()
    return PlayerData.id
end

function getCharJob()
    local PlayerData = playerData()
    return PlayerData.groups
end

AddEventHandler('ND:characterLoaded', function(character)
    TriggerEvent('xt-duty:client:onLoad')
end)

AddEventHandler('ND:characterUnloaded', function()
    TriggerEvent('xt-duty:client:onUnload')
end)