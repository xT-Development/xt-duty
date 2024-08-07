local lib           = lib
local playerState   = LocalPlayer.state

-- Other Employees Menu --
local function otherEmployees(job)
    local activeEmployees = lib.callback.await('xt-duty:server:getActiveEmployees', false, job)
    local menuOptions = {}

    if activeEmployees and activeEmployees[1] then
        for x = 1, #activeEmployees do
            local dutyStr = getDutyStr(activeEmployees[x].onDuty)
            local dutyIcon = getDutyIcon(activeEmployees[x].onDuty)
            local dutyIconColor = getDutyIconColor(activeEmployees[x].onDuty)
            menuOptions[#menuOptions+1] = {
                label = activeEmployees[x].name,
                description = ('%s ▪ %s'):format(dutyStr, activeEmployees[x].clockInTime),
                icon = dutyIcon,
                iconColor = dutyIconColor,
                close = false
            }
        end
    else
        menuOptions[#menuOptions+1] = {
            label = 'No Other Employees',
        }
    end

    lib.registerMenu({
        id = 'duty_menu_employees',
        title = 'Other Employees',
        position = 'top-right',
        onClose = function()
            lib.showMenu('duty_menu')
        end,
        options = menuOptions,
    })
    lib.showMenu('duty_menu_employees')
end

local function refreshDutyMenu()
    local menu_id = lib.getOpenMenu()
    if menu_id ~= 'duty_menu' then return end

    lib.hideMenu()
    Wait(500)
    lib.setMenuOptions('duty_menu', {
        label = 'Toggle Duty',
        description = getDutyStr(playerState.onDuty),
        checked = (playerState.onDuty and playerState.onDuty == 1),
        icon = getDutyIcon(playerState.onDuty),
        iconColor = getDutyIconColor(playerState.onDuty)}, 1)
    lib.showMenu('duty_menu')
end

-- Main Duty Menu --
local function dutyMenu(hasAllowedJob)
    local dutyStr = getDutyStr(playerState.onDuty)
    local dutyIcon = getDutyIcon(playerState.onDuty)
    local dutyIconColor = getDutyIconColor(playerState.onDuty)

    lib.registerMenu({
        id = 'duty_menu',
        title = 'Job Duty Menu',
        position = 'top-right',
        onCheck = function(selected, checked, args)
            if selected == 1 then
                exports['xt-duty']:toggleDuty(hasAllowedJob)
                refreshDutyMenu()
            end
        end,
        options = {
            { label = 'Toggle Duty', description = dutyStr, icon = dutyIcon, iconColor = dutyIconColor, checked = (playerState.onDuty and playerState.onDuty == 1) },
            { label = 'View Active Employees', icon = 'fas fa-people-group' },
        }
    }, function(selected, scrollIndex, args)
        if selected == 2 then
            otherEmployees(hasAllowedJob)
        end
    end)
    lib.showMenu('duty_menu')
end

-- Open Duty Menu --
RegisterCommand('duty', function()
    local hasAllowedJob = allowedJobCheck()
    if not hasAllowedJob then return end
    dutyMenu(hasAllowedJob)
end)