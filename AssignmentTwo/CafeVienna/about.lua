local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

-- Loading helper
local helper = require ( "helper" )

local title, text, summary, image

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	helper.drawBackground(group)

	helper.drawMenuBar(group)

	-- create some text
	title = display.newText({text = "ABOUT", font = native.systemFontBold, fontSize = 40, width = 300 })
	title:setTextColor(95, 55, 17)
	title:setReferencePoint( display.CenterReferencePoint )
	title.x = display.contentWidth * 0.5
	title.y = 50

  text = "Cafe Vienna is a Family owned and operated German Restaurant, where each meal is made old fashioned way: From Scratch."
	summary = display.newText({text = text, width = 300, font =  native.systemFont, fontSize = 14 })
	summary:setTextColor( 95,55,17 ) -- black
	summary:setReferencePoint( display.CenterReferencePoint )
	summary.x = display.contentWidth * 0.5
	summary.y = title.y + 50

	image = display.newImage('images/about.jpg', 0,0,130,130)
  image:setReferencePoint(display.TopCenterReferencePoint)
  image.x = display.contentWidth * 0.5
  image.y = summary.y + 30

	group:insert( title )
	group:insert( summary )
  group:insert( image )
end

function scene:enterScene( event )
	local group = self.view
end

function scene:exitScene( event )
	local group = self.view
  --  if title    then title:removeSelf(); title = nil end
  --  if text     then text = nil end
  --  if summary  then summary:removeSelf(); summary = nil end
  --  if image    then image:removeSelf(); image = nil end



end

function scene:destroyScene( event )
	local group = self.view
end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene
