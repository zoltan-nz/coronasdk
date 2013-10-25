
-- show default status bar (iOS)
display.setStatusBar( display.DefaultStatusBar )

-- include Corona's "widget" library
local widget = require "widget"
local storyboard = require "storyboard"


-- event listeners for tab buttons:
local showView = function(event)
	if event then
		view = event.target._id
	else
		view = 'home'
	end
	print (view)
	storyboard.gotoScene( view )
end

-- create a tabBar widget with two buttons at the bottom of the screen
-- table to setup buttons
local tabButtons = {
	{ id='home', 		 label="Home", 		size=20, onPress=showView, 		selected=true },
 	{ id='products', label="Products", size=20, onPress=showView 							},
 	{ id='about', 	 label="About", 		size=20, onPress=showView								},
 	{ id='contact',  label="Contact", 	size=20, onPress=showView 								},
}

-- create the actual tabBar widget
local tabBar = widget.newTabBar{
	top = display.contentHeight - 50,	-- 50 is default height for tabBar widget
	buttons = tabButtons
}

showView()	-- invoke first tab button's onPress event manually