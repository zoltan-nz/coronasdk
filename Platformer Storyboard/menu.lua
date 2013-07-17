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
	print( "Menu: createScene event")
	local screenGroup = self.view
	
	--Load the sounds.
	tapSound = audio.loadSound("sounds/tapsound.wav")

	--Background images first...
	local bg1 = display.newImageRect( "images/mainMenu.jpg", 480,320)
	bg1.x = _W*0.5; bg1.y = _H*0.5
	screenGroup:insert(bg1)

	--Play Game button;
	local function startGame()
		tapChannel = audio.play( tapSound )
		storyboard.gotoScene( "levelSelect", "slideLeft", 400 )
	end
	local playGame = display.newRect(0,0, 120, 60)
	playGame.x = _W*0.5; playGame.y = _H*0.8; playGame.alpha = 0.01
	playGame:addEventListener("tap", startGame)
	screenGroup:insert(playGame)
end


-- Called immediately after scene has moved onscreen:
-- Start timers/transitions etc.
function scene:enterScene( event )
	print( "Menu: enterScene event" )
	
	-- Completely remove the previous scene/all scenes.
	-- Handy in this case where we want to keep everything simple.
	storyboard.removeAll()
end

-- Called when scene is about to move offscreen:
-- Cancel Timers/Transitions and Runtime Listeners etc.
function scene:exitScene( event )
	print( "Menu: exitScene event" )
end

--Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	print( "Menu: destroying view" )
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
