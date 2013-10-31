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

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view
	
	helper.drawBackground(group)
	

end

function scene:enterScene( event )
	local group = self.view

	local params = event.params

	print (params.category_id)
	local category_id = params.category_id

	-- Listen for tableView events
	-- Listener. Used to listen for TableView events, with the following events: 
	-- event.limitReached - Indicates that the TableView has reached one of it's limits. 
	-- event.direction - Returns the direction the TableView is moving in.
	local function tableViewListener( event )
    local phase = event.phase
    local row = event.target
    print( event.phase )
	end

	-- Handle row rendering
	-- onRowRender (optional)
	-- Listener. Used to listen for TableView row rendering events, with event types of: rowRender. 
	-- This listener is initiated on both the initial rendering of the tableView rows and also when a row which was previously 
	-- off-screen has moved back on screen. In your listener, event.row is a reference to the TableView row that was rendered.
	local function onRowRender( event )
    local phase = event.phase
    local row = event.row

    local rowTitle = display.newText( row, row.params.name, 0, 0, nil, 14 )
    rowTitle.x = row.x - ( row.contentWidth * 0.5 ) + ( rowTitle.contentWidth * 0.5 )
    rowTitle.y = row.contentHeight * 0.5
    rowTitle:setTextColor( 0, 0, 0 )
	end

	-- Event for clicking on a product
	-- Choosen product_id will be passed as parameter
	local visitProduct = function (id)
		local options = {
			effect 	= 'slideLeft',
			time 		= 200,
			params 	= {
								product_id = id
								}
		}
		storyboard.gotoScene( 'item', options ) 
	end

	-- Handle touches on the row
	-- Used to listen for TableView, with event phases of: 
	-- tap, press, release, swipeLeft, swipeRight. 
	-- In your listener, event.target is a reference to the TableView row that you interacted with.
	local function onRowTouch( event )
	    local phase = event.phase
	    local row   = event.row
	    print (phase)
	    if "press" == phase then
	    	print( "Touched row id:", row.params.id )
	      visitProduct(row.params.id)
	    end
	end

	-- Create a tableView
	local tableView = widget.newTableView
	{
	    top = 100,
	    width = 320, 
	    height = 300,
	    -- maskFile = "assets/mask-320x366.png",
	    listener = tableViewListener,
	    onRowRender = onRowRender,
	    onRowTouch = onRowTouch,
	}
	group:insert( tableView )

	local products = {}
	local i, product
	
	-- get products for database where category_id is the choosen one
	for i,product in pairs(database.products) do
	  if product.category_id == category_id then
	  	table.insert(products, product)
	  	tableView:insertRow
    	{ 
    		rowHeight = 100,
    		rowColor = { 150, 160, 180, 200 },
    		lineColor = { 0 },
    		params = {       
        		id 		= product.id,
        		name 	= product.name
      	}
    	}
	  end
	end

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