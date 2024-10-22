--- === ReverseScroll ===
---
--- Reverse the direction of mouse scrolling
---

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "ReverseScroll"
obj.version = "1.0"
obj.author = "Jon Friesen <jon@jonfriesen.ca>"
obj.homepage = "https://github.com/jonfriesen/dotfiles/tree/main/configs/.config/hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function obj:init()
    self.logger = hs.logger.new(obj.name .. '-' .. obj.version, 'info')
    self.logger.i('Initializing ' .. obj.name)
    
    self.eventtap = hs.eventtap.new({hs.eventtap.event.types.scrollWheel}, function(event)
        -- detect if this is touchpad or mouse
        local isTrackpad = event:getProperty(hs.eventtap.event.properties.scrollWheelEventIsContinuous)
        if isTrackpad == 1 then
            self.logger.v('Trackpad event detected, passing along')
            return false -- trackpad: pass the event along
        end
        
        self.logger.v('Reversing scroll direction for mouse event')
        event:setProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis1,
            -event:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis1))
        return false -- pass the event along
    end)
end

function obj:start()
    self.logger.i('Starting ' .. obj.name)
    self.eventtap:start()
end

function obj:stop()
    self.logger.i('Stopping ' .. obj.name)
    self.eventtap:stop()
end

return obj