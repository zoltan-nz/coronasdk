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
--physics.setDrawMode( "hybrid" )

-- couple of sound effects
local explosionSound = audio.loadSound("sounds/explosion.mp3")
local explosionChannel

local shootSound = audio.loadSound("sounds/shoot.mp3")
local shootChannel

local laughSound = audio.loadSound('sounds/laugh.mp3')
local laughChannel

local applauseSound = audio.loadSound('sounds/applause.mp3')
local applauseChannel

local ground, tryButton, endMessage

-- If a stone left the screen lives will reduce.
local lives = 3
local livesText

-- platforms hold stones
local platforms = {}
local stones = {}
local platformGroup
local stoneGroup

local character
local characterGroup

-- Character live when the game start. Using this in gameLoop, if false character will not move anymore... What a pitty... :)
local characterAlive = true
-- If it will turn true, bad things will happen...
local characterDestroyable = false

-- Character. I use here my famous Koala who was known as Rambo Panda: http://zoltandebre.com/rambopanda/
-- This paramters will be used when create character sprite below.
local characterSheet = graphics.newImageSheet( "images/playerSprite.png", { width = 45, height = 62, numFrames = 5, sheetContentWidth = 225, sheetContentHeight = 62 })
local characterSprite = {
  {name="run", start=1, count=3, time = 400, loopCount = 0 },
  {name="jump", start=4, count=1, time = 1000, loopCount = 1 }
}

-- this function will be called if user click on platform and remove the platform from the screen
local platformKiller = function(event)

  local t = event.target
  local index = t.index
  local phase = event.phase

  if phase == "began" then
    --    explosionChannel = audio.play( explosionSound )
    shootChannel = audio.play(shootSound)
    display.remove(t)
    stones[index].bodyType = "dynamic"
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
    -- we use this index to identify which platform was destroyed... so make stone[index] dynamic to fall down
    platforms[i].index = i
    platforms[i]:setFillColor(150,150,150)
    physics.addBody( platforms[i],  "static", { friction=2, bounce=0 } )

    stones[i] = display.newCircle(100, 100, 30)
    stoneGroup:insert(stones[i])
    -- with settings reference point of stones to bottom center, will be easier to put on platforms
    stones[i]:setReferencePoint(display.BottomCenterReferencePoint)
    stones[i].x = x+50
    stones[i].y = y
    stones[i]:setFillColor(205,175,149)
    stones[i].name = 'stone'

    -- I created this circle shape generator below, but finally I found a 'radius' option in physics API, so just commented out, but I worked a lot on it, so I keep here as memento... :)
    --    -- create a circle shape, each coordinate a vertex point. 0,0 is the centre of the circle, because 30 is the radius, -30,0 will be the left side of the circle, etc...
    --    -- Here I use cosinus and sinus to determine a little bit more than only 4 shape points. I would like to create more...
    --    -- Sinus give back x coordinates, Cosinus gives back y coordinate
    --    -- sin and cos need value in radians... math.rad will convert degree to radiant
    --    local circleShape = {}
    --    local poligon = 8  -- with this easy to decrease or increase numbers of poligons, unfortunately coronasdk manages only 8 vertex points...
    --    local degreeStep = 360/poligon
    --    local radius = 30
    --    local counter = 1 -- using for position in circleShape
    --    for i=0,poligon-1 do
    --      local radian = math.rad(degreeStep * i)
    --      local xcord = math.sin(radian) * radius
    --      circleShape[counter] = xcord; counter = counter + 1
    --      local ycord = math.cos(radian) * radius
    --      circleShape[counter] = ycord; counter = counter + 1
    --      --      print('Degree: '..degreeStep * i..' Radian: '..radian..' Xcord: '..xcord..' Ycord: '..ycord)
    --    end
    --    physics.addBody(stones[i], "static", { friction=1, bounce=0.1, shape = circleShape})
    physics.addBody(stones[i], "static", { friction=0.5, bounce=0, radius = 30})

    -- add remove touch event to each platform
    platforms[i]:addEventListener("touch", platformKiller)

  end
end

-- Will be called when stone hit character... Yey! Applause!
local gamerWon = function ()
  applauseChannel = audio.play(applauseSound)
  display.remove(character)
  for i = 1,3 do
    display.remove(platforms[i])
    display.remove(stones[i])
  end
  endMessage = display.newText({text = 'You are the Winner!', x = _W/2, y = _H/3, fontSize = 22, align = "center"} )
end

-- Called when gamer lost the game... Hahaha... :)
local gamerLost = function()
  laughChannel = audio.play(laughSound)
  endMessage = display.newText({text = 'Looser!', x = _W/2, y = _H/3, fontSize = 22, align = "center"} )
  character:setLinearVelocity( 0, 0 )
  character:applyForce(0,-8, character.x, character.y)
  character:setSequence("jump")
end

-- This function called from loop if a stone went out from the screen...
-- If user lost all opportunity we write out a message.
local updateLivesText = function()
  livesText.text = "Lives: "..lives
  if lives == 0 then
    gamerLost()
  end
end

-- This function will manage our character continous movement
local gameLoop = function ()

  -- This variable will be true if collision valuation process changed this sensor.
  if characterDestroyable then
    characterDestroyable = false
    characterAlive = false
    explosionChannel = audio.play(explosionSound)
    gamerWon()
  end

  if characterAlive then
    local i
    for i = 1,1,-1 do
      -- check character exist properly and in position
      if character ~= nil and character.y ~= nil then
        -- using character.speed to setup direction
        character:translate( character.speed, 0)
        --Check character arrived end of the path, turn back...
        character.travelled = character.x;
        -- check character position before or after 10 pixel of the screen border...
        if character.travelled >= (_W -10) or character.travelled <= 10 then
          -- change direction
          character.speed = -character.speed
          -- sprite turn back
          character.xScale = -character.xScale
          character.travelled = 0
        end
      end
    end

    -- Here we check each stone x coordinate, if it is too small or too big then
    -- character thrown out of the screen... so we can remove it and user lost a life...
    local j
    for j=1,3 do
      if stones[j].x ~= nil then
        if stones[j].x < 0 or stones[j].x > _W then
          display.remove(stones[j])
          lives = lives - 1
          updateLivesText()
        end
      end
    end
  end
end

local collisionHappend = function (event)
  local o1 = event.object1
  local o2 = event.object2
  local name1 = o1.name
  local name2 = o2.name


  --  print ('Collision happend: '..name1..', '..name2)

  -- Check character and stone collided. But it is matter if stone arrived from top... in this case bad things will happend...
  -- Using characterDestroyable semafor, and if true, loop will manage the end...
  if (name1=='character') or (name2=='character') then
    if (name1=='stone') or (name2 == 'stone') then
      --      print('o1.name = '..o1.name)
      --      print('o2.name = '..o2.name)
      --      print('o1.y = '..o1.y)
      --      print('o2.y = '..o2.y)
      if name1 == 'character' then
        if o1.y>o2.y+40 then
          characterDestroyable = true
        end
      end
      if name2 == 'character' then
        if o1.y+40<o2.y then
          characterDestroyable = true
        end
      end
    end
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
  physics.addBody( ground,  "static", { friction=9, bounce=0 } )
  ground:setReferencePoint(display.TopLeftReferencePoint); ground.x = 0; ground.y = _H-110; ground.name = "floor"

  -- Platform Generator will be called in enterScene
  platformGroup = display.newGroup()
  displayGroup:insert(platformGroup)

  stoneGroup = display.newGroup()
  displayGroup:insert(stoneGroup)

  characterGroup = display.newGroup()
  displayGroup:insert(characterGroup)

  -- Have to generate new platforms here in enterScene, because we want to create always new platforms when user reenter the game.
  randomPlatformGenerator()

  -- Create character, it is a sprite
  character = display.newSprite(characterSheet, characterSprite)
  character:setReferencePoint(display.BottomCenterReferencePoint)
  character.x = 140; character.y = _H-110; character.name = "character"
  character:setSequence("run"); character:play()
  characterGroup:insert(character);
  character.speed = 5

  -- setup shape of character to properly manage collisions
  local characterShape = { -16,-28, 16,-28, 16,31, -16,31 }
  physics.addBody( character,  "dynamic", { friction=5, bounce=0, shape=characterShape} )
  -- just rotate left and right
  character.isFixedRotation = true

  livesText = display.newText({text = "Lives: "..lives, x=_W/2, y=_H-30, align = "center", fontSize = 15})
  displayGroup:insert(livesText)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
  local group = self.view
  audio.setVolume( 0.3, { channel=1 } )


  -- Call gameLoop to continous movement
  Runtime:addEventListener("enterFrame",gameLoop)
  Runtime:addEventListener("collision", collisionHappend)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
  --  print('exit scene 4')
  local group = self.view
  audio.setVolume( 0.8, { channel=1 } )
  -- remove platforms
  -- If user goes back to main menu, then platforms deleted and if comes back later, generated a new random position...
  for i=1,3 do
    display.remove(platforms[i]);
    display.remove(stones[i])
  end
  platforms = {}
  stones = {}

  display.remove(character)
  display.remove(ground)
  display.remove(endMessage)
  display.remove(livesText)

  character = {}
  ground = {}

  Runtime:removeEventListener("enterFrame",gameLoop)

  audio.dispose(explosionSound)
	audio.dispose(shootSound)
  audio.dispose(laughSound)
  audio.dispose(applauseSound)
  explosionSound  =nil
  shootSound = nil
  laughSound = nil
  applauseSound = nil
  explosionChannel = nil
  shootChannel = nil
  laughChannel = nil
  applauseChannel =nil

  storyboard.purgeScene()

end

function scene:destroyScene( event )

end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene