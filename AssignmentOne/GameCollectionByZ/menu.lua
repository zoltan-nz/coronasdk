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

local tapChannel --Sound variables..

----------------------------------------------------------------------------------
-- Functions for button events.
-- Each button call an event and if clicking phase ended, will be called a new scene.
--
local gameButtonClicked = function (event)

  local phase = event.phase
  local t = event.target

  -- each button has a button parameter which stores scene name
  local button = t.button

  if phase == "began" then
    tapChannel = audio.play( tapSound )
  end

  if phase == "ended" then
    storyboard.gotoScene(button)
  end

end


----------------------------------------------------------------------------------
-- @param event
-- @return




-- Called when the scene's view does not exist:
function scene:createScene( event )
  -- Initializing groups
  local displayGroup = self.view

  -- Draw a background
  shared.drawBackground(displayGroup)

  -- Draw a Text Button for toggle all sound.
  shared.drawSoundONOFFButton()

  -- Write out a Welcome message
  local welcomeText = display.newText({parent = displayGroup, text = "Welcome in Game Menu", x = _W/2, y = 50, font = native.systemFontBold, align = "center", fontSize = 25, width = _W, height = 50})

  local buttonGroup = display.newGroup()
  displayGroup:insert(buttonGroup)

  -- Button One, Button Two and Button Three
  local buttonOne = shared.createAButton(10, _H/5, _W-20, 100, {10, 10, 10, 0}, {30, 30, 30, 0}, "GAME ONE", gameButtonClicked, 20)
  buttonGroup:insert (buttonOne)
  buttonOne.button = 'scene2'
  local buttonTwo = shared.createAButton(10, (_H/5)*2, _W-20, 100, {10, 10, 10, 0}, {30, 30, 30, 0}, "GAME TWO", gameButtonClicked, 20)
  buttonGroup:insert (buttonTwo)
  buttonTwo.button = 'scene3'
  local buttonThree = shared.createAButton(10, (_H/5)*3, _W-20, 100, {10, 10, 10, 0}, {30, 30, 30, 0}, "GAME THREE", gameButtonClicked, 20)
  buttonGroup:insert (buttonThree)
  buttonThree.button = 'scene4'

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