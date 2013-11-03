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

local list, item, backButton, headerText

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	helper.drawBackground(group)

	helper.drawMenuBar(group)

end

function scene:enterScene( event )
	local group = self.view

	local params = event.params

	print (params.category_id)
	local category_id = params.category_id

  headerText = display.newText(group, database.categories[category_id].name, 0, 0, 0, 0, native.systemFontBold, 25)
  headerText.x, headerText.y = _W * 0.5, 35
  headerText:setTextColor(95,55,17)

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
    print (row.x, row.y)


    local rowImage = display.newImage(row, row.params.image )
    rowImage.width, rowImage.height = 80, 80
    rowImage:setReferencePoint(display.TopLeftReferencePoint)
    rowImage.x = 5
    rowImage.y = 5

    local rowTitle = display.newText(row, row.params.name, 0, 0, native.systemFontBold, 20 )
    rowTitle:setReferencePoint(display.TopLeftReferencePoint)
    rowTitle.x = 100
    rowTitle.y = 5
    rowTitle:setTextColor(95, 55, 17)

    local rowPrice = display.newText(row, row.params.price, 0,0, native.systemFont, 20)
    rowPrice:setReferencePoint(display.TopLeftReferencePoint)
    rowPrice.x = row.contentWidth - 80
    rowPrice.y = row.contentHeight - 40
    rowPrice:setTextColor(226, 213, 193)

	end

	-- Event for clicking on a product
	-- Choosen product_id will be passed as parameter





	-- Handle touches on the row
	-- Used to listen for TableView, with event phases of:
	-- tap, press, release, swipeLeft, swipeRight.
	-- In your listener, event.target is a reference to the TableView row that you interacted with.
	local function onRowTouch( event )
    local phase = event.phase
    local row   = event.row
    print (phase)

    local onBackRelease = function ()
      transition.to (list, {x = 0, time = 200, transition = easing.outExpo})
      transition.to (backButton, {alpha = 0, time = 200, transition = easing.outQuad})
    end

    backButton = widget.newButton{width = 100, height = 50, label = 'Back', labelYOffset = -1, onRelease = onBackRelease}
    backButton.alpha = 0
    backButton.x = display.contentCenterX
    backButton.y = display.contentHeight - backButton.contentHeight
    group:insert(backButton)

    if "press" == phase then
      print( "Touched row id:", row.params.id )

    elseif 'release' == phase then

      transition.to (list, {x = - list.contentWidth, time = 200, transition = easing.outExpo})
      --      transition.to (itemSelected.name, {x= display.contentCenterX, time = 200, transition = easing.outExpo})
      transition.to (backButton, {alpha =1 , time = 200, transition = easing.outQuad})

    end

	end

	-- Create a tableView
	list = widget.newTableView
	{
    top 					= 50,
    width 				= _W,
    height 				= (_H-150),
    listener 			= tableViewListener,
    onRowRender 	= onRowRender,
    onRowTouch 		= onRowTouch,
    maskFile      = 'images/mask-320x448.png',
    noLines       = true
	}
	group:insert( list )

	local i, product

	-- get products for database where category_id is the choosen one
	for i,product in pairs(database.products) do
	  if product.category_id == category_id then
	  	print(product.id)
	  	list:insertRow
    	{
    		rowHeight = 100,
    		rowColor = { 150, 160, 180, 200 },
    		lineColor = { 200 },
    		params = {
          id 			= product.id,
          name 		= product.name,
          price 	= product.price,
          image 	= product.image,
          details = product.details
      	}
    	}
	  end
	end

end

function scene:exitScene( event )
	local group = self.view

  headerText:removeSelf()

  list:deleteAllRows()

  list = nil

  display:remove(list)

  storyboard.removeAll()

  print('exit Scene')

end

function scene:destroyScene( event )
	local group = self.view
  storyboard.removeAll()
end

-----------------------------------------------------------------------------------------

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene