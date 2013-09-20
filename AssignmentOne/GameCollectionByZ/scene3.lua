----------------------------------------------------------------------------------
--
-- scene3.lua
-- Created by Zoltan Debre
--
-- Scene 3
-- 1. 3 object at the bottom
-- 2. Silhouette above them
-- 3. Drag, if wrong back to original, if OK snap it
-- 4. Audio notification about snap.
--
-- Code was used from following sources:
-- Source: http://www.coronalabs.com/blog/2013/07/23/tutorial-non-physics-collision-detection/
-- Source: http://developer.coronalabs.com/code/flashs-hittestobject-emulated-using-contentbounds
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

-- Loading shared functions
local shared = require ( "sharedfunctions" )

-- This game is perfectly working without any physics.
-- First I tried to implement with physic, but finally I commented out all physics related lines.

-- we use physics API in this game
-- local physics = require("physics")

-- start physics and setup gravity
-- physics.start()
-- physics.setGravity(0, 9.8)


--load snap sound effect
local snapSound = audio.loadSound("sounds/snap.mp3")
local snapChannel

local rectangleObject, circleObject, roundedObject, rectangleSilhouette, circleSilhouette, roundedSilhouette
local wallTop, wallLeft, wallRight, wallBottom

-- Setup y coordinate of playground. Below this are buttons.
local bottom = 342
-- All object
local objectWidth = 40

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

-- Source: http://www.coronalabs.com/blog/2013/07/23/tutorial-non-physics-collision-detection/
--circle-based collision detection
local function hasCollidedCircle( obj1, obj2 )
  if ( obj1 == nil ) then  --make sure the first object exists
    return false
  end
  if ( obj2 == nil ) then  --make sure the other object exists
    return false
  end

  local dx = obj1.x - obj2.x
  local dy = obj1.y - obj2.y

  local distance = math.sqrt( dx*dx + dy*dy )
  local objectSize = (obj2.contentWidth/2) + (obj1.contentWidth/2)

  if ( distance < objectSize ) then
    return true
  end
  return false
end

-- Below function originaly was in Share Your Code section on coronalabs website
-- Source: http://developer.coronalabs.com/code/flashs-hittestobject-emulated-using-contentbounds
-- rectangle-based collision detection
local function hasCollided( obj1, obj2 )
  if ( obj1 == nil ) then  --make sure the first object exists
    return false
  end
  if ( obj2 == nil ) then  --make sure the other object exists
    return false
  end

  local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
  local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
  local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
  local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax

  return (left or right) and (up or down)
end


-- This startDrag function originaly copied from DragPlatform sample code in Corona Package and customized mainly.
-- Border check: Objects cannot move outside defined border (0,0, _W, bottom)
-- Object matching and snapping options are implemented in this function. See below.
-- And finally physics commented out.
local function startDrag( event )
	local t = event.target
  local o = event.target.name

	local phase = event.phase

  if "began" == phase then
    tapChannel = audio.play( tapSound )
    display.getCurrentStage():setFocus( t )
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y

		-- Make body type temporarily "kinematic" (to avoid gravitional forces)
    --		event.target.bodyType = "kinematic"

		-- Stop current motion, if any
    --		event.target:setLinearVelocity( 0, 0 )
    --		event.target.angularVelocity = 0

	elseif t.isFocus then

    if ("moved" == phase) then

      -- I extended this function with this border check. New coordinates allowed if insert borders.
      local newX = event.x - t.x0
      local newY = event.y - t.y0

      if (newX > objectWidth) and (newX < _W-objectWidth) then
        t.x = newX
      end

      if (newY > objectWidth) and (newY < bottom-objectWidth) then
        t.y = newY
      end


		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false

      -- Inspiration from here: http://www.coronalabs.com/blog/2013/07/23/tutorial-non-physics-collision-detection/
      local hotSpot

      -- Check which object and if circle use hasCollidedCircle else use simple hasCollided function.
      if (o == "circleObject") then

        hotSpot = circleSilhouette

        if (hasCollidedCircle(t,hotSpot)) then
          -- Snap and play a snap music
          transition.to( t, {time=250, x=hotSpot.x, y=hotSpot.y} )
          snapChannel = audio.play(snapSound)
        else
          -- Move back to original position
          transition.to( t, {time=500, x=t.xStart, y=t.yStart} )
        end

      else
        if (o == "rectangleObject") then
          hotSpot = rectangleSilhouette
        end

        if (o == "roundedObject") then
          hotSpot = roundedSilhouette
        end

        if ( hasCollided( t, hotSpot ) ) then
          -- Snap in place and play sound.
          transition.to( t, {time=250, x=hotSpot.x, y=hotSpot.y} )
          snapChannel = audio.play(snapSound)
        else
          -- Move back to original position.
          transition.to( t, {time=500, x=event.target.xStart, y=event.target.yStart} )
        end
      end


		end
	end

	-- Stop further propagation of touch event!
	return true
end

--local collision = function(event)
--  local o1 = event.object1.name
--  local o2 = event.object2.name
--  print 'in collision'
--  print(o1)
--  print(o2)
--  if (o1 == "wall") or (o2 == "wall") then
--    print 'hit a wall'
--  end
--
--end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local displayGroup = self.view

  -- Draw a background
  shared.drawBackground(displayGroup)

  -- Draw a Text Button for toggle all sound.
  --  shared.drawSoundONOFFButton(displayGroup)
  --  displayGroup:insert(soundButton)
  -- Draw a back to Menu button
  shared.drawBackToMenu(displayGroup)

  local wallGroup = display.newGroup()
  displayGroup:insert(wallGroup)

  -- Group for siluett
  local silhouetteGroup = display.newGroup()
  displayGroup:insert(silhouetteGroup)

  local objectGroup = display.newGroup()
  displayGroup:insert(objectGroup)



  -- Create walls
  wallTop = display.newRect(0,0,_W, 2)
  wallBottom = display.newRect(0, 0, _W, 2)
  wallBottom.y = bottom
  wallLeft = display.newRect(0,0, 2, bottom)
  wallRight = display.newRect(0, 0, 2, bottom)
  wallRight.x = _W-2

  -- Create a helper function for settings. Just for trying to make this code a little bit TRY
  local setParams = function(wall)
    wallGroup:insert(wall)
    wall:setStrokeColor(255,255,255)
    wall:setFillColor(255,255,255)
    wall.strokeWidth = 2
    --    physics.addBody( wall,  "static", { density = 10, friction=0.5, bounce=0.1} )
    wall.name = "wall"
  end

  setParams(wallBottom)
  setParams(wallTop)
  setParams(wallLeft)
  setParams(wallRight)




  -- Create three objects and silhouettes
  -- Silhouettes should bigger a little bit than snapped object.

  -- Draw a rectangle silhouette
  rectangleSilhouette = display.newRect(0, 0, 82, 82 )
  rectangleSilhouette.strokeWidth = 3
  rectangleSilhouette:setFillColor(0,0,0)
  rectangleSilhouette:setStrokeColor(255, 0, 0)
  silhouetteGroup:insert(rectangleSilhouette)
  rectangleSilhouette.x = 55; rectangleSilhouette.y = 60
  --  physics.addBody(rectangleSilhouette, "static", {bounce=0, isSensor = true} )
  rectangleSilhouette.name = "rectangleSilhouette"

  -- Draw a circle silhouette
  circleSilhouette = display.newCircle(0,0, 41)
  circleSilhouette.strokeWidth = 3
  circleSilhouette:setFillColor(0,0,0)
  circleSilhouette:setStrokeColor(0, 255, 0)
  silhouetteGroup:insert(circleSilhouette)
  circleSilhouette.x = 160; circleSilhouette.y = 60
  --  physics.addBody(circleSilhouette, "static", {bounce=0, isSensor = true})
  circleSilhouette.name = "circleSilhouette"

  -- Draw a rounded rectangle silhouette
  roundedSilhouette = display.newRoundedRect(0,0, 82, 82, 20)
  roundedSilhouette.strokeWidth = 3
  roundedSilhouette:setFillColor(0,0,0)
  roundedSilhouette:setStrokeColor(0, 0, 255)
  silhouetteGroup:insert(roundedSilhouette)
  roundedSilhouette.x = 265; roundedSilhouette.y = 60
  --  physics.addBody(roundedSilhouette, "static", {bounce=0, isSensor = true})
  roundedSilhouette.name = "roundedSilhouette"

  -- Draw three object

  -- Draw a dragable rectangle  object
  rectangleObject = display.newRect(0, 0, 80, 80 )
  rectangleObject.strokeWidth = 1
  rectangleObject:setFillColor(255, 0, 0)
  rectangleObject:setStrokeColor(0, 0, 0)
  objectGroup:insert(rectangleObject)
  rectangleObject.x = 265; rectangleObject.y = 300
  rectangleObject.xStart = 265; rectangleObject.yStart = 300
  --  physics.addBody(rectangleObject, "kinematic", {bounce=0})
  rectangleObject.name = "rectangleObject"

  -- Draw a dragable circle object
  circleObject = display.newCircle(0,0, 40)
  circleObject.strokeWidth = 1
  circleObject:setFillColor(0, 255, 0)
  circleObject:setStrokeColor(0, 0, 0)
  objectGroup:insert(circleObject)
  circleObject.x = 55; circleObject.y = 300
  circleObject.xStart = 55; circleObject.yStart = 300
  --  physics.addBody(circleObject, "kinematic", {bounce=0})
  circleObject.name = "circleObject"

  -- Draw a dragable rounded rectangle object
  roundedObject = display.newRoundedRect(0,0, 80, 80, 20)
  roundedObject.strokeWidth = 1
  roundedObject:setFillColor(0,0,255)
  roundedObject:setStrokeColor(0, 0, 0)
  objectGroup:insert(roundedObject)
  roundedObject.x = 160; roundedObject.y = 300
  roundedObject.xStart = 160; roundedObject.yStart = 300
  --  physics.addBody(roundedObject, "kinematic", {bounce=0})
  roundedObject.name = "roundedObject"
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view

  -----------------------------------------------------------------------------

  --	INSERT code here (e.g. start timers, load audio, start listeners, etc.)

  -----------------------------------------------------------------------------

  -- Decrase of backround music volume while user play the game.
  audio.setVolume( 0.3, { channel=1 } )

  rectangleObject:addEventListener('touch', startDrag)
  circleObject:addEventListener('touch', startDrag)
  roundedObject:addEventListener('touch', startDrag)

  --  Runtime:addEventListener("collision", collision)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
  --  print( 'exit scene 3')
  local group = self.view

  -----------------------------------------------------------------------------

  --	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

  -----------------------------------------------------------------------------
  rectangleObject:removeEventListener('touch', startDrag)
  circleObject:removeEventListener('touch', startDrag)
  roundedObject:removeEventListener('touch', startDrag)

  --  Runtime:removeEventListener("collision", collision)

  audio.setVolume( 0.8, { channel=1 } )
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
  local group = self.view

  -----------------------------------------------------------------------------

  --	INSERT code here (e.g. remove listeners, widgets, save state, etc.)

  -----------------------------------------------------------------------------
  audio.dispose(snapSound)
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