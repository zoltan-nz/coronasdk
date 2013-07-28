-------------------------------------------------------------------------
--T and G Apps Ltd.
--Created by Jamie Trinder
--www.tandgapps.co.uk

--CoronaSDK version 2012.971 was used for this template.

--The art was sourced from http://biffybeebe.net/graphics/
--Created by Biffy Beebe, you would have to purchase the indie Graphics bundle
--yourself in order to use the graphics in this template in your own game.

--You are not allowed to publish this template to the Appstore as it is.
--You need to work on it, improve it and replace the graphics.

--For questions and/or bugs found, please contact me using our contact
--form on http://www.tandgapps.co.uk/contact-us/
-------------------------------------------------------------------------

local debugMode = false -- Change true and player will be a ghost! Handy for level planning and testing

--Start off by requiring storyboard and creating a scene.
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()


--Require physics
local physics = require("physics")
--physics.setDrawMode( "hybrid" )
physics.start(); physics.setGravity( 0, 20 ) --Start physics
--physics.setDrawMode( "hybrid" )

--We also require the section definitions.
--These controls positions etc of the Stars and platforms.
local level = require("levels.level"..currentLevel)

--Maths
local _W = display.contentWidth
local _H = display.contentHeight
local mR = math.random
local mF = math.floor

--Groups
local firstGroup, objectGroup, enemyGroup, extraGroup

--Sounds
local coinSound, overSound, winSound, jumpSound
local coinChannel, jumpChannel, overChannel, winChannel, bullettChannel, explosionChannel = 2,3,4,5,6,7 --Channel vars, used to play sounds, these values change when they are used.

--Game Control Variables
local moveSide = "right" --Changes when we touch the buttons.
local moving = false --Keeps track of us moving or not.
local floorHit = false --Controls animation
local singleJump, doubleJump = false, false
local gameOverCalled = false --Just incase an extra game over call is made.
local distChange, distChange2 = 0, 0 --Keeps track of how far we've gone in regards to the contentBounds.
local gameIsActive = true  --Set to true to start scrolling etc.
local score = 0  --Points for killing enemies etc.
local sectionInt = 1 --Controls the sections being made
levelScore = 0 --Reset the levelScore just incase it is still set.



--BG and display variables.
local bg1, bg2, ground1, ground2, extra1, extra2
local scoreText --Displays our score

--Functions Pre-declared
--This is done so runtime listeners can be easily removed/added
local onCollision, gameLoop

--Player only vars.
local player
local levelspeed = 0 --Will increase when we start running.
local runSpeed = 8 --How fast the background will move when your running top speed.
local movementAllowed = true
local ammoInt = 5 -- How many ammunition has the player.
local atALadder = false -- True if player at the ladder

--Timers and transitions
local moveTimer





--------------------------------------------
-- ***SPRITESHEET SETUP***
-- Animations for the player/enemies
--------------------------------------------
--Player
local options =
{
    width = 45, height = 62,
    numFrames = 5,
    sheetContentWidth = 225,
    sheetContentHeight = 62
}
local playerSheet = graphics.newImageSheet( "images/playerSprite.png", options)
local playerSprite = {
    {name="run", start=1, count=3, time = 400, loopCount = 0 },
    {name="jump", start=4, count=1, time = 1000, loopCount = 1 },
    {name="stand", start=5, count=1, time = 1000, loopCount = 1 },
    {name="shoot", start=4, count=1, time = 500, loopCount = 1}
}

--Enemy
local options2 =
{
    width = 48, height = 45,
    numFrames = 2,
    sheetContentWidth = 96,
    sheetContentHeight = 45
}
local enemySheet = graphics.newImageSheet( "images/enemySprite.png", options2)
local enemySprite = { name="run", start=1, count=2, time = 300, loopCount = 0 }






------------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------
-- Called when the scene's view does not exist:
-- Create all your intial display objects here.
function scene:createScene( event )
    print( "Game: createScene event")
    local screenGroup = self.view


    --Create the groups..
    firstGroup = display.newGroup()
    objectGroup = display.newGroup()
    enemyGroup = display.newGroup()
    extraGroup = display.newGroup()
    screenGroup:insert(firstGroup); screenGroup:insert(objectGroup)
    screenGroup:insert(enemyGroup); screenGroup:insert(extraGroup)

    --Load the sounds.
    coinSound = audio.loadSound("sounds/Collect.mp3")
    overSound = audio.loadSound("sounds/Defeat2.mp3")
    winSound = audio.loadSound("sounds/LevelClear.mp3")
    jumpSound = audio.loadSound("sounds/Jump.mp3")
    bullettSound = audio.loadSound("sounds/shoot.mp3")
    explosionSound = audio.loadSound("sounds/explosion.mp3")
    ammoSound = audio.loadSound("sounds/ammo.mp3")


    --------------------------------------------
    -- ***HUD SETUP***
    -- Creates the HUD Bar, Score Text
    --------------------------------------------
    local hudBar = display.newImageRect(extraGroup, "images/clearheader.png", 480,36)
    hudBar.x = _W*0.5; hudBar.y = 14; hudBar.alpha = 0.5

    scoreText = display.newText(extraGroup, "Score: "..score,0,0,"Arial",15)
    scoreText:setReferencePoint(display.CenterLeftReferencePoint); scoreText:setTextColor(50)
    scoreText.x = 3; scoreText.y = 14

    ammoText = display.newText(extraGroup, "Ammo: "..ammoInt, 0,0, "Arial", 15)
    ammoText:setReferencePoint(display.CenterLeftReferencePoint); ammoText:setTextColor(50)
    ammoText.x = 90; ammoText.y = 14

    levelText = display.newText(extraGroup, "Level: "..currentLevel, 0,0, "Arial", 15)
    levelText:setReferencePoint(display.CenterLeftReferencePoint); levelText:setTextColor(50)
    levelText.x = 170; levelText.y = 14

    sectionText = display.newText(extraGroup, "Screen: "..sectionInt, 0,0, "Arial", 15)
    sectionText:setReferencePoint(display.CenterLeftReferencePoint); sectionText:setTextColor(50)
    sectionText.x = 230; sectionText.y = 14

    livesText = display.newText(extraGroup, "Lives: "..lives, 0,0, "Arial", 15)
    livesText:setReferencePoint(display.CenterLeftReferencePoint); livesText:setTextColor(50)
    livesText.x = 330; livesText.y = 14

    startTime = os.time()
    timeText = display.newText(extraGroup, "Time: 0", 0, 0, "Arial", 15)
    timeText:setReferencePoint(display.CenterLeftReferencePoint); timeText:setTextColor(50)
    timeText.x = 400; timeText.y = 14

    local function checkTime(event)
        local now = os.time()
        fulltime = now - startTime
        min = math.floor(fulltime/60)
        sec = fulltime % 60
        if sec < 10 then sec = "0"..sec end
        timeText.text = "Time:  "..min..":"..sec
    end

    Runtime:addEventListener("enterFrame", checkTime)


    --------------------------------------------
    -- ***CREATE GAME FUNCTION.***
    --Create the scenery and the player/jumpfunction
    --------------------------------------------
    --Jumping function with some control vars.
    local function playerJump( event )
        local t = event.target

        --Only allow this to occur if we haven't died etc.
        if movementAllowed then
            if event.phase == "began" then
                display.getCurrentStage():setFocus( t, event.id )
                t.isFocus = true; t.alpha = 0.6

            elseif t.isFocus then
                if event.phase == "ended" or event.phase == "cancelled" then
                    display.getCurrentStage():setFocus( t, nil )
                    t.isFocus = false; t.alpha = 1

                    floorHit = false
                    if doubleJump == false then
                        player:setLinearVelocity( 0, 0 )
                        player:applyForce(0,-8, player.x, player.y)
                        player:setSequence("jump")
                        jumpChannel = audio.play(jumpSound)
                    end

                    if singleJump == false then singleJump = true
                    else doubleJump = true end
                end
            end

            --If we aren't allowed to move we need to stop the focus.
            --If you dont there is a risk of a crash as the scene changes (if your still pressing the button)
        else
            display.getCurrentStage():setFocus( t, nil )
        end
        return true
    end

    --Create Section function.. Create platforms and enemies etc
    --Using the required level file at the top to create each screen in turn.
    local function createSection()
        local xOffset = 480

        --Get the section we want to create now.
        --Loop through creating everything with the right properties.
        local i
        for i=1, #level[sectionInt]["blocks"] do
            local object = level[sectionInt]["blocks"][i]
            local block = display.newImageRect(objectGroup, object["filename"], object["widthHeight"][1], object["widthHeight"][2])
            block:setReferencePoint(display.BottomCenterReferencePoint);
            block.x = object["position"][1]+xOffset; block.y = object["position"][2];

            --Change the block properties depending on the type of block
            block.name = "block"; block.type = object["type"]; block.spawned = false
            if block.type == "pushable" then
                physics.addBody( block, "dynamic", { density=0.004, friction=1, bounce=0} );
                block.isFixedRotation = true
            else
                physics.addBody( block, "static", { friction=1, bounce=0} );
            end
        end
        for i=1, #level[sectionInt]["ladders"] do
            local object = level[sectionInt]["ladders"][i]
            local ladder = display.newImageRect(objectGroup, "images/ladder.png", 40, 160)
            ladder:setReferencePoint(display.BottomCenterReferencePoint);
            ladder.x = object["position"][1]+xOffset; ladder.y = object["position"][2];

            --            ladderCollisionFilter = {categoryBits = 2, maksBits = 1}

            --            physics.addBody(ladder, "static", {density=0.004, friction=0.3, bounce=0, filter=ladderCollisionFilter} )
            physics.addBody(ladder, "static", {density=0.004, friction=0.3, bounce=0, isSensor = true} )
            ladder.name = "ladder"

        end
        for i=1, #level[sectionInt]["coins"] do
            local object = level[sectionInt]["coins"][i]
            local coin = display.newImageRect(objectGroup, "images/coin.png", 30, 30)
            coin:setReferencePoint(display.BottomCenterReferencePoint);
            coin.x = object["position"][1]+xOffset; coin.y = object["position"][2]; coin.name = "coin"
            physics.addBody( coin, "static", { isSensor = true } )
        end

        for i=1, #level[sectionInt]["ammos"] do
            local object = level[sectionInt]["ammos"][i]
            local ammo = display.newImageRect(objectGroup, "images/ammo.png", 27, 42)
            ammo:setReferencePoint(display.BottomCenterReferencePoint);
            ammo.x = object["position"][1]+xOffset; ammo.y = object["position"][2]; ammo.name = "ammo"
            physics.addBody( ammo, "static", { isSensor = true } )
        end

        for i=1, #level[sectionInt]["spikes"] do
            local object = level[sectionInt]["spikes"][i]
            local spike = display.newImageRect(objectGroup, "images/spikes.png", object["widthHeight"][1], object["widthHeight"][2])
            spike:setReferencePoint(display.BottomCenterReferencePoint);
            spike.x = object["position"][1]+xOffset;
            spike.y = object["position"][2]; spike.name = "spike"
            physics.addBody( spike, "static", { isSensor = true } )
        end
        for i=1, #level[sectionInt]["enemies"] do
            local object = level[sectionInt]["enemies"][i]
            local enemy = display.newSprite(enemySheet, enemySprite)
            enemy:setReferencePoint(display.BottomCenterReferencePoint);
            enemy.x = object["position"][1]+xOffset; enemy.y = object["position"][2];
            enemy.name = "enemy"; enemy.allowedMovement = object["allowedMovement"]
            enemy.speed = object["speed"]; enemy.travelled = 0;
            physics.addBody( enemy, "static", { isSensor = true } )
            enemy:setSequence("stand"); enemy:play()
            enemyGroup:insert(enemy)
        end
        for i=1, #level[sectionInt]["flags"] do
            local object = level[sectionInt]["flags"][i]
            local flag = display.newImageRect(objectGroup, "images/flag.png", object["widthHeight"][1], object["widthHeight"][2])
            flag:setReferencePoint(display.BottomCenterReferencePoint);
            flag.x = object["position"][1]+xOffset;
            flag.y = object["position"][2]; flag.name = "flag"
            physics.addBody( flag, "static", { isSensor = true } )
        end
    end

    --CreateGame makes all the backgrounds etc.
    --This is also called when we reset the game.
    local function createGame()
        --Background and floor and extras
        bg1 = display.newImageRect(firstGroup, "images/bg1.jpg", 480, 320)
        bg1:setReferencePoint(display.TopLeftReferencePoint); bg1.x = 0; bg1.y = 0
        bg2 = display.newImageRect(firstGroup, "images/bg2.jpg", 480, 320)
        bg2:setReferencePoint(display.TopLeftReferencePoint); bg2.x = 480; bg2.y = 0

        extra1 = display.newImageRect(firstGroup, "images/extra.png", 480, 90)
        extra1:setReferencePoint(display.BottomLeftReferencePoint); extra1.x = 0; extra1.y = _H-40
        extra2 = display.newImageRect(firstGroup, "images/extra2.png", 480, 90)
        extra2:setReferencePoint(display.BottomLeftReferencePoint); extra2.x = 480; extra2.y = _H-40

        ground1 = display.newImageRect(extraGroup, "images/floor.png", 480, 48)
        ground1:setReferencePoint(display.TopLeftReferencePoint); ground1.x = 0; ground1.y = _H-48; ground1.name = "floor"

        groundCollisionFilter = {categoryBits = 4, maskBits = 3}

        physics.addBody( ground1,  "static", { friction=0.1, bounce=0, filter = groundCollisionFilter} )
        ground2 = display.newImageRect(extraGroup, "images/floor.png", 480, 48)
        ground2:setReferencePoint(display.TopLeftReferencePoint); ground2.x = 480; ground2.y = _H-48; ground2.name = "floor"
        physics.addBody( ground2,  "static", { friction=0.1, bounce=0, filter = groundCollisionFilter} )


        --Now create the player sprite!
        player = display.newSprite(playerSheet, playerSprite)
        player:setReferencePoint(display.BottomCenterReferencePoint)
        player.x = 140; player.y = _H*0.7; player.name = "player";
        player:setSequence("stand"); player:play()
        extraGroup:insert(player);

        local playerShape = { -16,-28, 16,-28, 16,31, -16,31 }


        -- If debugMode true player can walk through everything.
        if debugMode then       playerCollisionFilter ={categoryBits = 1, maskBits = 4} end
        physics.addBody( player,  "dynamic", { friction=1, bounce=0, shape=playerShape, filter=playerCollisionFilter} )

        physics.addBody( player,  "dynamic", { friction=1, bounce=0, shape=playerShape} )
        player.isFixedRotation = true 	--To stop it rotating when jumping etc
        player.isSleepingAllowed = false --To force it to update and fall off playforms correctly.
        --Create a section straight away..
        createSection()
    end
    createGame()



    --------------------------------------------
    -- *** D-PAD Setup ***
    -- Allows you to move and jump, also scrolls the background along.
    --------------------------------------------
    --Move everything function. Moves the level etc.
    local function moveEverything()
        --Check sides and change the level speed accordingly.
        if moveSide == "left" then
            levelspeed = levelspeed +1
            if levelspeed > runSpeed then levelspeed = runSpeed end
        elseif moveSide == "right" then
            levelspeed = levelspeed -1
            if levelspeed < -runSpeed then levelspeed = -runSpeed end
        end


        --Move backgrounds, called from the checks below this function.
        local function moveBackgrounds()
            --Move the other items and platforms.
            --If they are far left of the screen we remove them.
            local i
            for i = objectGroup.numChildren,1,-1 do
                local object = objectGroup[i]
                if object ~= nil and object.y ~= nil then
                    object:translate( levelspeed, 0)
                    if object.x < -480 then
                        display.remove(object); object = nil;
                    end
                end
            end
            --Now move the enemies
            for i = enemyGroup.numChildren,1,-1 do
                local enemy = enemyGroup[i]
                if enemy ~= nil and enemy.y ~= nil then
                    enemy:translate( levelspeed, 0)
                    if enemy.x < -480 then
                        display.remove(enemy); enemy = nil;
                    end
                end
            end

            --Move the backgrounds...
            --We then check to see if they need to be replaced.
            bg1:translate(levelspeed*0.6,0)
            bg2:translate(levelspeed*0.6,0)
            ground1:translate(levelspeed,0)
            ground2:translate(levelspeed,0)
            extra1:translate(levelspeed,0)
            extra2:translate(levelspeed,0)
            distChange = distChange - levelspeed --Holds the distance moved.
            distChange2 = distChange2 - levelspeed

            if ground1.x <= -480 then ground1.x = ground1.x + 960; extra1.x = extra1.x + 960
            elseif ground1.x >= 480 then ground1.x = ground1.x - 960; extra1.x = extra1.x - 960 end
            if ground2.x <= -480 then ground2.x = ground2.x + 960; extra2.x = extra2.x + 960
            elseif ground2.x >= 480 then ground2.x = ground2.x - 960; extra2.x = extra2.x - 960 end
            if bg1.x <= -480 then bg1.x = bg1.x + 960
            elseif bg1.x >= 480 then bg1.x = bg1.x - 960 end
            if bg2.x <= -480 then bg2.x = bg2.x + 960
            elseif bg2.x >= 480 then bg2.x = bg2.x - 960 end

            --If distChange2 is over 480 then create a new section.
            --We dont create them in the opposite direction.
            if distChange2 > 480 then
                sectionInt = sectionInt + 1
                sectionText.text = "Screen: "..sectionInt
                if sectionInt <= #level then createSection() end
                distChange2 = 0
            end
        end


        --Now move everything, but only if its within the level bounds!!
        --If it isn't we only move the player up to the boundary. We also stop the screen
        --from going left. Forcing the player to advance through the game.
        if moveSide == "right" then
            if player.x < _W*0.5 then
                player:translate(-levelspeed,0)
            elseif distChange >= level.screenBounds[2] then
                if player.x >= _W then player.x = _W
                elseif player.x <= (_W*0.5)-1 then  player.x = _W*0.5; moveBackgrounds()
                else player:translate(-levelspeed,0) end
            else
                moveBackgrounds()
            end
        end


        if moveSide == "left" then
            if player.x <= 0 then player.x = 0
            elseif player.x >= _W then player.x = _W-1
            else player:translate(-levelspeed,0) end
        end

        if moveSide == "up" and atALadder == true then
            --            player.BodyType = 'kinematic'

            player.y = player.y - 5
            player:setSequence("run"); player:play()
            player.xScale = 1
            player.onLadder = true
        end

        if moveSide == "down" and atALadder == true then
            --            player.BodyType = 'kinematic'

            player.y = player.y + 5
            player:setSequence("run"); player:play()
            player.xScale = 1
            player.onLadder = true
        end

    end

    --Button function. Called from the left and right buttons
    local function moveButton(event)
        local t = event.target

        --Only allow this to occur if we haven't died etc.
        if movementAllowed then
            if event.phase == "began" and moving == false then
                print('moveButton, phase: began, moving: false')
                display.getCurrentStage():setFocus( t, event.id )
                t.isFocus = true; t.alpha = 0.6
                moving = true

                moveSide = t.dir --Set the side variable.
                moveTimer = timer.performWithDelay(1, moveEverything, 0) --Timer for forcing movement

                --Change the sprite animation depending on the direction.
                if t.dir == "left" or t.dir == "right" then
                    player:setSequence("run"); player:play()
                end
                if t.dir == "right" then player.xScale = 1 end
                if t.dir == "left" then player.xScale = -1 end

            elseif t.isFocus and moving == true then
                if event.phase == "ended" or event.phase == "cancelled" then
                    print('moveButton, phase: ended, moving: true')
                    --                    physics.setGravity( 0, 20 )
                    display.getCurrentStage():setFocus( t, nil )
                    t.isFocus = false; t.alpha = 1
                    moving = false

                    --Cancel the timer/reset vars
                    if moveTimer then timer.cancel(moveTimer); moveTimer=nil; end
                    player:setSequence("stand"); player:play() --Reset the sprite to standing as well.
                    levelspeed = 0
                end
            end

            --If we aren't allowed to move we need to stop the focus.
            --If you dont there is a risk of a crash as the scene changes (if your still pressing the button)
        else
            display.getCurrentStage():setFocus( t, nil )
        end
        return true
    end

    local function playerShoot( event )
        local t = event.target

        local function bullettDisappear(event)
            print("Bullett Disappear")
            display.remove(event)
            event.target = nil
        end


        if movementAllowed and ammoInt > 0 then
            if event.phase == "began" then
                ammoInt = ammoInt - 1
                ammoText.text = "Ammo: "..ammoInt
                if player.xScale == -1 then

                    player:setSequence("shoot")
                    startx = player.x - (player.contentWidth / 2)
                    starty = player.y - (player.contentHeight / 2)
                    bullett = display.newImage("images/bullet.png", startx, starty)
                    bullett.rotation = 180
                    bullett.isBullet = true
                    bullett.name = "bullett"
                    physics.addBody( bullett,  "dynamic", { friction=1, bounce=0, shape=playerShape} )
                    bullettChannel = audio.play(bullettSound)

                    bullett.trans = transition.to (bullett, {x=0, y=starty, time=1000, onComplete=bullettDisappear})
                else
                    player:setSequence("shoot")
                    startx = player.x + (player.contentWidth / 2)
                    starty = player.y - (player.contentHeight / 2)
                    bullett = display.newImage("images/bullet.png", startx, starty )
                    bullett.isBullet = true
                    bullett.name = "bullett"
                    physics.addBody( bullett,  "dynamic", { friction=1, bounce=0, shape=playerShape} )
                    bullettChannel = audio.play(bullettSound)
                    bullett.trans = transition.to (bullett, {x=_W, y=starty, time=1000, onComplete=bullettDisappear})
                end

            end

        else
            display.getCurrentStage():setFocus(t, nil)
        end
        return true

    end


    --Create the movement buttons.
    local jumpButton = display.newImageRect(extraGroup, "images/button.png", 45, 45)
    jumpButton.x = _W-38; jumpButton.y = _H-25;
    jumpButton:addEventListener("touch", playerJump)

    local leftButton = display.newImageRect(extraGroup, "images/buttonLeft.png", 45, 45)
    leftButton.x = 38; leftButton.y = _H-34; leftButton.dir = "left"
    leftButton:addEventListener("touch", moveButton)

    local rightButton = display.newImageRect(extraGroup, "images/buttonRight.png", 45, 45)
    rightButton.x = leftButton.x+84; rightButton.y = _H-34; rightButton.dir = "right"
    rightButton:addEventListener("touch", moveButton)

    --Create up and down button
    local upButton = display.newImageRect(extraGroup, "images/buttonLeft.png", 45, 45)
    upButton.rotation = 90
    upButton.x = 80; upButton.y = _H-70; upButton.dir = "up"
    upButton:addEventListener("touch", moveButton)

    local downButton = display.newImageRect(extraGroup, "images/buttonRight.png", 45, 45)
    downButton.rotation = 90
    downButton.x = 80; downButton.y = _H-25; downButton.dir = "down"
    downButton:addEventListener("touch", moveButton)

    --Create an action button, with this player can shoot
    local actionButton = display.newImageRect(extraGroup, "images/shoot_button.png", 45, 45)
    actionButton.x = _W-90; actionButton.y = _H-25;
    actionButton:addEventListener("touch", playerShoot)

    -- if debugMode true coordinates of player will appear in the coorner.
    if debugMode then

        xText = display.newText(extraGroup, "Player.x: "..player.x,0,0,"Arial",15)
        yText = display.newText(extraGroup, "Player.y: "..player.y,0,0,"Arial",15)
        xText:setReferencePoint(display.CenterLeftReferencePoint);
        xText:setTextColor(50)
        yText:setReferencePoint(display.CenterLeftReferencePoint);
        yText:setTextColor(50)
        xText.x = 15; xText.y = 40
        yText.x = 100; yText.y = 70

        function updateCoordinates(event)
            xText.text = "Player.x: "..player.x
            yText.text = "Player.y: "..player.y
        end

        Runtime:addEventListener("enterFrame", updateCoordinates)
    end

end



-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enterScene( event )
    print( "Game: enterScene event" )


    -- Completely remove the previous scene/all scenes.
    -- Handy in this case where we want to keep everything simple.
    storyboard.removeAll()


    --------------------------------------------
    -- ***GAMELOOP Runtime Listener***
    --Controls the movement of the enemies.
    --------------------------------------------
    function gameLoop()
        if gameIsActive == true then
            local i
            for i = enemyGroup.numChildren,1,-1 do
                local enemy = enemyGroup[i]
                if enemy ~= nil and enemy.y ~= nil then
                    enemy:translate( enemy.speed, 0)

                    --Check to see if the enemy needs to change its direciton.
                    enemy.travelled = enemy.travelled + enemy.speed

                    if enemy.travelled >= enemy.allowedMovement or enemy.travelled <= -enemy.allowedMovement then
                        enemy.speed = -enemy.speed
                        enemy.xScale = -enemy.xScale
                        enemy.travelled = 0
                    end
                end
            end
        end
    end
    Runtime:addEventListener("enterFrame",gameLoop)






    --------------------------------------------
    -- ***COLLISION FUNCTIONS AND START/STOP***
    --What happens when we get hit essentially
    --------------------------------------------
    --Game over and we died...
    local function gameOver()
        --Play the sound..
        overChannel = audio.play(overSound)

        --Stop the gameloop/collision
        gameIsActive = false
        gameOverCalled = true
        movementAllowed = false --Stops the movement buttons from working.
        if moveTimer then timer.cancel(moveTimer); moveTimer = nil; end

        --Rotate and make it look like a death animation..
        --After the delay/slow down we show the gameOver screen.
        local function nowEnd()
            --Delay the level change
            if lives > 0 then
                lives = lives - 1
                --                timer.performWithDelay(1400, function() storyboard.gotoScene( "game", "slideLeft", 400 )  end, 1)
                timer.performWithDelay(1400, function() storyboard.gotoScene( "gameOver", "slideLeft", 400 )  end, 1)
            else
                timer.performWithDelay(1400, function() storyboard.gotoScene( "gameOverTotaly", "slideLeft", 400 )  end, 1)
            end
        end

        --Stop the player and create a weird death animation.
        player:pause()
        player:setLinearVelocity( 0, 0 )
        player:applyForce(0,-4, player.x, player.y)
        local trans = transition.to(player, {time=1000, rotation=90, onComplete=nowEnd})
    end

    --Game won as we got to the tree!!
    local function gameWon()
        --Play the sound..
        winChannel = audio.play(winSound)

        --Stop the gameloop/collision
        gameIsActive = false
        gameOverCalled = true
        movementAllowed = false --Stops the movement buttons from working.
        if moveTimer then timer.cancel(moveTimer); moveTimer = nil; end

        --Change the players animation
        player:setSequence("stand"); player:play()

        --Set the global score variable to what we just got...
        levelScore = score

        --Delay the level change
        timer.performWithDelay(1800, function() storyboard.gotoScene( "gameWon", "slideLeft", 400 )  end, 1)
    end

    --Change Score function.. Handy function for collision.
    local function changeText(amount)
        if amount ~= nil then
            score = score + amount
            scoreText.text = "Score: "..score
            scoreText:setReferencePoint(display.CenterLeftReferencePoint)
            scoreText.x = 6
        end
    end

    --Quick coin creation function. Used in the below collision function
    --when the player hits a special box.
    local function createCoin(x,y)
        --Creation needs to be delayed slightly so the world isn't "Number crunching"
        local function createNow()
            local coin = display.newImageRect(objectGroup, "images/coin.png", 30, 30)
            coin:setReferencePoint(display.BottomCenterReferencePoint);
            coin.x = x; coin.y = y-60; coin.name = "coin"
            physics.addBody( coin, "static", { isSensor = true } )
        end
        timer.performWithDelay(10, createNow, 1)
    end

    --Collision function. Controls hitting the blocks and coins etc. Also resets the jumping
    function onCollision(event)

        if event.phase == "ended" then
            local name1 = event.object1.name
            local name2 = event.object2.name

            if name1 == "ladder" or name2 == "ladder" then
                if name1 == "player" or name2 == "player" then
                    atALadder = false
                    player.gravityScale = 1
                    print("atALadder = false")
                end
            end
        end

        if event.phase == "began" and gameIsActive == true and gameOverCalled == false then
            local name1 = event.object1.name
            local name2 = event.object2.name

            if name1 == "ladder" or name2 == "ladder" then
                if name1 == "player" or name2 == "player" then
                    player.gravityScale = 0
                    player:setLinearVelocity( 0, 0 )
                    atALadder = true
                    print("atALadder = true")
                end
            end

            if name1 == "bullett" or name2 == "bullett" then
                print("bullett collision happend")
                if name1 == "enemy" or name2 == "enemy" then
                    display.remove(event.object2); event.object2 = nil
                    display.remove(event.object1); event.object1 = nil
                    explosionChannel = audio.play(explosionSound)
                    changeText(30)
                end
            end

            if name1 == "player" or name2 == "player" then
                --Hit the floor we reset the jump. Hit a block we run some checks to see
                --what we should actually be doing.
                if name1 == "floor" or name2 == "floor" or name1 == "block" or name2 == "block" then
                    --Resets your jump. Only do this if its the floor or top of a block.
                    local function resetJump()
                        singleJump, doubleJump = false, false
                        if floorHit == false then
                            floorHit = true

                            if moving == true then player:setSequence("run")
                            else player:setSequence("stand") end
                            player:play()
                        end
                    end

                    --Run some checks to see what we should be doing once we collide with a block.
                    --We do different things depending on the block and where we hit it from.
                    if name1 == "block" or name2 == "block" then
                        --We check to see if it was hit from the bottom. If it was we do different things to it.
                        if name1 == "player" then
                            --We check to see if it was above or below.
                            if player.y < event.object2.y-(event.object2.height*0.5) then
                                resetJump()

                                --If we it was below the box, we also check to make sure the collision was central.
                            elseif player.y >= event.object2.y+(event.object2.height*0.5)+1 then
                                if player.x > event.object2.x-(event.object2.width*0.5) and player.x < event.object2.x+(event.object2.width*0.5) then
                                    if event.object2.type == "breakable" then --If its breakable we remove it. You could also play an animation here.
                                        display.remove(event.object2); event.object2 = nil;
                                    elseif event.object2.type == "special" then --If its special we spawn a coin on top!!
                                        if event.object2.spawned == false then
                                            event.object2.spawned = true
                                            createCoin( event.object2.x, event.object2.y)
                                        end
                                    end
                                    changeText(10)
                                end
                            end
                        else
                            --We check to see if it was above or below.
                            if player.y < event.object1.y-(event.object1.height*0.5) then
                                resetJump()

                                --If we it was below the box, we also check to make sure the collision was central.
                            elseif player.y >= event.object1.y+(event.object1.height*0.5)+1 then
                                if player.x > event.object1.x-(event.object1.width*0.5) and player.x < event.object1.x+(event.object1.width*0.5) then
                                    if event.object1.type == "breakable" then --If its breakable we remove it. You could also play an animation here.
                                        display.remove(event.object1); event.object1 = nil;
                                    elseif event.object1.type == "special" then --If its special we spawn a coin on top!!
                                        if event.object1.spawned == false then
                                            event.object1.spawned = true
                                            createCoin( event.object1.x, event.object1.y)
                                        end
                                    end
                                    changeText(10)
                                end
                            end
                        end
                        --It was the floor so reset the jump now..
                    else
                        --Else if its the floor just reset.
                        resetJump()
                    end






                    --Picking up coins...
                elseif name1 == "coin" or name2 == "coin" then
                    if name1 == "coin" then display.remove(event.object1); event.object1 = nil;
                    else display.remove(event.object2); event.object2 = nil; end
                    coinChannel = audio.play(coinSound)
                    changeText(50)

                    --Picking up ammos
                elseif name1 == "ammo" or name2 == "ammo" then
                    if name1 == "ammo" then display.remove(event.object1); event.object1 = nil;
                    else display.remove(event.object2); event.object2 = nil; end
                    ammoChannel = audio.play(ammoSound)
                    ammoInt = ammoInt + 5
                    ammoText.text = "Ammo: "..ammoInt

                    --Player hits the spikes
                elseif name1 == "spike" or name2 == "spike" then
                    --Kill player...
                    gameOver()

                    --Player hits an enemy
                elseif name1 == "enemy" or name2 == "enemy" then
                    --Check to see if we jumped ontop of the enemy.
                    if name1 == "enemy" then
                        --Check to see if we jumped ontop of the enemy
                        if player.y < event.object1.y-(event.object1.height*0.5) then
                            display.remove(event.object1); event.object1 = nil
                            changeText(10)
                        else
                            gameOver()
                        end
                    else
                        --Check to see if we jumped ontop of the enemy
                        if player.y < event.object2.y-(event.object2.height*0.5) then
                            display.remove(event.object2); event.object2 = nil
                            changeText(10)
                        else
                            gameOver()
                        end
                    end

                    --Player hits the flag! We end the game and set it to won!
                elseif name1 == "flag" or name2 == "flag" then
                    levelTime = timeText.text
                    gameWon()
                end
            end
        end
    end
    Runtime:addEventListener("collision",onCollision)
end

-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exitScene( event )
    print( "Game: exitScene event" )

    --Stop our timer
    if moveTimer then timer.cancel(moveTimer); moveTimer = nil; end

    --Stop any loops/listeners from running
    Runtime:removeEventListener( "collision", onCollision )
    Runtime:removeEventListener("enterFrame", gameLoop)

    --Stop any sounds.
    audio.stop(overChannel)
    audio.stop(coinChannel)
    audio.stop(jumpChannel)
    audio.stop(winChannel)
end



--Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    print( "Game: destroying view" )
    audio.dispose(winSound); winSound=nil
    audio.dispose(overSound); overSound=nil
    audio.dispose(coinSound); coinSound=nil
    audio.dispose(jumpSound); jumpSound=nil
end




-----------------------------------------------
-- Add the story board event listeners
-----------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

--Return the scene to storyboard.
return scene