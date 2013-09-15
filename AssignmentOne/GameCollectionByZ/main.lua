-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- 1. Hide Status Bar
-- 2. Creating Storyboard object.
-- 3. Load first screen: menu.lua
--
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

local storyboard = require "storyboard"

-- load scenetemplate.lua
storyboard.gotoScene( "menu" )

--Activate multi-touch so we can press multiple buttons at once.
system.activate("multitouch")

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):