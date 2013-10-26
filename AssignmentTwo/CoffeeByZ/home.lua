local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- Loading widget module for buttons
local widget = require ('widget')

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

function scene:createScene( event )
	local group = self.view
	
	-- create a white background to fill screen
	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg:setFillColor( 200 )
	
	-- create some text
	-- local title = display.newText( "HOME SCREEN", 0, 0, native.systemFont, 32 )
	-- title:setTextColor( 0 )	-- black
	-- title:setReferencePoint( display.CenterReferencePoint )
	-- title.x = display.contentWidth * 0.5
	-- title.y = 125
	
	-- local summary = display.newText( "Loaded by the first tab 'onPress' listener\n— specified in the 'tabButtons' table.", 0, 0, 300, 300, native.systemFont, 14 )
	-- summary:setTextColor( 0 ) -- black
	-- summary:setReferencePoint( display.CenterReferencePoint )
	-- summary.x = display.contentWidth * 0.5 + 10
	-- summary.y = title.y + 215

	-- Creating logo
	local logo =  display.newImageRect( "images/logo.png", 100, 20 )
	logo:setReferencePoint(display.CenterReferencePoint)
	logo.x = display.contentCenterX
	logo.y = 100

	-- event listeners for tab buttons:
	local showView = function(event)
		if event then
			view = event.target.id
		else
			view = 'home'
		end
		print (view)
		storyboard.gotoScene( view )
	end

	-- Creating buttons
	local buttonProducts, buttonAbout, buttonContact
	buttonProducts = widget.newButton{
		id = "products",
		left = 10,
		top = 250,
		width = _W-50,
		height = 40,
		label = "PRODUCTS",
		-- labelColor = {r, g, b, a},
		-- size = size,
		-- font = "font",
		onPress = showView,
		-- onRelease = showView,
		-- onEvent = onEvent,
		-- emboss = true/false,
		-- offset = offset,
		-- default = default image,
		-- over = over image,
		-- buttonTheme = "blue or red",
		-- baseDir = pathToImages
	}

	buttonAbout = widget.newButton{
		id = "about",
		left = 10,
		top = 300,
		width = _W-50,
		height = 40,
		label = "ABOUT",
	-- 	labelColor = {r, g, b, a},
	-- 	size = size,
	-- 	font = "font",
		onPress = showView
	-- 	onRelease = onRelease,
	-- 	onEvent = onEvent,
	-- 	emboss = true/false,
	-- 	offset = offset,
	-- 	default = default image,
	-- 	over = over image,
	-- 	buttonTheme = "blue or red",
	-- 	baseDir = pathToImages
	}

	buttonContact = widget.newButton{
		id = "contact",
		left = 10,
		top = 350,
		width = _W-50,
		height = 40,
		label = "CONTACT",
	-- 	labelColor = {r, g, b, a},
	-- 	size = size,
	-- 	font = "font",
		onPress = showView,
	-- 	onRelease = onRelease,
	-- 	onEvent = onEvent,
		emboss = true,
	-- 	offset = offset,
	-- 	default = default image,
	-- 	over = over image,
	-- 	buttonTheme = "blue or red",
	-- 	baseDir = pathToImages
	}






	
	-- all objects must be added to group (e.g. self.view)
	group:insert( bg )
	-- group:insert( title )
	-- group:insert( summary )
	group:insert( logo )
	group:insert( buttonProducts )
	group:insert( buttonAbout)
	group:insert( buttonContact )
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
