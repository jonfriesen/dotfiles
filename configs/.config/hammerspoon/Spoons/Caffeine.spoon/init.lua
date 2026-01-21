--- === Caffeine ===
---
--- Prevent the screen from going to sleep
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Caffeine.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/Caffeine.spoon.zip)
local obj = { __gc = true }
--obj.__index = obj
setmetatable(obj, obj)
obj.__gc = function(t)
    t:stop()
end

-- Metadata
obj.name = "Caffeine"
obj.version = "1.0"
obj.author = "Chris Jones <cmsj@tenshu.net>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

obj.menuBarItem = nil
obj.hotkeyToggle = nil
obj.lockWatcher = nil
obj.durationTimer = nil
obj.timerEndTime = nil

-- Internal function used to find our location, so we know where to load files from
local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end
obj.spoonPath = script_path()

function obj:init()
end

function obj:lockEventHandler(event)
    if event == hs.caffeinate.watcher.screensDidLock then
        if hs.caffeinate.get("displayIdle") then
            self:cancelTimer()
            self:setState(false)
        end
    end
end

--- Caffeine:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for Caffeine
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details for the following items:
---   * toggle - This will toggle the state of display sleep prevention, and update the menubar graphic
---
--- Returns:
---  * The Caffeine object
function obj:bindHotkeys(mapping)
    if (self.hotkeyToggle) then
        self.hotkeyToggle:delete()
    end
    local toggleMods = mapping["toggle"][1]
    local toggleKey = mapping["toggle"][2]
    self.hotkeyToggle = hs.hotkey.new(toggleMods, toggleKey, function() self.clicked() end)

    return self
end

--- Caffeine:start()
--- Method
--- Starts Caffeine
---
--- Parameters:
---  * None
---
--- Returns:
---  * The Caffeine object
function obj:start()
    if self.menuBarItem then self:stop() end
    self.menuBarItem = hs.menubar.new()
    self.menuBarItem:setMenu(function()
        local buttons = hs.eventtap.checkMouseButtons()
        if buttons.right then
            -- Right click - show menu
            return self:buildMenu()
        else
            -- Left click - toggle and don't show menu
            self:cancelTimer()
            self.clicked()
            return {}
        end
    end)
    if (self.hotkeyToggle) then
        self.hotkeyToggle:enable()
    end
    self.setDisplay(hs.caffeinate.get("displayIdle"))

    self.lockWatcher = hs.caffeinate.watcher.new(function(event)
        self:lockEventHandler(event)
    end)
    self.lockWatcher:start()

    return self
end

--- Caffeine:stop()
--- Method
--- Stops Caffeine
---
--- Parameters:
---  * None
---
--- Returns:
---  * The Caffeine object
function obj:stop()
    if self.menuBarItem then self.menuBarItem:delete() end
    if (self.hotkeyToggle) then
        self.hotkeyToggle:disable()
    end
    if self.lockWatcher then
        self.lockWatcher:stop()
        self.lockWatcher = nil
    end
    if self.durationTimer then
        self.durationTimer:stop()
        self.durationTimer = nil
        self.timerEndTime = nil
    end
    self.menuBarItem = nil
    return self
end

function obj.setDisplay(state)
    local result
    if state then
        result = obj.menuBarItem:setIcon(obj.spoonPath.."/caffeine-on.pdf")
    else
        result = obj.menuBarItem:setIcon(obj.spoonPath.."/caffeine-off.pdf")
    end
end

function obj.clicked()
    obj.setDisplay(hs.caffeinate.toggle("displayIdle"))
end

--- Caffeine:setState(on)
--- Method
--- Sets whether or not caffeination should be enabled
---
--- Parameters:
---  * on - A boolean, true if screens should be kept awake, false to let macOS send them to sleep
---
--- Returns:
---  * None
function obj:setState(on)
    hs.caffeinate.set("displayIdle", on)
    obj.setDisplay(on)
end

--- Caffeine:enableForDuration(seconds)
--- Method
--- Enables Caffeine for a specified duration
---
--- Parameters:
---  * seconds - Number of seconds to keep Caffeine enabled
---
--- Returns:
---  * None
function obj:enableForDuration(seconds)
    -- Cancel any existing timer
    if self.durationTimer then
        self.durationTimer:stop()
        self.durationTimer = nil
    end

    -- Enable caffeine
    self:setState(true)

    -- Set timer to disable after duration
    self.timerEndTime = os.time() + seconds
    self.durationTimer = hs.timer.doAfter(seconds, function()
        self:setState(false)
        self.durationTimer = nil
        self.timerEndTime = nil
    end)
end

--- Caffeine:cancelTimer()
--- Method
--- Cancels any active duration timer
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function obj:cancelTimer()
    if self.durationTimer then
        self.durationTimer:stop()
        self.durationTimer = nil
        self.timerEndTime = nil
    end
end

--- Caffeine:buildMenu()
--- Method
--- Builds the dropdown menu for the menubar item
---
--- Parameters:
---  * None
---
--- Returns:
---  * A table containing the menu items
function obj:buildMenu()
    local currentState = hs.caffeinate.get("displayIdle")
    local hasTimer = self.durationTimer ~= nil

    local menu = {
        {
            title = currentState and "Disable Caffeine" or "Enable Caffeine",
            fn = function()
                self:cancelTimer()
                self.clicked()
            end
        },
        { title = "-" },
        { title = "Enable for:", disabled = true },
        { title = "5 minutes", fn = function() self:enableForDuration(5 * 60) end },
        { title = "15 minutes", fn = function() self:enableForDuration(15 * 60) end },
        { title = "30 minutes", fn = function() self:enableForDuration(30 * 60) end },
        { title = "1 hour", fn = function() self:enableForDuration(60 * 60) end },
        { title = "4 hours", fn = function() self:enableForDuration(4 * 60 * 60) end },
        { title = "8 hours", fn = function() self:enableForDuration(8 * 60 * 60) end },
    }

    -- Show remaining time if timer is active
    if hasTimer and self.timerEndTime then
        local remaining = self.timerEndTime - os.time()
        if remaining > 0 then
            local mins = math.floor(remaining / 60)
            local hours = math.floor(mins / 60)
            mins = mins % 60
            local timeStr
            if hours > 0 then
                timeStr = string.format("%dh %dm remaining", hours, mins)
            else
                timeStr = string.format("%dm remaining", mins)
            end
            table.insert(menu, 2, { title = timeStr, disabled = true })
        end
    end

    return menu
end

return obj
