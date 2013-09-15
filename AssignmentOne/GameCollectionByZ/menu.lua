----------------------------------------------------------------------------------
--
-- menu.lua
--
--[[

This is the main menu screen.

1. Loading widget modul and creating button widgets.
2. Connect click event to buttons and linking to other screens.
3. Launching a background music.

--]]
--
--
----------------------------------------------------------------------------------


local storyboard = require( "storyboard" )

-- Loading widget module for buttons
local widget = require ('widget')

local scene = storyboard.newScene()

-- Loading shared functions
local shared = require ( "sharedfunctions" )

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
  
  shared.launchBackgroundMusic
  
  shared.drawSoundONOFFButton()
  
  


  
  
  


-- Creating a function to handle button events
local function GameOneButtonEvent (event)
	local phase = event.phase
	if 'ended' == phase then
		print('You pressed and released a button!')
	end
end

-- create a group for buttons
local buttonGroup = display.newGroup()

-- Create buttons
local firstButton = widget.newButton
{
    left = 0,
    top = 0,
    width = 300,
    height = 300,
    default = {255, 255, 255, 90},
    over = {120, 53, 128, 255},
    defaultFile = "",
    overFile = "",
    id = "button_1",
    label = "Button",
    onEvent = handleButtonEvent
}

buttonGroup:insert (firstButton)


-- Create a constantly looping background sound...
local bgSound = audio.loadStream("sounds/EyeOfTheTiger.mp3")
audio.reserveChannels(1)   --Reserve its channel
audio.play(bgSound, {channel=1, loops=-1}) --Start looping the sound.

-- Load tapSound for buttons
local tapSound = audio.loadSound("sounds/tapsound.wav")


end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local screenGroup = self.view
    

end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
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