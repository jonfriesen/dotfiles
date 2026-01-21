# Caffeine Spoon

Prevent the screen from going to sleep.

## Usage

```lua
hs.loadSpoon("Caffeine")
spoon.Caffeine:start()
```

## Features

- Menu bar icon to toggle display sleep prevention
- Optional hotkey binding
- **Auto-disable on screen lock**: When you lock your screen, Caffeine automatically turns off so your display can sleep normally

## Methods

### `start()`
Starts Caffeine and shows the menu bar icon.

### `stop()`
Stops Caffeine and removes the menu bar icon.

### `setState(on)`
Programmatically enable or disable Caffeine.
- `on` (boolean): `true` to keep screen awake, `false` to allow sleep

### `bindHotkeys(mapping)`
Bind a hotkey to toggle Caffeine.

```lua
spoon.Caffeine:bindHotkeys({
    toggle = {{"cmd", "alt"}, "c"}
})
```

## Credits

Original author: Chris Jones <cmsj@tenshu.net>
