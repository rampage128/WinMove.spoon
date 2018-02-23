-- === WinMove ===
--
-- A spoon to move your OSX applications like windows applications using shortcuts.

local obj={}
obj.__index = obj

-- Metadata
obj.name = "WinMove"
obj.version = "1.0"
obj.author = "fwolter <frederik.wolter@googlemail.com>"
obj.homepage = "https://github.com/rampage128/WinMove"
obj.license = "MIT - https://opensource.org/licenses/MIT"

-- Enum for window positions
local positions = {
  top_left = {},
  top_right = {},
  left = {},
  right = {},
  bottom_left = {},
  bottom_right = {},
  floating = {},
  maximized = {}
}

-- Some globals
local screens = hs.screen.allScreens()
local minX = 0
local maxX = 0

-- Internal function to retrieve a windows position
local function getWindowPosition(window)
  local frame = window:frame()
  local screenFrame = window:screen():frame()

  local halfHeight = math.floor(screenFrame.h / 2)
  local halfWidth = math.floor(screenFrame.w / 2)

  if frame.w == screenFrame.w and frame.h == screenFrame.h and frame.w == screenFrame.w and frame.h == screenFrame.h then
    return positions.maximized
  elseif frame.w == halfWidth then
    if frame.h == halfHeight then
      if frame.y == screenFrame.y then
        if frame.x == screenFrame.x then
          return positions.top_left
        elseif frame.x == screenFrame.x + halfWidth then
          return positions.top_right
        end
      elseif frame.y == screenFrame.y + halfHeight then
        if frame.x == screenFrame.x then
          return positions.bottom_left
        elseif frame.x == screenFrame.x + halfWidth then
          return positions.bottom_right
        end
      end
    elseif frame.h == screenFrame.h then
      if frame.x == screenFrame.x then
        return positions.left
      elseif frame.x == screenFrame.x + halfWidth then
        return positions.right
      end
    end
  end

  return positions.floating
end

-- Internal function to retrieve a screen from a coordinate
local function getScreen(x, y)
  if x < minX then return getScreen(maxX - 16, y) end
  if x >= maxX then return getScreen(minX, y) end

  local screens = hs.screen.allScreens()
  for i, screen in ipairs(screens) do
    local frame = screen:frame()
    if frame.x <= x and frame.x + frame.w > x and frame.y <= y and frame.y + frame.h > y then
      return screen
    end
  end
end

-- Internal function to move a window to a position on a specified screen
local function moveTo(window, position, screen)
  local frame = window:frame()
  local screenFrame = screen:frame()

  if position == positions.top_left then
    frame.x = screenFrame.x
    frame.y = screenFrame.y
    frame.w = screenFrame.w / 2
    frame.h = screenFrame.h / 2
  elseif position == positions.top_right then
    frame.x = screenFrame.x + screenFrame.w / 2
    frame.y = screenFrame.y
    frame.w = screenFrame.w / 2
    frame.h = screenFrame.h / 2
  elseif position == positions.left then
    frame.x = screenFrame.x
    frame.y = screenFrame.y
    frame.w = screenFrame.w / 2
    frame.h = screenFrame.h
  elseif position == positions.right then
    frame.x = screenFrame.x + screenFrame.w / 2
    frame.y = screenFrame.y
    frame.w = screenFrame.w / 2
    frame.h = screenFrame.h
  elseif position == positions.bottom_left then
    frame.x = screenFrame.x
    frame.y = screenFrame.y + screenFrame.h / 2
    frame.w = screenFrame.w / 2
    frame.h = screenFrame.h / 2
  elseif position == positions.bottom_right then
    frame.x = screenFrame.x + screenFrame.w / 2
    frame.y = screenFrame.y + screenFrame.h / 2
    frame.w = screenFrame.w / 2
    frame.h = screenFrame.h / 2
  elseif position == positions.maximized then
    frame.x = screenFrame.x
    frame.y = screenFrame.y
    frame.w = screenFrame.w
    frame.h = screenFrame.h
  elseif position == positions.floating then
    frame.x = screenFrame.x + screenFrame.w / 4
    frame.y = screenFrame.y + screenFrame.h / 4
    frame.w = screenFrame.w / 2
    frame.h = screenFrame.h / 2
  end

  window:setFrame(frame)
end

-- public stuff

--- WinMove.moveLeft()
--- Method
--- Moves a window to the left. Depending on the current position the window is moved differently:
---
--- Transitions:
--- * top left quarter -> top right quarter on the screen to the left
--- * bottom left quarter -> bottom right quarter on the screen to the left
--- * left half -> right half of the screen to the left
--- * top right quarter -> top left quarter
--- * bottom right quarter -> bottom left quarter
--- * right half -> floating centered
--- * other states -> left half
function obj.moveLeft()
  local window = hs.window.focusedWindow()
  local position = getWindowPosition(window)
  local newPosition = positions.left
  local newScreen = window:screen()

  if position == positions.top_left then
    newScreen = getScreen(newScreen:frame().x - 1, newScreen:frame().h / 2)
    newPosition = positions.top_right
  elseif position == positions.bottom_left then
    newScreen = getScreen(newScreen:frame().x - 1, newScreen:frame().h / 2)
    newPosition = positions.bottom_right
  elseif position == positions.left then
    newScreen = getScreen(newScreen:frame().x - 1, newScreen:frame().h / 2)
    newPosition = positions.right
  elseif position == positions.top_right then
    newPosition = positions.top_left
  elseif position == positions.bottom_right then
    newPosition = positions.bottom_left
  elseif position == positions.right then
    newPosition = positions.floating
  end

  moveTo(window, newPosition, newScreen)
  return obj;
end

--- WinMove.moveRight()
--- Method
--- Moves a window to the right. Depending on the current position the window is moved differently:
---
--- Transitions:
--- * top right quarter -> top left quarter on the screen to the right
--- * bottom right quarter -> bottom left quarter on the screen to the right
--- * right half -> left half of the screen to the right
--- * top left quarter -> top right quarter
--- * bottom left quarter -> bottom right quarter
--- * left half -> floating centered
--- * other states -> right half
function obj.moveRight()
  local window = hs.window.focusedWindow()
  local position = getWindowPosition(window)
  local newPosition = positions.right
  local newScreen = window:screen()

  if position == positions.top_right then
    newScreen = getScreen(newScreen:frame().x + newScreen:frame().w, newScreen:frame().h / 2)
    newPosition = positions.top_left
  elseif position == positions.bottom_right then
    newScreen = getScreen(newScreen:frame().x + newScreen:frame().w, newScreen:frame().h / 2)
    newPosition = positions.bottom_left
  elseif position == positions.right then
    newScreen = getScreen(newScreen:frame().x + newScreen:frame().w, newScreen:frame().h / 2)
    newPosition = positions.left
  elseif position == positions.top_left then
    newPosition = positions.top_right
  elseif position == positions.bottom_left then
    newPosition = positions.bottom_right
  elseif position == positions.left then
    newPosition = positions.floating
  end

  moveTo(window, newPosition, newScreen)
  return obj;
end

--- WinMove.moveUp()
--- Method
--- Moves a window upwards. Depending on the current position the window is moved differently:
---
--- Transitions:
--- * bottom left quarter -> left half
--- * bottom right quarter -> right half
--- * left half -> top left quarter
--- * right half -> top right quarter
--- * other states -> maximized
function obj.moveUp()
  local window = hs.window.focusedWindow()
  local position = getWindowPosition(window)
  local newPosition = positions.maximized

  if position == positions.bottom_left then
    newPosition = positions.left
  elseif position == positions.bottom_right then
    newPosition = positions.right
  elseif position == positions.left then
    newPosition = positions.top_left
  elseif position == positions.right then
    newPosition = positions.top_right
  end

  moveTo(window, newPosition, window:screen())
  return obj;
end

--- WinMove.moveDown()
--- Method
--- Moves a window downwards. Depending on the current position the window is moved differently:
---
--- Transitions:
--- * top left quarter -> left half
--- * top right quarter -> right half
--- * left half -> bottom left quarter
--- * right half -> bottom right quarter
--- * other states -> floating centered
function obj.moveDown()
  local window = hs.window.focusedWindow()
  local position = getWindowPosition(window)
  local newPosition = positions.floating

  if position == positions.top_left then
    newPosition = positions.left
  elseif position == positions.top_right then
    newPosition = positions.right
  elseif position == positions.left then
    newPosition = positions.bottom_left
  elseif position == positions.right then
    newPosition = positions.bottom_right
  end

  moveTo(window, newPosition, window:screen())
  return obj;
end

--- WinMove:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for WinMove
---
--- Parameters:
---  * mapping - A table containing hotkey objifier/key details for the following items:
---   * left, right, up, down - Move/resize a window with the same logic as microsoft windows
---
--- Returns:
---  * the WinMove object
function obj:bindHotKeys(mapping)
   local action_to_method_map = {
      left = self.moveLeft,
      right = self.moveRight,
      up = self.moveUp,
      down = self.moveDown,
   }
   hs.spoons.bindHotkeysToSpec(action_to_method_map, mapping)
   return self
end

--- WinMove:init(mapping)
--- Method
--- Initializes WinMove. Minimum and maximum coordinates are calculated for wrap around movement of windows.
--- The calculated values allow windows to move from the first to the last screen and vice versa.
function obj:init()
  for i, screen in ipairs(screens) do
    local frame = screen:frame()
    if frame.x < minX then minX = frame.x end
    if frame.x + frame.w > maxX then maxX = frame.x + frame.w end
  end
end

return obj
