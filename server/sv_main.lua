local svConfig = require 'configs.server'
local onDutyTimes = {}

function getDutyStr(state)
    return (state == 1) and 'On Duty' or ' Off Duty'
end

function sendDutyLog(job, message)
    local Webhook = svConfig.Webhooks[job] and svConfig.Webhooks[job].Webhook or svConfig.Webhooks['default'].Webhook
    local WebhookTitle = svConfig.Webhooks[job] and svConfig.Webhooks[job].Title or svConfig.Webhooks['default'].Title
    local embed = { { ['title'] = WebhookTitle, ['description'] = message } }
    PerformHttpRequest(Webhook, function() end, 'POST', json.encode({ username = 'Logs', embeds = embed }), { ['Content-Type'] = 'application/json' })
end

-- Gets Employees w/ Specified Job --
lib.callback.register('xt-jobduty:server:getActiveEmployees', function(source, job)
    local employees = {}
    local allPlayers = GetPlayers()

    for playerSource, _ in ipairs(allPlayers) do
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

-- Logs Duty Change --
lib.callback.register('xt-jobduty:server:logDutyChange', function(source, info)
    local job, state = info.job, info.state
    local pName = getCharName(source)
    local cid = getCharID(source)
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

    sendDutyLog(job, logMessage)

    return true
end)

-- Logs Off Duty --
AddEventHandler('Renewed-Lib:server:playerRemoved', function (source, player)
    local src = source
    local cid = getCharID(src)
    local pName = getCharName(src)
    if onDutyTimes and onDutyTimes[cid] then
        local onDutyTime = ('%.2f'):format(os.difftime(os.time(), onDutyTimes[cid].time) / 60)
        local logMessage = ('**Player:** %s \n**Status:** %s \n**Off Duty Time:** %s \n**On Duty Time:** %s \n**Total Time On Duty:** %s Minutes'):format(pName, dutyStr, os.date("%I:%M:%S %p"), os.date("%I:%M:%S %p", onDutyTimes[cid].time), onDutyTime)
        sendDutyLog(onDutyTimes[cid].job, logMessage)
        onDutyTimes[cid] = nil
    end
end)