module(..., package.seeall)

local localGroup

--main function - must return a display.newgroup()
function new()
	localGroup = display.newGroup()

	--Background
	local titleBackground = display.newImage("startScreenBackground.png")
	titleBackground.x = _W/2
	titleBackground.y = _H/2
	localGroup:insert(titleBackground)
	
	--Start Button
	local startButton = display.newImage("startButton.png")
	startButton.x = _W/2
	startButton.y = 250
	localGroup:insert(startButton)
	

				
	startButton:addEventListener("touch", pressStart)
	return localGroup
end

function pressStart(event)
	if event.phase=="ended" then
		
		director:changeScene("levelselect")
	end
	
end