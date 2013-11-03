local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

-- Loading helper
local helper = require ( "helper" )

local title, text, summary, image

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	helper.drawBackground(group)

	helper.drawMenuBar(group)

	-- create some text
	title = display.newText({text = "CONTACT", font = native.systemFontBold, fontSize = 40, width = 300 })
	title:setTextColor(95, 55, 17)
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth * 0.5
	title.y = 50

  text = "Address: 56. Upper Drumcondra Road\nDrumcondra, Dublin 9, Ireland\nPhone: +353-12345-678\nOpen: Every day from 7am to 8pm"
	summary = display.newText({text = text, width = 300, font =  native.systemFont, fontSize = 14 })
	summary:setTextColor( 95,55,17 ) -- black
	summary:setReferencePoint( display.CenterReferencePoint )
	summary.x = display.contentWidth * 0.5
	summary.y = title.y + 55

	image = display.newImage('images/contact.jpg', 0,0,130,130)
  image:setReferencePoint(display.TopCenterReferencePoint)
  image.x = display.contentWidth * 0.5
  image.y = summary.y + 60

	group:insert( title )
	group:insert( summary )
  group:insert( image )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	-- Do nothing
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)

end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	-- INSERT code here (e.g. remove listeners, remove widgets, save state variables, etc.)

end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene
