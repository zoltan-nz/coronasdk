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

-- turn on physics
local physics = require ('physics')
physics.start()
physics.setGravity(0, 9.8)
-- below mode great for debugging...
physics.setDrawMode( "hybrid" )

-- couple of sound effects
local explosionSound = audio.loadSound("sounds/explosion.mp3")
local explosionChannel

local deathSound = audio.loadSound("sounds/death.mp3")
local deathChannel

local ground
-- platforms hold stones
local platforms = {}
local stones = {}
local platformGroup
local stoneGroup

local character
local characterGroup

-- Character. I use here my famous Koala who was known as Rambo Panda: http://zoltandebre.com/rambopanda/
-- This paramters will be used when create character sprite below.
local characterSheet = graphics.newImageSheet( "images/playerSprite.png", { width = 45, height = 62, numFrames = 5, sheetContentWidth = 225, sheetContentHeight = 62 })
local characterSprite = {name="run", start=1, count=3, time = 400, loopCount = 0 }

-- this function will be called if user click on platform and remove the platform from the screen
local platformKiller = function(event)

  local t = event.target
  local phase = event.phase

  if phase == "began" then
    explosionChannel = audio.play( explosionSound )
    display.remove(t)
  end

end

-- Platforms position generated randomly.
-- It is called always when use relaunch this game
local randomPlatformGenerator = function()
  -- ranges helps to control random numbers to avoid generating platform too close to each other
  local y_range = {{y1 = 40, y2 = 80}, {y1 = 130, y2=190}, {y1=230, y2=300}}
  for i=1,3 do
    platforms[i] = display.newRect(platformGroup, 0, 0, 100, 20)
    platforms[i]:setReferencePoint(display.TopLeftReferencePoint)
    -- create a random x and y coordinate between the given range.
    local x = math.random(0,240)
    local y = math.random(y_range[i].y1, y_range[i].y2)
    platforms[i].x = x
    platforms[i].y = y
    platforms[i].name = 'platform'
    physics.addBody( platforms[i],  "static", { friction=0.1, bounce=0 } )

    stones[i] = display.newCircle(100, 100, 30)
    stoneGroup:insert(stones[i])
    -- with settings reference point of stones to bottom center, will be easier to put on platforms
    stones[i]:setReferencePoint(display.BottomCenterReferencePoint)
    stones[i].x = x+50
    stones[i].y = y
    stones[i].name = 'stone'
    -- create a circle shape, each coordinate a vertex point. 0,0 is the centre of the circle, because 30 is the radius, -30,0 will be the left side of the circle, etc...
    -- Here I use cosinus and sinus to determine a little bit more than only 4 shape points. I create 12 point with a for loop
    -- Sinus give back x coordinates, Cosinus gives back y coordinate
    -- sin and cos need value in radians... math.rad will convert degree to radiant
    local circleShape = {}
    local poligon = 8  -- with this easy to decrease or increase numbers of poligons, unfortunately coronasdk manages only 8 vertex points...
    local degreeStep = 360/poligon
    local radius = 30
    local counter = 1 -- using for position in circleShape
    for i=0,poligon-1 do
      local radian = math.rad(degreeStep * i)
      local xcord = math.sin(radian) * radius
      circleShape[counter] = xcord; counter = counter + 1
      local ycord = math.cos(radian) * radius
      circleShape[counter] = ycord; counter = counter + 1
      --      print('Degree: '..degreeStep * i..' Radian: '..radian..' Xcord: '..xcord..' Ycord: '..ycord)
    end
    physics.addBody(stones[i], 'dynamic', { friction=1, bounce=0.1, shape = circleShape})

    -- add remove touch event to each platform
    platforms[i]:addEventListener("touch", platformKiller)

  end
end



-- Called when the scene's view does not exist:
function scene:createScene( event )
	local displayGroup = self.view

  -- Draw a background
  shared.drawBackground(displayGroup)

  -- Draw a back to Menu button
  shared.drawBackToMenu(displayGroup)

  -- Create ground
  local groundGroup = display.newGroup();
  displayGroup:insert(groundGroup);

  ground = display.newImageRect(groundGroup, "images/floor.png", 480, 48)
  ground:setReferencePoint(display.TopLeftReferencePoint); ground.x = 0; ground.y = _H-110; ground.name = "floor"
  physics.addBody( ground,  "static", { friction=0.1, bounce=0 } )

  -- Platform Generator will be called in enterScene
  platformGroup = display.newGroup()
  displayGroup:insert(platformGroup)

  stoneGroup = display.newGroup()
  displayGroup:insert(stoneGroup)

  characterGroup = display.newGroup()
  displayGroup:insert(characterGroup)

  -- Create character, it is a sprite
  character = display.newSprite(characterSheet, characterSprite)
  character:setReferencePoint(display.BottomCenterReferencePoint)
  character.x = 140; character.y = _H-110; character.name = "character"
  character:setSequence("run"); character:play()
  characterGroup:insert(character);

  -- setup shape of character to properly manage collisions
  local characterShape = { -16,-28, 16,-28, 16,31, -16,31 }
  physics.addBody( character,  "dynamic", { friction=1, bounce=0, shape=characterShape} )
  -- just rotate left and right
  character.isFixedRotation = true
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

  -- Have to generate new platforms here in enterScene, because we want to create always new platforms when user reenter the game.
  randomPlatformGenerator()


end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

  -- remove platforms
  -- If user goes back to main menu, then platforms deleted and if comes back later, generated a new random position...
  for i=1,3 do
    display.remove(platforms[i]);
    display.remove(stones[i])
  end
  platforms = {}
  stones = {}

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