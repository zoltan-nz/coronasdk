module(..., package.seeall)

local localGroup

--main function - must return a display.newgroup()
function new()
	localGroup = display.newGroup()
	
	--Now lets turn on physics.

	local physics = require("physics")
	physics.setScale(50)
	physics.start()

	--First lets draw our background and our buttons
local background = display.newImage("sky.jpg")
	localGroup:insert(background)
	
local shootButton = display.newImage("tapToShoot.png")
	shootButton.isVisible = false
	shootButton.x = _W/2
	shootButton.y = 100
	localGroup:insert(shootButton)
	
local gameOverButton = display.newImage("gameOver.png")
	gameOverButton.isVisible = false
	gameOverButton.x = _W/2
	gameOverButton.y =  100
	localGroup:insert(gameOverButton)
		
--We need to make a game group that will hold all the objects that are in the game.
local gameGroup = display.newGroup()
	gameGroup.xScale = 0.6
	gameGroup.yScale = 0.6
	gameGroup.y = 650
	localGroup:insert(gameGroup)
--Our Grass will be part of the game so it goes in our game group.
local floor = display.newRect( -512,80, 8000, 2 )
	physics.addBody(floor, "static", {density = 1.0, friction = 0.9, bounce = 0.2, isSensor = false})
	gameGroup:insert(floor)

local grass = display.newImage("ground.png")
	grass.y = -50
	gameGroup:insert(grass)

--Now our Lives icons. For this we need a lives group.
local livesGroup = display.newGroup()

	for i = 1, 3 do
		life = display.newImage('life.png')
		life.x = (_W - life.width) - (5 * i+1) - life.width * i + 20
		life.y = _H - life.height
		livesGroup.insert(livesGroup, life)
	end
localGroup:insert(livesGroup)

--Addd Score
local score = 0
local scoreText = display.newText('Score: ', 1, 0, native.systemFontBold, 50)
	scoreText:setTextColor(255, 255, 255)
	scoreText.y = _H - 50
	scoreText.text = scoreText.text .. tonumber(score)
	scoreText:setReferencePoint(display.BottomLeftReferencePoint)
	scoreText.x = 1
	localGroup:insert(scoreText)

	
--Make Catapult
local catapult = display.newImage("catapult.png")
local catapultFront = display.newImage("catapultfront.png")
catapult.x = 800
catapult.y = -200
catapultFront.x = catapult.x
catapultFront.y = catapult.y

local firePos = {}
firePos.x = catapult.x - (catapult.width/3)
firePos.y = catapult.y - (catapult.height/2.5)
gameGroup:insert(catapult)
gameGroup:insert(catapultFront)

local character = display.newImage( "character.png" )
physics.addBody(character, "dynamic", {density = 2.0, friction = 0.3, bounce = 0.5, radius =50})
character.isBullet = true
swipe = false
gameGroup:insert(character)

function resetCharacter() 
	character.bodyType = "static"
	character.x = catapult.x - 50
	character.y = catapult.y - 100
	character.rotation = 30
	character.hit = false
	swipe = false
	shootButton.isVisible = false
	gameOverButton.isVisible = false
	timer.performWithDelay(1000, function () swipe = true end)
end

resetCharacter()

gameGroup.x = ( -character.x - 700)


-----Functions for Scores
function hitMonster(event)
	if event.force > 23 then
		--print(event.force)
		print("Score: 30")
		score = score + 30
		scoreText.text = "Score " .. tonumber(score)
		scoreText:setReferencePoint(display.BottomLeftReferencePoint)
		scoreText.x = 1
		
		event.target:removeSelf()
	end
end

function hitPlatform(event)

	if event.force > 40 then
		score = score + 10
		scoreText:setReferencePoint(display.BottomLeftReferencePoint)
		scoreText.x = 1
		scoreText.text = "Score: " .. tonumber(score)
		print("Score: 10")
	end
end

function tapToShoot()
	display.remove(livesGroup[livesGroup.numChildren])
	
	if livesGroup.numChildren > 0 then
		shootButton.isVisible = true
	else
		gameOverButton.isVisible = true
	end
			
end

--------- PLATFORMS

function makePlatform(x,y)

	local top = display.newImage("blockSuperLong.png")
	top.x = x
	top.y = y
	
	local left = display.newImage("blockLong1.png")
	left.x = x  + 100
	left.y = y + top.height
	
	local right = display.newImage("blockLong1.png")
	right.x = x-100
	right.y = y+top.height 
	
	local monster = display.newImage("monster.png")
	monster.x = x
	monster.y = y + 60
		
	physics.addBody(monster, "dynamic", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	physics.addBody(left, "dynamic", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	physics.addBody(right, "dynamic", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	physics.addBody(top, "dynamic", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	gameGroup:insert(left)
	gameGroup:insert(right)
	gameGroup:insert(top)
	gameGroup:insert(monster)
	monster:addEventListener("postCollision", hitMonster)
	top:addEventListener("postCollision", hitPlatform)
end

for i=1,3 do
	for j = 4, i+1, -1 do
		makePlatform(2500+(280*(j - (i/2))),-i*115)
	end
end

--Move Screen Function
function followScreen(event) 

	if swipe == true then
		local targetx = ( -character.x + 1200) --* game.xScale
		if targetx>0 then
			targetx = 0 
		elseif targetx<-1200 then
			targetx = -1200
		end
		gameGroup.x = gameGroup.x + (targetx-gameGroup.x)*0.08
	end
end


function updateCatapult(dx, dy)
	
	character.x = firePos.x + (dx*0.5)
	character.y = firePos.y + (dy*0.5)
	
	-- figure out how far we've stretched him - bit of pythagorean theorum here!
	local distance = math.sqrt((dx*dx) + (dy*dy))
	character.rotation = distance * 0.1
	character.hit = true
end

--Function for touch character
function touchCharacter(event)

	if event.phase=="began" then 
		
		dragging = true
		character.bodyType ="static"
		display.getCurrentStage():setFocus( character )
		
	elseif dragging then 
		local diffx = ((event.x- gameGroup.x)/gameGroup.xScale)  - firePos.x
		local diffy = ((event.y- gameGroup.y)/gameGroup.yScale)  - firePos.y
		if event.phase == "moved" then 
			updateCatapult(diffx, diffy)
		elseif event.phase == "ended" then 
			character.bodyType = "dynamic"
			character:applyLinearImpulse(-diffx *0.5,-diffy*0.5,character.x, character.y)
			dragging = false
			display.getCurrentStage():setFocus( nil )
			timer.performWithDelay(5000, tapToShoot)
		end
	end
	
end

function gameOver(event)
	if event.phase=="ended" then
		Runtime:removeEventListener("enterFrame", followScreen)
		director:changeScene("levelselect")
	end
	
end

shootButton:addEventListener("touch", resetCharacter)
gameOverButton:addEventListener("touch", gameOver)
character:addEventListener("touch", touchCharacter)
Runtime:addEventListener("enterFrame", followScreen)

return localGroup
end