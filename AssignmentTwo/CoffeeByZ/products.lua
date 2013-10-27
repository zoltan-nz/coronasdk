local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- Loading helper
local helper = require ( "helper" )

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	helper.drawBackground(group)
	
	local title = display.newText( "PRODUCTS", 0, 0, native.systemFont, 32 )
	title:setTextColor( 255 )	-- black
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth * 0.5
	title.y = 125
	
	tabBar = helper.createTabBar('products')

	group:insert( title )
	group:insert( tabBar )
end

function scene:enterScene( event )
	local group = self.view
end

function scene:exitScene( event )
	local group = self.view
end

function scene:destroyScene( event )
	local group = self.view
end

-----------------------------------------------------------------------------------------

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene
