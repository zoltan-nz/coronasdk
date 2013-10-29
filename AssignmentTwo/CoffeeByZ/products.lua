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
	
	local tabBar = helper.createTabBar('products')
	tabBar:setSelected(2)

	-- Event for clicking on a category.
	-- Choosen category_id will be passed as a parameter.
	local visitCategory = function (event)
		local options = {
			effect 	= 'slideLeft',
			time 		= 200,
			params 	= {
								category_id = event.target.id
								}
		}
		storyboard.gotoScene( 'list', options ) 
	end

	-- Let's create a grid of buttons. Size of this grid is
	-- depend of the size of the database

	-- Params
	local number_of_columns 	= 4
	local padding_left_size 	= 10
	local padding_top_size		= 10
	local width_of_a_button 	= (_W-(padding_left_size * number_of_columns))/number_of_columns
	local height_of_a_button 	= 30

	local size_of_categories = #database.categories
	local number_of_rows = size_of_categories / number_of_columns

	local start_y_position = 50

	local category_id = 1

	local y_position = start_y_position
	for row = 1,number_of_rows do
		local x_position = padding_left_size
		for column = 1, number_of_columns do
			local categoryButton, category_name
			category_name = database.categories[category_id].name
			print (category_name)
			categoryButton = helper.createButton(category_id, x_position, y_position, width_of_a_button, height_of_a_button, category_name, visitCategory)
			group:insert(categoryButton)	
			category_id = category_id + 1
			if category_id > size_of_categories then break end
			x_position = x_position + width_of_a_button + padding_left_size
		end
		y_position = y_position + height_of_a_button + padding_top_size
	end

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
