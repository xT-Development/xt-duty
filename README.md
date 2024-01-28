<div align="center">
  <h1>xt-duty</h1>
  <a href="https://dsc.gg/xtdev"> <img align="center" src="https://user-images.githubusercontent.com/101474430/233859688-2b3b9ecc-41c8-41a6-b2e3-a9f1aad473ee.gif"/></a><br>
</div>

# Features
- On / Off Duty Toggle
- Uses player statebag 'onDuty'
- Saves player duty status to client resource KVP
- Syncs player duty status on load from client resource KVP
- Menu to view other on duty employees
- Set specific allowed jobs that can use the menu
- Option to hide off duty employees from the menu
- Logs player duty status changes
- Logs total time on duty when player goes off duty

# Usage
```lua
-- Check Duty State --
local duty = LocalPlayer.state.onDuty     -- Client
local duty = Player(source).state.onDuty  -- Server

-- Toggle Duty (Send Job as Data) --
exports['xt-duty']:toggleDuty(job)        -- Client Only

-- States
[0] = Off Duty
[1] = On Duty
```

# Dependencies
- ox_lib
- Renewed-Lib
