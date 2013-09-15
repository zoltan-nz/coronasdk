----------------------------------------------------------------------------------
--
-- menu.lua
--
--[[

This is the main menu screen.

1. Loading widget modul and creating button widgets.
2. Connect click event to buttons and linking to other screens.

--]]
--
--
----------------------------------------------------------------------------------


local storyboard = require( "storyboard" )

-- Loading widget module for buttons
local widget = require ('widget')

local scene = storyboard.newScene()

-- Loading shared functions
local shared = require ( "sharedfunctions" )

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

-- Called when the scene's view does not exist:
function scene:createScene( event )
  -- Initializing groups
  local displayGroup = self.view
  local buttonGroup = display.newGroup()

  -- Draw a Text Button for toggle Sound
  shared.drawSoundONOFFButton(displayGroup)

  -- Draw a Background
  shared.drawBackground()

  -- Creating a function to handle button events
  local function buttonOneEvent (event)
    local phase = event.phase
    if 'ended' == phase then
      print('You pressed and released a button!')
    end
  end

  local buttons = {
    "First Game",
    "Second Game",
    "Third Game"
  }
  -- Button One
  local buttonOne = shared.createAButton(100, 100, 100, 100, {10, 10, 10, 0}, {30, 30, 30, 0}, "BUTTON ONE", buttonOneEvent)
  buttonGroup:insert (buttonOne)




end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view


end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
end


scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene