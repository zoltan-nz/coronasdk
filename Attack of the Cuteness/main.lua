-- Project: Attack of the Cuteness Game
-- http://MasteringCoronaSDK.com
-- Version: 1.0
-- Copyright 2013 J. A. Whye. All Rights Reserved.
-- "Space Cute" art by Daniel Cook (Lostgarden.com)

-- housekeeping stuff

require("mobdebug").start()

display.setStatusBar(display.HiddenStatusBar)

local centerX = display.contentCenterX
local centerY = display.contentCenterY



-- set up forward references


-- preload audio

local sndKill = audio.loadSound("boing-1.wav")
local sndBlast = audio.loadSound("blast.mp3")
local sndLose = audio.loadSound("wahwahwah.mp3")

score = 0

-- create play screen

function createPlayScreen()
    local background = display.newImage("background.png")
    background.y = 130
    background.alpha = 0

    planet = display.newImage("planet.png")

    planet.x = centerX
    planet.y = display.contentHeight + 60
    planet.alpha = 0
    planet.xScale = 2
    planet.yScale = 2


    transition.to(background, { time=2000, alpha = 1, y=centerY, x=centerX})

    local function showTitle()
        gameTitle = display.newImage("gametitle.png")
        gameTitle.alpha = 0
        gameTitle:scale(4,4)
        transition.to(gameTitle, {time=500, alpha=1, xScale=1, yScale=1} )
        gameTitle:addEventListener("tap", shipSmash)
        score = 0
        startGame()
    end

    transition.to(planet, { time=2000, alpha=1, xScale=1, yScale=1, y=centerY, onComplete=showTitle})

end


-- game functions

function spawnEnemy()

    local enemy = display.newImage("beetleship.png")
    enemy:addEventListener("tap", shipSmash)

    if math.random(2) == 1 then
        enemy.x = math.random (-100, -10)
    else
        enemy.x = math.random (display.contentWidth + 10, display.contentWidth + 100)
    end
    enemy.y = math.random (display.contentHeight)

    speed = 3000 - (score * 3)
    if speed < 400 then
        speed = 400
    end

    enemy.trans = transition.to (enemy, {x=centerX, y=centerY, time=speed, onComplete=hitPlanet})

end


function startGame()
    local text = display.newText("Tap here to start. Protect the planet!", 0, 0, "Helvetica", 24)
    text.x = centerX
    text.y = display.contentHeight - 30
    text:setTextColor(255, 254, 185)
    local function goAway(event)
        display.remove(event.target)
        text = nil
        display.remove(gameTitle)
        spawnEnemy()
        scoreTxt = display.newText("Score: 0", 0, 0, "Helvetica", 22)
        scoreTxt.x = centerX
        scoreTxt.y = 10
        score = 0
        numHits = 0
    end

    text:addEventListener ("tap", goAway)
end


local function planetDamage()

    local function goAway(obj)
        planet.xScale = 1
        planet.yScale = 1
        planet.alpha = 1 - (numHits * 2 / 10)
    end
    transition.to (planet, {time = 200, xScale = 1.2, yScale = 1.2, alpha=1, onComplete=goAway} )
end


function hitPlanet(obj)
    display.remove(obj)
    numHits = numHits + 1
    planetDamage()
    audio.play(sndBlast)
    if numHits == 5 then
        theEnd()
    else
        spawnEnemy()
    end

end


function shipSmash(event)
    local obj = event.target
    display.remove(obj)
    audio.play(sndKill)
    transition.cancel (event.target.trans)
    score = score + 28
    scoreTxt.text = "Score: " .. score
    spawnEnemy()
    return true
end

function theEnd()
    theEndtext = display.newText("The End", 0, 0, "Helvetica", 35)
    theEndtext.x = centerX
    theEndtext.y = centerY
    audio.play(sndLose)

    local function goAway(event)
        display.remove(event.target)
        display.remove(scoreTxt)
        createPlayScreen()
    end

    theEndtext:addEventListener("tap", goAway)
end

createPlayScreen()

