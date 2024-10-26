--- === WindowManager ===
---
--- Manage window positions and sizes with hotkeys
---

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "WindowManager"
obj.version = "1.0"
obj.author = "Jon Friesen <jon@jonfriesen.ca>"
obj.homepage = "https://github.com/jonfriesen/dotfiles/tree/main/configs/.config/hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Internal function to move windows
local function moveWindow(x, y, w, h)
    return function()
        local win = hs.window.focusedWindow()
        if win then
            local f = win:frame()
            local screen = win:screen()
            local max = screen:frame()
            
            f.x = max.x + (max.w * x)
            f.y = max.y + (max.h * y)
            f.w = max.w * w
            f.h = max.h * h
            win:setFrame(f)
            obj.logger.v(string.format("Moved window to x:%.2f, y:%.2f, w:%.2f, h:%.2f", x, y, w, h))
        else
            obj.logger.w("No focused window found")
        end
    end
end

function obj:init()
    self.logger = hs.logger.new(obj.name .. '-' .. obj.version, 'info')
    self.logger.i('Initializing ' .. obj.name)
    
    self.leftRightSizes = {0.5, 2/3, 1/3}
    self.leftRightIndex = 1
    self.topBottomSizes = {0.5, 2/3, 1/3}
    self.topBottomIndex = 1
    self.upSizes = {0.75, 1}
    self.upIndex = 1
end

function obj:bindHotkeys(mapping)
    self.logger.i('Binding hotkeys for ' .. obj.name)
    local spec = {
        quarterTopLeft = moveWindow(0, 0, 0.5, 0.5),
        quarterTopRight = moveWindow(0.5, 0, 0.5, 0.5),
        quarterBottomLeft = moveWindow(0, 0.5, 0.5, 0.5),
        quarterBottomRight = moveWindow(0.5, 0.5, 0.5, 0.5),
        cycleLeft = function() self:cycleLeftRight("left") end,
        cycleRight = function() self:cycleLeftRight("right") end,
        cycleTop = function() self:adaptiveCycleVertical("top") end,
        cycleBottom = function() self:adaptiveCycleVertical("bottom") end
    }
    
    for action, func in pairs(spec) do
        if mapping[action] then
            self.logger.i("Binding hotkey for " .. action)
            hs.hotkey.bind(mapping[action][1], mapping[action][2], func)
        else
            self.logger.w("No hotkey mapping found for " .. action)
        end
    end
end

function obj:cycleLeftRight(side)
    self.logger.v('Cycling ' .. side)
    local size = self.leftRightSizes[self.leftRightIndex]
    if side == "left" then
        moveWindow(0, 0, size, 1)()
    else
        moveWindow(1 - size, 0, size, 1)()
    end
    self.leftRightIndex = (self.leftRightIndex % #self.leftRightSizes) + 1
end

function obj:isPortraitMode()
    local win = hs.window.focusedWindow()
    if win then
        local screen = win:screen()
        local max = screen:frame()
        return max.h > max.w
    end
    return false
end

function obj:adaptiveCycleVertical(direction)
    self.logger.v('Adaptive cycling ' .. direction)
    
    if self:isPortraitMode() then
        -- Use traditional top/bottom cycling for portrait monitors
        local size = self.topBottomSizes[self.topBottomIndex]
        if direction == "top" then
            moveWindow(0, 0, 1, size)()
        else
            moveWindow(0, 1 - size, 1, size)()
        end
        self.topBottomIndex = (self.topBottomIndex % #self.topBottomSizes) + 1
    else
        -- Use centered scaling for landscape monitors
        if direction == "top" then
            local size = self.upSizes[self.upIndex]
            moveWindow((1 - size) / 2, 0, size, 1)()
            self.upIndex = (self.upIndex % #self.upSizes) + 1
        else
            local win = hs.window.focusedWindow()
            if win then
                local f = win:frame()
                local screen = win:screen()
                local max = screen:frame()
                
                f.w = 1024
                f.h = 768
                f.x = max.x + (max.w - f.w) / 2
                f.y = max.y + (max.h - f.h) / 2
                win:setFrame(f)
                self.logger.v('Set window size to 1024x768')
            else
                self.logger.w("No focused window found")
            end
        end
    end
end

return obj
