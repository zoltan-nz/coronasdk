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
  local t = event.target
  print("Moving: ")

end



-- Called when the scene's view does not exist:
function scene:createScene( event )
	local displayGroup = self.view
  local dpadGroup = display.newGroup();
  displayGroup:insert(dpadGroup);

  -- Draw a Text Button for toggle all sound.
  shared.drawSoundONOFFButton(displayGroup)

  -- Draw a background
  shared.drawBackground(displayGroup)

  -- Draw a back to Menu button
  shared.drawBackToMenu(displayGroup)

  -- Setup button width and height
  local w = 200
  local h = 200

	local leftButton = display.newImageRect(dpadGroup, "images/buttonLeft.png", w, h)
  leftButton.x = _W/2-w; leftButton.y = _H-h; leftButton.dir = "left"
  leftButton:addEventListener("touch", moveButton)

  local rightButton = display.newImageRect(dpadGroup, "images/buttonRight.png", w, h)
  rightButton.x = _W/2+w; rightButton.y = leftButton.y; rightButton.dir = "right"
  rightButton:addEventListener("touch", moveButton)

  --Create up and down button
  local upButton = display.newImageRect(dpadGroup, "images/buttonLeft.png", w, h)
  upButton.rotation = 90
  upButton.x = _W/2; upButton.y = _H-(2*h); upButton.dir = "up"
  upButton:addEventListener("touch", moveButton)

  local downButton = display.newImageRect(dpadGroup, "images/buttonRight.png", w, h)
  downButton.rotation = 90
  downButton.x = _W/2; downButton.y = _H-h; downButton.dir = "down"
  downButton:addEventListener("touch", moveButton)


end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)

	-----------------------------------------------------------------------------

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	-----------------------------------------------------------------------------

	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

	-----------------------------------------------------------------------------

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