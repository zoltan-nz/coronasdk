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

-- we use physics API in this game
local physics = require("physics")

-- start physics and setup gravity
physics.start()
physics.setGravity(0, 9.8)

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

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local displayGroup = self.view

  -- Draw a background
  shared.drawBackground(displayGroup)

  -- Draw a Text Button for toggle all sound.
  shared.drawSoundONOFFButton(displayGroup)

  -- Draw a back to Menu button
  shared.drawBackToMenu(displayGroup)

  -- Group for siluett
  local silhouetteGroup = display.newGroup()
  displayGroup:insert(silhouetteGroup)

  local objectGroup = display.newGroup()
  displayGroup:insert(objectGroup)

  local groundGroup = display.newGroup()
  displayGroup:insert(groundGroup)

  -- Create three objects and silhouettes

  -- Draw a rectangle silhouette
  local rectangleObject = display.newRect(0, 0, 80, 80 )
  rectangleObject.strokeWidth = 3
  rectangleObject:setFillColor(0,0,0)
  rectangleObject:setStrokeColor(255, 0, 0)
  silhouetteGroup:insert(rectangleObject)
  rectangleObject.x = 55; rectangleObject.y = 60

  -- Draw a circle silhouette
  local circleSilhouette = display.newCircle(0,0, 40)
  circleSilhouette.strokeWidth = 3
  circleSilhouette:setFillColor(0,0,0)
  circleSilhouette:setStrokeColor(0, 255, 0)
  silhouetteGroup:insert(circleSilhouette)
  circleSilhouette.x = 160; circleSilhouette.y = 60

  -- Draw a rounded rectangle silhouette
  local roundedSilhouette = display.newRoundedRect(0,0, 80, 80, 20)
  roundedSilhouette.strokeWidth = 3
  roundedSilhouette:setFillColor(0,0,0)
  roundedSilhouette:setStrokeColor(0, 0, 255)
  silhouetteGroup:insert(roundedSilhouette)
  roundedSilhouette.x = 265; roundedSilhouette.y = 60

  -- Draw three object

  -- Draw a rectangle silhouette
  local rectangleObject = display.newRect(0, 0, 80, 80 )
  rectangleObject.strokeWidth = 3
  rectangleObject:setFillColor(255, 0, 0)
  rectangleObject:setStrokeColor(0, 0, 0)
  objectGroup:insert(rectangleObject)
  rectangleObject.x = 265; rectangleObject.y = 300

  -- Draw a circle silhouette
  local circleObject = display.newCircle(0,0, 40)
  circleObject.strokeWidth = 3
  circleObject:setFillColor(0, 255, 0)
  circleObject:setStrokeColor(0, 0, 0)
  silhouetteGroup:insert(circleObject)
  circleObject.x = 55; circleObject.y = 300

  -- Draw a rounded rectangle silhouette
  local roundedObject = display.newRoundedRect(0,0, 80, 80, 20)
  roundedObject.strokeWidth = 3
  roundedObject:setFillColor(0,0,255)
  roundedObject:setStrokeColor(0, 0, 0)
  silhouetteGroup:insert(roundedObject)
  roundedObject.x = 160; roundedObject.y = 300

  local ground = display.newLine(0, 342, _W, 342)
  groundGroup:insert(ground)
  ground:setColor(255,102, 102)
  ground.width = 6
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