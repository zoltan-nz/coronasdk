local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

-- Loading helper
local helper = require ( "helper" )

-- Load database file
local database = require ('database')

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

	size_of_categories = #database.categories
	for i = 1, size_of_categories do
		local categoryButton
		category_name = database.categories[i].name
		print (category_name)
		categoryButton = helper.createButton("category_"..i, 10, 250+(i*30), _W-50, 40, category_name)
		group:insert(categoryButton)
	end
-- for i=1,10 do
-- 	print(i)
-- end


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
