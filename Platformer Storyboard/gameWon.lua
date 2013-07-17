-------------------------------------------------------------------------
--T and G Apps Ltd.
--Created by Jamie Trinder
--www.tandgapps.co.uk

--CoronaSDK version 2012.971 was used for this template.

--The art was sourced from www.vickiwenderlich.com 
--A great site for free art assets

--You are not allowed to publish this template to the Appstore as it is. 
--You need to work on it, improve it and replace a lot of the graphics. 

--For questions and/or bugs found, please contact me using our contact
--form on http://www.tandgapps.co.uk/contact-us/
-------------------------------------------------------------------------

--Start off by requiring storyboard and creating a scene.
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()


--Variables etc we needs
local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight 
local tapChannel, tapSound --Sound variables..



------------------------------------------------
-- *** STORYBOARD SCENE EVENT FUNCTIONS ***
------------------------------------------------
-- Called when the scene's view does not exist:
-- Create all your display objects here.
function scene:createScene( event )
	print( "gameWon: createScene event")
	local screenGroup = self.view
	
	--Load the sounds.
	tapSound = audio.loadSound("sounds/tapsound.wav")


	--------
	-- *** Check to see if we got a highscore.. ***
	--------
	--Get the highest score that we had previously.
	local highScore = 0
	local dbPath = system.pathForFile("levelScores.db3", system.DocumentsDirectory)
	local db = sqlite3.open( dbPath )	
	for row in db:nrows("SELECT * FROM scores WHERE id = "..currentLevel) do
		highScore = tonumber(row.highscore)
	end
	
	--Compare what we got this level and save it if its higher..
	if levelScore > highScore then
		highScore = levelScore
		local update = "UPDATE scores SET highscore ='"..levelScore.."' WHERE id = "..currentLevel
		db:exec(update)
	end
	db:close()


	--------
	-- *** Iterate the currentLevel
	--This is done so that when we press next it will go to the next level
	--------
	currentLevel = currentLevel + 1 --Our global var from the main.lua


	--------
	-- *** Create the background and Next/menu Buttons ***
	--------
	--Background images first...
	local bg1 = display.newImageRect( "images/gameWon.jpg", 480,320)
	bg1.x = _W*0.5; bg1.y = _H*0.5
	screenGroup:insert(bg1)
	
	--Next level/Menu button
	local function gotoGame() 
		if currentLevel > amountofLevels then storyboard.gotoScene( "menu", "slideRight", 400 )
		else storyboard.gotoScene( "game", "slideLeft", 400 ) end
	end
	local nextBtn = display.newRect(0,0, 280, 80)
	nextBtn.x = _W*0.5; nextBtn.y = _H*0.72; nextBtn.alpha = 0.01
	nextBtn:addEventListener("tap", gotoGame)
	screenGroup:insert(nextBtn)
	
	local function gotoMenu() storyboard.gotoScene( "menu", "slideRight", 400 ) end
	local menu = display.newRect(0,0, 80, 30)
	menu.x = 40; menu.y = _H-24; menu.alpha = 0.01
	menu:addEventListener("tap", gotoMenu)
	screenGroup:insert(menu)
	

	--Now show the score text and highscore text...
	local score1 = display.newText(screenGroup, levelScore, 0,0, native.systemFontBold, 18)
	score1:setReferencePoint(display.CenterLeftReferencePoint); score1:setTextColor(40)
	score1.x = (_W*0.5)+10; score1.y = _H*0.472

	local score2 = display.newText(screenGroup, highScore, 0,0, native.systemFontBold, 18)
	score2:setReferencePoint(display.CenterLeftReferencePoint); score2:setTextColor(40)
	score2.x = (_W*0.5)+10; score2.y = _H*0.57
end


-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enterScene( event )
	print( "gameWon: enterScene event" )

	-- Completely remove the previous scene/all scenes.
	-- Handy in this case where we want to keep everything simple.
	storyboard.removeAll()
end

-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exitScene( event )
	print( "gameWon: exitScene event" )
end

--Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	print( "gameWon: destroying view" )
	audio.dispose( tapSound ); tapSound = nil;
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
