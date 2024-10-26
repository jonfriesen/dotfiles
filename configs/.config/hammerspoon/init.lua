-- Load the Spoons
hs.loadSpoon("ReverseScroll")
hs.loadSpoon("WindowManager")
hs.loadSpoon("ScreenCapture")
hs.loadSpoon("Emojis")
hs.loadSpoon("MiddleClickDragScroll"):start()

-- Start the ReverseScroll Spoon
-- spoon.ReverseScroll.logger.setLogLevel('debug')  -- Set to 'debug' for more verbose logging
spoon.ReverseScroll:start()

-- Set up hotkeys for WindowManager
spoon.WindowManager.logger.setLogLevel('debug')  -- Set to 'debug' for more verbose logging
spoon.WindowManager:bindHotkeys({
    quarterTopLeft = {{"ctrl", "cmd"}, "1"},
    quarterTopRight = {{"ctrl", "cmd"}, "2"},
    quarterBottomLeft = {{"ctrl", "cmd"}, "3"},
    quarterBottomRight = {{"ctrl", "cmd"}, "4"},
    cycleLeft = {{"ctrl", "cmd"}, "left"},
    cycleRight = {{"ctrl", "cmd"}, "right"},
    cycleTop = {{"ctrl", "cmd"}, "up"},
    cycleBottom = {{"ctrl", "cmd"}, "down"}
})

-- Set up hotkeys for ScreenCapture
-- spoon.ScreenCapture.logger.setLogLevel('debug')  -- Set to 'debug' for more verbose logging
spoon.ScreenCapture:bindHotkeys({
    captureSelection = {{}, "F13"},
    captureSelectionToClipboard = {{"ctrl"}, "F13"},
    captureOptions = {{"cmd"}, "F13"}
})

-- Set up hotkeys for Emojis
spoon.Emojis:bindHotkeys({ toggle = {{"alt", "shift"}, "z"} })
