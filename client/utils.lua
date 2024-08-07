local config        = require 'configs.client'

function getDutyStr(state)
    return (state == 1) and 'On Duty' or ' Off Duty'
end

function getDutyIcon(state)
    return (state == 1) and config.OnDutyIcon.icon or config.OffDutyIcon.icon
end

function getDutyIconColor(state)
    return (state == 1) and config.OnDutyIcon.color or config.OffDutyIcon.color
end

-- Checks if Players has Allowed Group / Job --
function allowedJobCheck()
    local callback = nil
    local playerJob = getCharJob()

    if type(playerJob) == 'table' then
        for _, allowedJob in pairs(config.AllowedJobs) do
            for jobName in pairs(playerJob) do
                if allowedJob == jobName then
                    return jobName
                end
            end
        end
    else
        for _, allowedJob in pairs(config.AllowedJobs) do
            if allowedJob == playerJob then
                return playerJob
            end
        end
    end

    return callback
end