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
local itemGroup, itemTitle, itemImage, itemDetails, itemPrice

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	helper.drawBackground(group)

	helper.drawMenuBar(group)

end

function scene:enterScene( event )
	local group = self.view

	local params = event.params

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

    local rowImage = display.newImage(row, row.params.image )
    rowImage.width, rowImage.height = 80, 80
    rowImage:setReferencePoint(display.TopLeftReferencePoint)
    rowImage.x = 5
    rowImage.y = 5

    local rowTitle = display.newText({parent = row, text = row.params.name, font = native.systemFontBold, fontSize = 20, width = 230} )
    rowTitle:setReferencePoint(display.TopLeftReferencePoint)
    rowTitle.x = 90
    rowTitle.y = 5
    rowTitle:setTextColor(95, 55, 17)

    local rowPrice = display.newText(row, row.params.price, 0,0, native.systemFont, 20)
    rowPrice:setReferencePoint(display.TopLeftReferencePoint)
    rowPrice.x = row.contentWidth - 100
    rowPrice.y = row.contentHeight - 40
    rowPrice:setTextColor(212, 192, 152)

	end

	-- Event for clicking on a product
	-- Choosen product_id will be passed as parameter





	-- Handle touches on the row
	-- Used to listen for TableView, with event phases of:
	-- tap, press, release, swipeLeft, swipeRight.
	-- In your listener, event.target is a reference to the TableView row that you interacted with.
	local function onRowTouch( event )
    local phase     = event.phase
    local row       = event.row
    local itemGroup = display.newGroup()

    if row then
      itemImage   = display.newImage(row.params.image, 0, 0, 130, 130)
      itemImage:setReferencePoint(display.TopCenterReferencePoint)
      itemImage.x = _W * 0.5
      itemImage.y = 50
      itemImage.alpha = 0

      itemTitle   = display.newText({text = row.params.name, width = 300, font = native.systemFontBold, fontSize = 25})
      itemTitle:setReferencePoint(display.TopCenterReferencePoint)
      itemTitle.x = _W * 0.5
      itemTitle.y = 250
      itemTitle:setTextColor(95, 55 , 17)
      itemTitle.alpha = 0

      itemDetails = display.newText({text = row.params.details, width = 300, font= native.systemFont, fontSize = 15})
      itemDetails:setReferencePoint(display.TopCenterReferencePoint)
      itemDetails.x = _W * 0.5
      itemDetails.y = 300
      itemDetails:setTextColor(95, 55, 17)
      itemDetails.alpha = 0

      itemPrice   = display.newText(row.params.price, 0, 0, native.systemFont, 15)
      itemPrice:setReferencePoint(display.TopCenterReferencePoint)
      itemPrice.x = _W * 0.5
      itemPrice.y = 400
      itemPrice:setTextColor(95, 55 , 17)
      itemPrice.alpha = 0

      itemGroup:insert(itemImage)
      itemGroup:insert(itemTitle)
      itemGroup:insert(itemDetails)
      itemGroup:insert(itemPrice)
    end

    local onBackRelease = function ()
      transition.to (list, {x = 0, time = 200, transition = easing.outExpo})
      transition.to (backButton, {alpha = 0, time = 200, transition = easing.outQuad})
      if backButton   then  backButton:removeSelf(); backButton = nil end
      if itemImage    then  itemImage:removeSelf(); itemImage = nil end
      if itemTitle    then  itemTitle:removeSelf(); itemTitle = nil end
      if itemDetails  then  itemDetails:removeSelf(); itemDetails = nil end
      if itemPrice    then  itemPrice:removeSelf(); itemPrice = nil end
    end

    backButton = widget.newButton({width = 70, height = 20, label = '<<<', defaultFile = 'images/category_button_pixel.png', onRelease = onBackRelease})
    backButton:setReferencePoint(display.TopLeftReferencePoint)
    backButton.alpha = 0
    backButton.x = 5
    backButton.y = 25
    group:insert(backButton)



    if "press" == phase then
      print( "Touched row id:", row.params.id )

    elseif 'release' == phase then


      transition.to (list,        {x = - list.contentWidth, time = 200, transition = easing.outExpo})
      transition.to (backButton,  {alpha = 1 , time = 200, transition = easing.outQuad})
      transition.to (itemImage,   {alpha = 1, time = 200, transition = easing.outExpo})
      transition.to (itemTitle,   {alpha = 1, time = 200, transition = easing.outExpo})
      transition.to (itemDetails, {alpha = 1, time = 200, transition = easing.outExpo})
      transition.to (itemPrice,   {alpha = 1, time = 200, transition = easing.outExpo})
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

  if headerText   then  headerText:removeSelf(); headerText = nil end
  if backButton   then  backButton:removeSelf(); backButton = nil end
  if itemImage    then  itemImage:removeSelf(); itemImage = nil end
  if itemTitle    then  itemTitle:removeSelf(); itemTitle = nil end
  if itemDetails  then  itemDetails:removeSelf(); itemDetails = nil end
  if itemPrice    then  itemPrice:removeSelf(); itemPrice = nil end

  list:deleteAllRows()
  list = nil

  display:remove(list)

  storyboard.removeAll()

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