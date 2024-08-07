if not lib.checkDependency('ND_Core', '2.0.0') then return end

NDCore = {}

lib.load('@ND_Core.init')

function getPlayer(src)
    return NDCore.getPlayer(src)
end

function getCharID(src)
    local Player = getPlayer(src)
    return Player.identifier
end

function getCharName(src)
    local player = getPlayer(src)
    return ('%s %s'):format(player.firstname, player.lastname)
end

function getPlayerJob(src)
    local Player = getPlayer(src)
    return Player.getJob()
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