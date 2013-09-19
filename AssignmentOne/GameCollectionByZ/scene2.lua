----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

-- Loading shared functions
local shared = require ( "sharedfunctions" )

-- Init outside functions to be available across the modul
local character, playground

-- Buttons
local leftButton, rightButton, upButton, downButton

-- Some useful variable for sharing status
local movementInProgress, direction

-- A loop what is always watching... have to removeEventListener when exit.
local gameLoop

local tapChannel
----------------------------------------------------------------------------------
--
--	NOTE:
--
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
--
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- MOVING FUNCTIONS
--
-- This function manage the moving. Called when user click on an arrow.
--------------------------------------------------------------------------------

local moveButton = function(event)

  -- t = which button was pressed
  local t = event.target
  -- phase = just touched or released
  local phase = event.phase



  if phase == "began" then
    tapChannel = audio.play( tapSound )
    movementInProgress = true
    direction = t.dir
  end

  if phase == "ended" then
    if movementInProgress then
      movementInProgress = false

    end
  end
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
  local displayGroup = self.view

  -- Draw a background
  shared.drawBackground(displayGroup)

  local dpadGroup = display.newGroup()
  displayGroup:insert(dpadGroup)

  local characterGroup = display.newGroup()
  displayGroup:insert(characterGroup)

  -- Draw a Text Button for toggle all sound.
  shared.drawSoundONOFFButton(displayGroup)

  -- Draw a back to Menu button
  shared.drawBackToMenu(displayGroup)

  -- Setup button width and height
  local w = 50
  local h = 50

  -- .dir property will store the direction and based on this could move the character
  leftButton = display.newImageRect(dpadGroup, "images/buttonLeft.png", w, h)
  leftButton.x = _W/2-w; leftButton.y = _H-(2*h); leftButton.dir = "left"

  rightButton = display.newImageRect(dpadGroup, "images/buttonRight.png", w, h)
  rightButton.x = _W/2+w; rightButton.y = leftButton.y; rightButton.dir = "right"

  --Create up and down button
  upButton = display.newImageRect(dpadGroup, "images/buttonLeft.png", w, h)
  upButton.rotation = 90
  upButton.x = _W/2; upButton.y = _H-(3*h); upButton.dir = "up"

  downButton = display.newImageRect(dpadGroup, "images/buttonRight.png", w, h)
  downButton.rotation = 90
  downButton.x = _W/2; downButton.y = _H-(2*h); downButton.dir = "down"

  --Create a playground for character
  --Bounder is
  playground = display.newRect(characterGroup, 0,0,_W,_H-180)
  playground:setReferencePoint( display.TopLeftReferencePoint )
  playground.x = 0; playground.y = 0
  playground:setFillColor(0, 50, 0)

  --Create target character which will be moved by arrows.
  character = display.newRoundedRect(characterGroup,_W/2-50,_H/5,40,40,3)
  character.strokeWidth = 2
  character:setFillColor(0, 255, 0)

end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view

  -----------------------------------------------------------------------------

  --	INSERT code here (e.g. start timers, load audio, start listeners, etc.)

  -----------------------------------------------------------------------------


  -- Decrase of backround music volume while user play the game.
  audio.setVolume( 0.3, { channel=1 } )

  leftButton:addEventListener("touch", moveButton)
  rightButton:addEventListener("touch", moveButton)
  upButton:addEventListener("touch", moveButton)
  downButton:addEventListener("touch", moveButton)

  -- gameLoop will run always as a loop, so if movementInProgress set true above than this will fired and translate the character
  gameLoop = function()
    local deltaX, deltaY
    if movementInProgress == true then
      if direction == "up" then
        deltaX = 0 ; deltaY = -5
      end
      if direction == "down" then
        deltaX = 0 ; deltaY = 5
      end
      if direction == "right" then
        deltaX = 5 ; deltaY = 0
      end
      if direction == "left" then
        deltaX = -5 ; deltaY = 0
      end

      local newx = character.x + deltaX
      local newy = character.y + deltaY

      -- Movement allowed only if it inside a limited arrea.
      if (newx > 20) and (newx < _W-20) and (newy > 20) and (newy < _H-200) then
        character:translate(deltaX, deltaY)
      end
    end
  end
  Runtime:addEventListener("enterFrame",gameLoop)
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
  local group = self.view

  -----------------------------------------------------------------------------

  --	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

  -----------------------------------------------------------------------------

  leftButton:removeEventListener("touch", moveButton)
  rightButton:removeEventListener("touch", moveButton)
  upButton:removeEventListener("touch", moveButton)
  downButton:removeEventListener("touch", moveButton)

  Runtime:removeEventListener("enterFrame",gameLoop)

  audio.setVolume( 0.8, { channel=1 } )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
  local group = self.view

  -----------------------------------------------------------------------------

  --	INSERT code here (e.g. remove listeners, widgets, save state, etc.)

  -----------------------------------------------------------------------------

end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene