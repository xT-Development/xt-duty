local config = require 'configs.client'
local playerState = LocalPlayer.state

-- Checks if Players has Allowed Group / Job --
function allowedJobCheck()
    local callback = nil
    local playerJob = getCharJob()

    if type(playerJob) == 'table' then
        for _, allowedJob in pairs(config.AllowedJobs) do
            for jobName in pairs(playerJob) do
                if allowedJob == jobName then
                    callback = jobName
                    break
                end
            end
        end
    else
        for _, allowedJob in pairs(config.AllowedJobs) do
            if allowedJob == playerJob then
                callback = playerJob
                break
            end
        end
    end

    return callback
end

-- Toggle Player Duty --
local function toggleDuty(job)
    local newState = (playerState.onDuty == 0) and 1 or 0
    local dutyStr = getDutyStr(newState)
    playerState:set('onDuty', newState, true)

    lib.notify({ title = dutyStr, type = 'info' })

    local dutyInfo = { job = job, state = newState }
    local sendLog = lib.callback.await('xt-jobduty:server:logDutyChange', false, dutyInfo)
end exports('toggleDuty', toggleDuty)

-- Set State on Load / Start --
local function initDutyState()
    initPlayerData()

    local hasAllowedJob = allowedJobCheck()
    if not hasAllowedJob then
        playerState:set('onDuty', 0, true)
        return
    end

    local cid = getCharId()
    local kvpStr = ('onDuty-%s'):format(cid)
    local setState = GetResourceKvpInt(kvpStr) or 0
    playerState:set('onDuty', setState, true)

    local dutyInfo = { job = hasAllowedJob, state = setState }
    local sendLog = lib.callback.await('xt-jobduty:server:logDutyChange', false, dutyInfo)
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