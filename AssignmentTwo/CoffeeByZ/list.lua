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
	
	local tabBar = helper.createTabBar('products')
  tabBar:setSelected(2)

	-- Listen for tableView events
	local function tableViewListener( event )
    local phase = event.phase
    local row = event.target

    print( event.phase )
	end

	-- Handle row rendering
	local function onRowRender( event )
    local phase = event.phase
    local row = event.row

    local rowTitle = display.newText( row, "Row " .. row.index, 0, 0, nil, 14 )
    rowTitle.x = row.x - ( row.contentWidth * 0.5 ) + ( rowTitle.contentWidth * 0.5 )
    rowTitle.y = row.contentHeight * 0.5
    rowTitle:setTextColor( 0, 0, 0 )
	end

	-- Handle touches on the row
	local function onRowTouch( event )
	    local phase = event.phase

	    if "press" == phase then
	        print( "Touched row:", event.target.index )
	    end
	end

	-- Create a tableView
	local tableView = widget.newTableView
	{
	    top = 100,
	    width = 320, 
	    height = 366,
	    -- maskFile = "assets/mask-320x366.png",
	    listener = tableViewListener,
	    onRowRender = onRowRender,
	    onRowTouch = onRowTouch,
	}
	group:insert( tableView )

-- Create 100 rows
for i = 1, 100 do
    local isCategory = false
    local rowHeight = 40
    local rowColor = 
    { 
        default = { 255, 255, 255 },
    }
    local lineColor = { 220, 220, 220 }

    -- Make some rows categories
    if i == 25 or i == 50 or i == 75 then
        isCategory = true
        rowHeight = 24
        rowColor = 
        { 
            default = { 150, 160, 180, 200 },
        }
    end

    -- Insert the row into the tableView
    tableView:insertRow
    {
        isCategory = isCategory,
        rowHeight = rowHeight,
        rowColor = rowColor,
        lineColor = lineColor,
    }
end 


	group:insert( tabBar )
end

function scene:enterScene( event )
	local group = self.view

	local params = event.params

	print (params.category_id)

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