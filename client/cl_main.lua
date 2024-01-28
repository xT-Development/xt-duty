Bridge = exports['Renewed-Lib']:getLib()
local clConfig = require 'client.cl_config'

-- Checks if Players has Allowed Group / Job --
function allowedJobCheck()
    local callback = nil
    local groups = Bridge.getPlayerGroup()

    for _, allowedJob in pairs(clConfig.AllowedJobs) do
        for job, level in pairs(groups) do
            if allowedJob == job then
                callback = job
                break
            end
        end
    end

    return callback
end

-- Toggle Player Duty --
local function toggleDuty(job)
    local newState = (LocalPlayer.state.onDuty == 0) and 1 or 0
    LocalPlayer.state:set('onDuty', newState, true)

    if newState == 1 then
        lib.notify({ title = 'On Duty', type = 'success' })
    else
        lib.notify({ title = 'Off Duty', type = 'error' })
    end

    local dutyInfo = { job = job, state = newState }
    local sendLog = lib.callback.await('xt-jobduty:server:logDutyChange', false, dutyInfo)
end exports('toggleDuty', toggleDuty)

-- Set State on Load / Start --
local function initDutyState()
    local hasAllowedJob = allowedJobCheck()
    if not hasAllowedJob then
        LocalPlayer.state:set('onDuty', 0, true)
        return
    end

    local cid = Bridge.getCharId()
    local kvpStr = ('onDuty-%s'):format(cid)
    local setState = GetResourceKvpInt(kvpStr) or 0
    LocalPlayer.state:set('onDuty', setState, true)

    local dutyInfo = { job = hasAllowedJob, state = setState }
    local sendLog = lib.callback.await('xt-jobduty:server:logDutyChange', false, dutyInfo)
    print(('Get Duty Status: %s'):format(LocalPlayer.state.onDuty))
end

-- Save State on Unload / Stop --
local function saveDutyState()
    local cid = Bridge.getCharId()
    local kvpStr = ('onDuty-%s'):format(cid)
    local hasAllowedJob = allowedJobCheck()
    if not hasAllowedJob then
        SetResourceKvpInt(kvpStr, 0)
        return
    end

    SetResourceKvpInt(kvpStr, LocalPlayer.state.onDuty)
    print(('Save Duty Status: %s'):format(LocalPlayer.state.onDuty))
end

-- Handlers --
AddEventHandler('Renewed-Lib:client:PlayerLoaded', function(player) initDutyState() end)
AddEventHandler('Renewed-Lib:client:PlayerUnloaded', function() saveDutyState() end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    initDutyState()
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    saveDutyState()
end)