local svConfig      = require 'configs.server'
local renewed_lib   = (GetResourceState('Renewed-Lib') == 'started')
local onDutyTimes = {}

function getDutyStr(state)
    return ((state == 1) or state) and 'On Duty' or ' Off Duty'
end

function sendDutyLog(source, job, state)
    local cid = getCharID(source)
    local pName = getCharName(source)
    local dutyStr = getDutyStr(state)

    local logMessage = ''
    if state == 1 then
        logMessage = ('**Player:** %s \n**Status:** %s \n**On Duty Time:** %s'):format(pName, dutyStr, os.date("%I:%M:%S %p"))
        onDutyTimes[cid] = { job = job, time = os.time() }
    elseif state == 0 then
        if not onDutyTimes[cid] then return true end

        local onDutyTime = ('%.2f'):format(os.difftime(os.time(), onDutyTimes[cid].time) / 60)
        logMessage = ('**Player:** %s \n**Status:** %s \n**Off Duty Time:** %s \n**On Duty Time:** %s \n**Total Time On Duty:** %s Minutes'):format(pName, dutyStr, os.date("%I:%M:%S %p"), os.date("%I:%M:%S %p", onDutyTimes[cid].time), onDutyTime)
        onDutyTimes[cid] = nil
    end

    local Webhook = svConfig.Webhooks[job] and svConfig.Webhooks[job].Webhook or svConfig.Webhooks['default'].Webhook
    local WebhookTitle = svConfig.Webhooks[job] and svConfig.Webhooks[job].Title or svConfig.Webhooks['default'].Title
    local embed = { { ['title'] = WebhookTitle, ['description'] = logMessage } }
    PerformHttpRequest(Webhook, function() end, 'POST', json.encode({ username = 'Logs', embeds = embed }), { ['Content-Type'] = 'application/json' })
end

-- Gets Employees w/ Specified Job --
lib.callback.register('xt-duty:server:getActiveEmployees', function(source, job)
    local employees = {}
    local allPlayers = GetPlayers()

    for _, playerSource in pairs(allPlayers) do
        playerSource = tonumber(playerSource)
        if hasGroup(playerSource, job) then
            local state = Player(playerSource).state
            local pName = getCharName(playerSource)
            local cid = getCharID(playerSource)
            if not svConfig.HideOffDutyEmployees then
                employees[#employees+1] = {
                    name = pName,
                    clockInTime = onDutyTimes[cid] and ('Clocked In: %s'):format(os.date("%I:%M:%S %p", onDutyTimes[cid].time)) or '',
                    onDuty = state and state.onDuty or 0
                }
            else
                if state and state.onDuty == 1 then
                    employees[#employees+1] = {
                        name = pName,
                        clockInTime = ('Clocked In: %s'):format(os.date("%I:%M:%S %p", onDutyTimes[cid].time)),
                        onDuty = state.onDuty
                    }
                end
            end
        end
    end

    return employees
end)

-- Handles Statebag Change & Logging --
lib.callback.register('xt-duty:server:setDuty', function(source, dutyInfo)
    if dutyInfo and not dutyInfo.job or not dutyInfo.state then
        return false
    end

    local playerJob, setState = dutyInfo.job, dutyInfo.state
    local playerState = Player(source).state

    playerState:set('onDuty', setState, true)

    if renewed_lib then -- Renewed-Lib compat
        playerState:set('renewed_service', (setState == 1) and playerJob or false, true)
    end

    sendDutyLog(source, playerJob, setState) -- Send log
    handleBridgeDutyChange(source, setState) -- Update bridge

    return true
end)

-- Logs Off Duty --
AddEventHandler('playerDropped', function (reason)
    local src = source
    local cid = getCharID(src)
    local pName = getCharName(src)
    if onDutyTimes and onDutyTimes[cid] then
        local onDutyTime = ('%.2f'):format(os.difftime(os.time(), onDutyTimes[cid].time) / 60)
        local logMessage = ('**Player:** %s \n**Status:** %s \n**Off Duty Time:** %s \n**On Duty Time:** %s \n**Total Time On Duty:** %s Minutes'):format(pName, 'Off Duty', os.date("%I:%M:%S %p"), os.date("%I:%M:%S %p", onDutyTimes[cid].time), onDutyTime)
        sendDutyLog(onDutyTimes[cid].job, logMessage)

        onDutyTimes[cid] = nil
    end
end)