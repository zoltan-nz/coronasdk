-----------------------------
--
-- Helper
-- 
-- Created by Zoltan Debre
-- 
-- I collect here reusable functions to keep my code a little bit DRY.
--
------------------------

local widget = require ('widget')
local storyboard = require ("storyboard")

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

-- This file behave as a module.
local M = {}

-- Button creator function.
local createButton = function (id, left, top, width, height, label, onevent, fontsize)

  fontsize = fontsize or 12

  local createdButton = widget.newButton
  {
    id        = id,
    left      = left,
    top       = top,
    width     = width,
    height    = height,
    label     = label,
    onPress   = onevent,
    fontSize  = fontsize
  }

  return(createdButton)
end
M.createButton = createButton

-- I prefer to draw a clean background instead of messy graphics... this function will manage that.
local drawBackground = function (group)

	local background 
  background = display.newRect(group, 0, 0, _W, _H )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
  background:setFillColor(30,30,30)

end
M.drawBackground = drawBackground


-- Back to menu button is exist in each screen. This function will create it.
local drawBackToMenu = function (group)

  local backToMenuEvent = function (event)
    local phase = event.phase

    if phase == "began" then
      tapChannel = audio.play( tapSound )
    end

    if phase == "ended" then
      storyboard.gotoScene( "menu" )
    end
  end

  backButton = createAButton(_W-110, _H-50, 100, 40, '', '', "Menu", backToMenuEvent)
  group:insert(backButton)

end
M.drawBackToMenu = drawBackToMenu

-- This function create a Tab Bar on screens where we need

local createTabBar = function (screen)

  -- event listeners for tab buttons:
  local showView = function(event)
    view = event.target._id
    storyboard.gotoScene( view )
  end

  -- create a tabBar widget with two buttons at the bottom of the screen
  -- table to setup buttons
  local tabButtons = {
    { id='home',     label="Home",     size=20, onPress=showView, defaultFile = 'images/grey_bg.png', overFile = 'images/grey_bg.png', width=20, height=20, font = "HelveticaNeue-Light", selected=true },
    { id='products', label="Products", size=20, onPress=showView, defaultFile = 'images/grey_bg.png', overFile = 'images/grey_bg.png', width=20, height=20, font = "HelveticaNeue-Light",               },
    { id='about',    label="About",    size=20, onPress=showView, defaultFile = 'images/grey_bg.png', overFile = 'images/grey_bg.png', width=20, height=20, font = "HelveticaNeue-Light",               },
    { id='contact',  label="Contact",  size=20, onPress=showView, defaultFile = 'images/grey_bg.png', overFile = 'images/grey_bg.png', width=20, height=20, font = "HelveticaNeue-Light",               },
  }

  -- create the actual tabBar widget
  local tabBar = widget.newTabBar {
    top                     = display.contentHeight - 30, -- 50 is default height for tabBar widget
    height                  = 20,
    buttons                 = tabButtons,
    tabSelectedFrameWidth   = 20,
    tabSelectedFrameHeight  = 30,
    tabSelectedLeftFile     = 'images/grey_bg.png',
    tabSelectedRightFile    = 'images/grey_bg.png',
    tabSelectedMiddleFile   = 'images/grey_bg.png',
    backgroundFile          = 'images/grey_bg.png',
    defaultFile             = 'images/grey_bg.png',
  }

return(tabBar)
end
M.createTabBar = createTabBar



return M