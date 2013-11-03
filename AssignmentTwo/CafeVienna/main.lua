-- Cafe Vienna
-- Developed by Zoltan Debre
-- Cafe shop menu application

-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

local widget = require "widget"
local storyboard = require "storyboard"

-- Start on home screen
storyboard.gotoScene( 'home' )