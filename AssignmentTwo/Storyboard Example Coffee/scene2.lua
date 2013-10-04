 ----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	

	-----------------------------------------------------------------------------
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		

--import the table view library
local tableView = require("tableView")

-- ui library for buttons 
local ui = require("ui") 
display.setStatusBar( display.HiddenStatusBar ) 
--initial values

local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight 
-- used for offsetting buttons
-- display.viewableContentWidth = A read-only property that contains the width of the viewable screen area in content coordinates.
-- In cases where you use scaling sometimes content is scaled where some appears off screen. Only viewable content gets considered here

local myList

local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(77, 77, 77)
group:insert(background)
 
--setup the table
local data = {}  

--setup a color fill for selected items
local selected = display.newRect(0, 0, 50, 50)  --add acolor fill to show the selected item

selected:setFillColor(67,141,241,180)  --set the color fill to light blue
selected.isVisible = false  --hide color fill until needed

--setup functions to execute on touch of the list view items
function listButtonRelease( event )
	self = event.target -- the target is the row 
	local id = self.id  -- this is the row id in the table

	print(self.data.title) -- the rows data.title
    print(self.data.subtitle) -- the rows data.subtitle
    print(self.data.image) -- the rows data.image
		
	local options =
	{
    params =
   		 {
      	  var1 = self.data.title,
      	  var2 = self.data.subtitle,
      	  var3 = self.data.image
  		 }
	}

	storyboard.gotoScene( "scene3", options )

end

--setup each row as a new table, then add title, subtitle, and image
data[1] = {}
data[1].title = "Hot Coffee"
data[1].subtitle = "Grounds brewed in hot water"
data[1].image = "coffee1.png"

data[2] = {}
data[2].title = "Iced Coffee"
data[2].subtitle = "Chilled coffee with ice"
data[2].image = "coffee2.png"

data[3] = {}
data[3].title = "Espresso"
data[3].subtitle = "Hot water forced through"
data[3].image = "coffee3.png"

data[4] = {}
data[4].title = "Cappuccino"
data[4].subtitle = "Espresso with frothy milk"
data[4].image = "coffee4.png"

data[5] = {}
data[5].title = "Latte"
data[5].subtitle = "More milk and less froth"
data[5].image = "coffee5.png"

data[6] = {}
data[6].title = "Americano"
data[6].subtitle = "Espresso with hot water"
data[6].image = "coffee6.png"



local topBoundary = display.screenOriginY + 40
local bottomBoundary = display.screenOriginY + 0

-- create the list of items

	myList = tableView.newList{
	data=data, --A table containing elements that the list can iterate through to display in each row.
	default="listItemBg.png", --An image for the row background. Defines the hit area for the touch.
	over="listItemBg_over.png", --An image that will show on touch.
	onRelease=listButtonRelease, --A function name that defines the action to take after a row is tapped.
	top=topBoundary, --The upper boundary of the list. The list will start and snap back to this position.
	bottom=bottomBoundary, --The bottom boundary of the list. The list will snap back to this position when scrolled upward.
	
	-- callback = A function that defines how to display the data in each row. Each element in the data table will be used in place of the 
    -- argument ("item")  assigned to the callback function. 
    callback = function( row ) 
                         local g = display.newGroup()

                         local img = display.newImage(row.image)
                         g:insert(img)
                         img.x = math.floor(img.width*0.5 + 6)
                         img.y = math.floor(img.height*0.5) 

                         local title =  display.newText( row.title, 0, 0, native.systemFontBold, 14 )
                         title:setTextColor(0, 0, 0)
                         g:insert(title)
                         title.x = title.width*0.5 + img.width + 6
                         title.y = 30

                         local subtitle =  display.newText( row.subtitle, 0, 0, native.systemFont, 12 )
                         subtitle:setTextColor(80,80,80)
                         g:insert(subtitle)
                         subtitle.x = subtitle.width*0.5 + img.width + 6
                         subtitle.y = title.y + title.height + 6

                         return g  


                  end 
}
group:insert(myList)

local function scrollToTop()
	myList:scrollTo(topBoundary)
end

--Setup the nav bar 
local navBar = ui.newButton{
	default = "navBar.png",
	onRelease = scrollToTop
}

navBar.x = display.contentWidth*.5
navBar.y = math.floor(display.screenOriginY + navBar.height*0.5) -- screenOriginY is used in cases like iphone 5 where borders are added to screen
group:insert(navBar)

local navHeader = display.newText("Coffee", 0, 0, native.systemFontBold, 16)
navHeader:setTextColor(255, 255, 255)
navHeader.x = display.contentWidth*.5
navHeader.y = navBar.y
group:insert(navHeader)

--Add a white background to the list.  

local listBackground = display.newRect( 0, 0, myList.width, myList.height )
listBackground:setFillColor(255,255,255)
myList:insert(1,listBackground)


	-----------------------------------------------------------------------------
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene