
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
	{ id='home', 		 label="Home", 		 size=20, onPress=showView, defaultFile = 'images/grey_bg.png', overFile = 'images/grey_bg.png', width=20, height=20, font = "HelveticaNeue-Light", selected=true },
 	{ id='products', label="Products", size=20, onPress=showView, defaultFile = 'images/grey_bg.png', overFile = 'images/grey_bg.png', width=20, height=20, font = "HelveticaNeue-Light", 							},
 	{ id='about', 	 label="About", 	 size=20, onPress=showView, defaultFile = 'images/grey_bg.png', overFile = 'images/grey_bg.png', width=20, height=20, font = "HelveticaNeue-Light", 							},
 	{ id='contact',  label="Contact",  size=20, onPress=showView, defaultFile = 'images/grey_bg.png', overFile = 'images/grey_bg.png', width=20, height=20, font = "HelveticaNeue-Light", 							},
}

-- create the actual tabBar widget
local tabBar = widget.newTabBar {
	top 										=	display.contentHeight - 30,	-- 50 is default height for tabBar widget
	height 									= 20,
	buttons 								=	tabButtons,
	tabSelectedFrameWidth 	= 20,
	tabSelectedFrameHeight 	= 30,
	tabSelectedLeftFile			=	'images/grey_bg.png',
	tabSelectedRightFile		=	'images/grey_bg.png',
	tabSelectedMiddleFile		=	'images/grey_bg.png',
	backgroundFile					=	'images/grey_bg.png',
	defaultFile							=	'images/grey_bg.png',

}

showView()	-- invoke first tab button's onPress event manually