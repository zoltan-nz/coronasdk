
-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

-- include Corona's "widget" library
local widget = require "widget"
local storyboard = require "storyboard"



-- Start on home screen
storyboard.gotoScene( 'home' )