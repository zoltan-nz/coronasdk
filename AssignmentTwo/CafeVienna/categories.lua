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

	helper.drawMenuBar(group)

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
  -- Text and images will be positioned dynamically based on rows in databases and content.

	-- Params, these helps in positioning and determining the layout
	local number_of_columns 	= 2
	local padding_left_size 	= 10
	local padding_top_size		= 10
	local width_of_a_button 	= (_W-(padding_left_size * (number_of_columns+1)))/number_of_columns
	local height_of_a_button 	= 150

	local size_of_categories = #database.categories
	local number_of_rows = size_of_categories / number_of_columns

	local start_y_position = 50

	local category_id = 1

	-- This loop will generate buttons and insert image on buttons.
  local y_position = start_y_position
	for row = 1,number_of_rows do
		local x_position = padding_left_size
		for column = 1, number_of_columns do

      local categoryButton, category_name, category_image_path, categoryImage

      -- Reading data from database
      category_name           = database.categories[category_id].name
      category_image_path     = database.categories[category_id].image

      -- Create button with label which was read from database
      categoryButton = helper.createButton({id = category_id, left = x_position, top = y_position, width = width_of_a_button, height = height_of_a_button, label = category_name, onevent =  visitCategory, defaultfile = 'images/category_button_pixel.png', overfile = 'images/category_button_pixel_clicked.png', fontsize = 20, labelxoffset = 0, labelyoffset = -50, labelColor = {default = {95,55,17}, over = {95,55,17} }})

      group:insert(categoryButton)

      -- Create an image on button, the path of image read from database.
      categoryImage =  display.newImageRect( category_image_path, width_of_a_button-50, width_of_a_button-50)
      categoryImage:setReferencePoint(display.CenterReferencePoint)
      categoryImage.x, categoryImage.y = x_position+width_of_a_button/2, y_position+height_of_a_button/2+10
      group:insert(categoryImage)

			category_id = category_id + 1

      -- If number of categories odd number, then have to finish this loop earlier.
			if category_id > size_of_categories then break end
			x_position = x_position + width_of_a_button + padding_left_size
		end
		y_position = y_position + height_of_a_button + padding_top_size
	end

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
