-- Load the Spoons
hs.loadSpoon("ReverseScroll")
hs.loadSpoon("WindowManager")
hs.loadSpoon("ScreenCapture")
hs.loadSpoon("Emojis")
hs.loadSpoon("MiddleClickDragScroll"):start()
hs.loadSpoon("URLDispatcher")
hs.loadSpoon("Caffeine"):start()

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

-- Set up patterns and browsers for URLDispatcher
spoon.URLDispatcher.logger.setLogLevel("debug")
spoon.URLDispatcher.default_handler = "net.imput.Helium"
spoon.URLDispatcher.browser_chooser = {
 {name = "Personal", bundleId = "net.imput.Helium", patternFile = "personal.pat"},
 {name = "Work", bundleId = "com.google.chrome", patternFile = "work.pat"},
 {name = "Safari", bundleId = "com.apple.Safari"},
}
spoon.URLDispatcher.url_patterns = {
    -- Work patterns (evaluated first - more specific)
    { "work.pat", "com.google.Chrome" },
    
    -- Personal patterns (evaluated second - broader catch-all)
    { "personal.pat", "net.imput.Helium" },
}
spoon.URLDispatcher:start()
