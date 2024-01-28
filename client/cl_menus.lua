local Config = require 'client.cl_config'

function getDutyStr(state)
    return (state == 1) and 'On Duty' or ' Off Duty'
end

function getDutyIcon(state)
    return (state == 1) and Config.OnDutyIcon.icon or Config.OffDutyIcon.icon
end

function getDutyIconColor(state)
    return (state == 1) and Config.OnDutyIcon.color or Config.OffDutyIcon.color
end

-- Other Employees Menu --
local function otherEmployees(job)
    local activeEmployees = lib.callback.await('xt-jobduty:server:getActiveEmployees', false, job)
    local menuOptions = {}

    if activeEmployees and activeEmployees[1] then
        for x = 1, #activeEmployees do
            local dutyStr = ('Status: %s'):format(getDutyStr(activeEmployees[x].onDuty))
            local dutyIcon = getDutyIcon(activeEmployees[x].onDuty)
            local dutyIconColor = getDutyIconColor(activeEmployees[x].onDuty)
            menuOptions[#menuOptions+1] = {
                title = activeEmployees[x].name,
                description = dutyStr,
                icon = dutyIcon,
                iconColor = dutyIconColor,
            }
        end
    else
        menuOptions[#menuOptions+1] = {
            title = 'No Other Employees',
        }
    end

    lib.registerContext({
        id = 'duty_menu_employees',
        title = 'Other Employees',
        menu = 'duty_menu',
        options = menuOptions
    })
    lib.showContext('duty_menu_employees')
end

-- Main Duty Menu --
local function dutyMenu()
    local hasAllowedJob = allowedJobCheck()
    local dutyStr = ('Status: %s'):format(getDutyStr(LocalPlayer.state.onDuty))
    local dutyIcon = getDutyIcon(LocalPlayer.state.onDuty)
    local dutyIconColor = getDutyIconColor(LocalPlayer.state.onDuty)

    local menuOptions = {
        {
            title = 'Toggle Duty',
            description = dutyStr,
            icon = dutyIcon,
            iconColor = dutyIconColor,
            onSelect = function()
                exports['xt-duty']:toggleDuty(hasAllowedJob)
                dutyMenu()
            end
        },
        {
            title = 'View Active Employees',
            icon = 'fas fa-people-group',
            onSelect = function()
                otherEmployees(hasAllowedJob)
            end
        }
    }

    lib.registerContext({
        id = 'duty_menu',
        title = 'Job Duty Menu',
        options = menuOptions
    })
    lib.showContext('duty_menu')
end

-- Open Duty Menu --
RegisterCommand('duty', function()
    local hasAllowedJob = allowedJobCheck()
    if not hasAllowedJob then return end
    dutyMenu()
end)