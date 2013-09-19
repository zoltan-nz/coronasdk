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

-- couple of sound effects
local explosionSound = audio.loadSound("sounds/explosion.mp3")
local explosionChannel

local deathSound = audio.loadSound("sounds/death.mp3")
local deathChannel

local ground
local platforms = {}
local platformGroup

-- Platforms position generated randomly.
-- It is called always when use relaunch this game
local randomPlatformGenerator = function()
  for i=1,3 do
    platforms[i] = display.newRect(platformGroup, 0, 0, 100, 20)
    platforms[i]:setReferencePoint(display.TopLeftReferencePoint)
    local x = math.random(0,220)
    local y = math.random(0,300)
    platforms[i].x = x
    platforms[i].y = y
    platforms[i].name = 'platform'
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

  -- Create character
  


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
  end
  platforms = {}

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