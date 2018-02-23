# WinMove

> A spoon to move applications with the keyboard in OSX like in windows

This is a lua [spoon](https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md) for
[Hammerspoon](http://www.hammerspoon.org/). It enables the user to move applications using
only one shortcut and the arrow keys. It emulates the behaviour applications show in
microsoft windows when using `WIN`-Key together with the arrow keys.

__Please make sure to read the [requirements](#requirements)__!

## Background

There is plenty of window-managers for mac OSX ... Unfortunately it is hard to find a good one.
They are either buggy, too complicated, require you to remember 20+ random shortcuts and/or cost a lot
of money. The goal of this project is to provide a very simple way to move your applications
around in the same way the integrated window management of microsoft windows does.

## Requirements

- [Hammerspoon](http://www.hammerspoon.org/): To run the script.

## Installation
### Releases

1. Download the [latest WinMove.spoon.zip](https://github.com/rampage128/WinMove.spoon/releases).
2. Unzip the file.
3. Double click the folder in finder -> Hammerspoon will automatically move it to the `Spoons` directory.
4. Load the spoon and add the bindings in your init.lua (See [usage](#usage)).

### From source

1. Clone the repository into your `Spoons` directory:
   ```
   cd ~/.hammerspoon/Spoons/
   git clone https://github.com/rampage128/WinMove.spoon.git
   ```
2. Load the spoon and add the bindings in your init.lua (See [usage](#usage)).

## Usage

1. [Install](#installation) the spoon.
2. Open your `~/.hammerspoon/init.lua` and add the spoon:
   ```
   hs.loadSpoon("WinMove")

   spoon.WinMove:bindHotKeys({
     left = {{"ctrl", "cmd"}, "Left"},
     right = {{"ctrl", "cmd"}, "Right"},
     up = {{"ctrl", "cmd"}, "Up"},
     down = {{"ctrl", "cmd"}, "Down"}
   })
   ```
3. Reload the config in [Hammerspoon](http://www.hammerspoon.org/)
4. You can now use the shortcuts as configured to move your apps around!

### Changing shortcuts

As seen in [usage](#usage) the shortcuts are defined in a similar format as default
Hammerspoon bindings:

```
<action> = {{<modifiers>}, <key>}
```

The `<action>` determines what action to trigger inside the spoon.
Available actions are: `left`, `right`, `up`, `down`

`<modifiers>` is a list of modifier keys you have to press for the binding.
See [Hammerspoon API reference](http://www.hammerspoon.org/docs/hs.hotkey.html#bind) for more information on that.

`<key>` is the key to press for the binding.
This is also explained in the [Hammerspoon API reference](http://www.hammerspoon.org/docs/hs.hotkey.html#bind).

## Known issues

- If you have vertically arranged screens, the script is not yet able to handle this.

## Contribute

Feel free to [open an issue](https://github.com/rampage128/WinMove.spoon/issues) or submit a PR

Also, if you like this or other of my projects, please feel free to support me using the Link below.

[![Buy me a beer](https://img.shields.io/badge/buy%20me%20a%20beer-PayPal-green.svg)](https://www.paypal.me/FrederikWolter/1)

## Dependencies

- [Hammerspoon](http://www.hammerspoon.org/): To run the script.
