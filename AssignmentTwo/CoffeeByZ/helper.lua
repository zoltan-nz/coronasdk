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

---------------------------------------------------------------------------
-- Button creator function.
local createButton = function (options)

  options.fontsize = options.fontsize or 12

  local createdButton = widget.newButton
  {
    id           = options.id,
    left         = options.left,
    top          = options.top,
    width        = options.width,
    height       = options.height,
    label        = options.label,
    onPress      = options.onevent,
    fontSize     = options.fontsize,
    defaultFile  = options.defaultfile,
    labelXOffset = options.labelxoffset,
    labelYOffset = options.labelyoffset
  }

  return(createdButton)
end
M.createButton = createButton

---------------------------------------------------------------------------
-- I prefer to draw a clean background instead of messy graphics... this function will manage that.
local drawBackground = function (group)

	local background 
  background = display.newRect(group, 0, 0, _W, _H )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
  background:setFillColor(247,246,228)

end
M.drawBackground = drawBackground

---------------------------------------------------------------------------
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

  backButton = createButton(_W-110, _H-50, 100, 40, '', '', "Menu", backToMenuEvent)
  group:insert(backButton)

end
M.drawBackToMenu = drawBackToMenu

---------------------------------------------------------------------------
-- This function create a Menu Bar on screens where we need
local drawMenuBar = function (group)
   
  -- event listeners for buttons:
  local showView = function(event)
    view = event.target.id
    storyboard.gotoScene( view )
  end

  local homeButton      = createButton({id='home',        label = 'HOME',       left=(0),     top = _H-50, width = 80, height = 50, onevent=showView, defaultfile = 'images/tab_bg.png'})
  local productsButton  = createButton({id='categories',  label = 'PRODUCTS',   left=(1*80),  top = _H-50, width = 80, height = 50, onevent=showView, defaultfile = 'images/tab_bg.png'})
  local aboutButton     = createButton({id='about',       label = 'ABOUT',      left=(2*80),  top = _H-50, width = 80, height = 50, onevent=showView, defaultfile = 'images/tab_bg.png'})
  local contactButton   = createButton({id='contact',     label = 'CONTACT',    left=(3*80),  top = _H-50, width = 80, height = 50, onevent=showView, defaultfile = 'images/tab_bg.png'})

  group:insert(homeButton)
  group:insert(productsButton)
  group:insert(aboutButton)
  group:insert(contactButton)

  return true

end
M.drawMenuBar = drawMenuBar



return M