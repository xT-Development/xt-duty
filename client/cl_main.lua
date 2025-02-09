local config        = require 'configs.client'
local playerState   = LocalPlayer.state

-- Set Player Duty --
local function setDuty(state)
    local playerJob = allowedJobCheck()
    if not playerJob then return end

    local setState = state
    if type(state) == 'boolean' then
        setState = state and 1 or 0
    end

    local dutyInfo = { job = playerJob, state = setState }
    local isSet = lib.callback.await('xt-duty:server:setDuty', false, dutyInfo)
    if not isSet then return end

    local dutyStr = getDutyStr(setState)
    lib.notify({ title = dutyStr, type = 'info' })
end exports('setDuty', setDuty)

-- Toggle Player Duty --
local function toggleDuty()
    local playerJob = allowedJobCheck()
    if not playerJob then return end

    local newState = (playerState.onDuty == 0) and 1 or 0

    setDuty(newState)
end exports('toggleDuty', toggleDuty)

-- Set State on Load / Start --
local function initDutyState()
    local hasAllowedJob = allowedJobCheck()
    if not hasAllowedJob then
        playerState:set('onDuty', 0, true)
        if renewed_lib then
            playerState:set('renewed_service', false, true)
        end
        return
    end

    local cid = getCharId()
    local kvpStr = ('onDuty-%s'):format(cid)
    local setState = GetResourceKvpInt(kvpStr) or 0

    setDuty(setState)

    lib.print.info('Get Duty Statuts', getDutyStr(playerState.onDuty))
end

-- Save State on Unload / Stop --
local function saveDutyState()
    local cid = getCharId()
    local kvpStr = ('onDuty-%s'):format(cid)
    local hasAllowedJob = allowedJobCheck()
    if not hasAllowedJob then
        SetResourceKvpInt(kvpStr, 0)
        return
    end

    SetResourceKvpInt(kvpStr, playerState.onDuty)
    lib.print.info('Save Duty Status', getDutyStr(playerState.onDuty))
end

-- Handlers --
AddEventHandler('xt-duty:client:onLoad', function()
    Wait(100)
    initDutyState()
end)

AddEventHandler('xt-duty:client:onUnload', function()
    saveDutyState()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Wait(100)
    initDutyState()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    saveDutyState()
end)