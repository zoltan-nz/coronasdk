local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

-- Loading widget module for buttons
local widget = require ('widget')

-- Loading helper
local helper = require ( "helper" )

-- Load database file
local database = require ('database')

local productTitle

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	helper.drawBackground(group)
	
end

function scene:enterScene( event )
	
	local group = self.view

	local params = event.params

	print (params.product_id)
	local product_id = params.product_id
	local product = database.products[product_id]

	productTitle = display.newText( product.name, 0, 0, nil, 30 )
  productTitle:setReferencePoint(display.CenterReferencePoint)
  productTitle.x = _W/2
  productTitle.y = _H/2
  productTitle:setTextColor( 255,255,255 )
  productTitle.reference = 'producttitle'

  group:insert( productTitle )

end

function scene:exitScene( event )
	local group = self.view
	
  display.remove(productTitle)
  
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