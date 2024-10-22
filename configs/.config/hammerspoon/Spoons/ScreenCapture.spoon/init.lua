--- === ScreenCapture ===
---
--- Enhance screen capture functionality with custom hotkeys
---

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "ScreenCapture"
obj.version = "1.0"
obj.author = "Jon Friesen <jon@jonfriesen.ca>"
obj.homepage = "https://github.com/jonfriesen/dotfiles/tree/main/configs/.config/hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function obj:init()
    self.logger = hs.logger.new(obj.name .. '-' .. obj.version, 'info')
    self.logger.i('Initializing ' .. obj.name)
end

function obj:bindHotkeys(mapping)
    self.logger.i('Binding hotkeys for ' .. obj.name)
    local spec = {
        captureSelection = hs.fnutils.partial(self.runScreenCapture, self, {"-i"}, "Selection to file"),
        captureSelectionToClipboard = hs.fnutils.partial(self.runScreenCapture, self, {"-ic"}, "Selection to clipboard"),
        captureOptions = hs.fnutils.partial(self.runScreenCapture, self, {"-iU"}, "Screenshot and recording options")
    }
    hs.spoons.bindHotkeysToSpec(spec, mapping)
end

function obj:runScreenCapture(args, description)
    local filename = hs.fs.pathToAbsolute("~").."/Desktop/Screen Capture at "..os.date("!%Y-%m-%d-%T")..".png"

    self.logger.i("Executing: screencapture " .. table.concat(args, " ") .. " " .. filename)
    self.logger.i("Description: " .. description)

    -- Combine args and filename into a single table
    local allArgs = {}
    for _, arg in ipairs(args) do
        table.insert(allArgs, arg)
    end
    table.insert(allArgs, filename)

    hs.task.new("/usr/sbin/screencapture", function(exitCode, stdOut, stdErr)
        if exitCode == 0 then
            self.logger.i("Screencapture executed successfully")
        else
            self.logger.e("Screencapture failed with exit code: " .. exitCode)
            if stdErr then
                self.logger.e("Error: " .. stdErr)
            end
        end
    end, allArgs):start()
end

return obj