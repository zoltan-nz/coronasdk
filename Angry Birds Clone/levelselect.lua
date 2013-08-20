module(..., package.seeall)

local localGroup

--main function - must return a display.newgroup()
function new()
	localGroup = display.newGroup()

	--Background
	local titleBackground = display.newImage("levelSelectBackground.png")
	titleBackground.x = display.contentWidth/2
	titleBackground.y = display.contentHeight/2
	localGroup:insert(titleBackground)
	
	--Add Background Music and Sound Effects
	tapSound = audio.loadStream( "tapsound.wav" )
		
	--Level1
	local level1 = display.newImage("level1.png")
	level1.x = display.contentWidth/3
	level1.y = 250
	localGroup:insert(level1)
	
	--Level2
	local level2 = display.newImage("level2.png")
	level2.x = display.contentWidth/3 * 2
	level2.y = 250
	localGroup:insert(level2)
	
	--MainMenu
	local mainMenu = display.newImage("mainMenu.png")
	mainMenu.x = display.contentWidth/2
	mainMenu.y = 500
	localGroup:insert(mainMenu)
	
	
	level1:addEventListener("touch", pressLevel1)
	level2:addEventListener("touch", pressLevel2)
	mainMenu:addEventListener("touch", pressBack)
	return localGroup
end

function pressLevel1(event)
	if event.phase == "began" then
		audio.play( tapSound )
	elseif event.phase=="ended" then
	
		director:changeScene("level1")
	end
end

function pressLevel2(event)
	if event.phase=="ended" then
	audio.play( tapSound )
		director:changeScene("level2")
	end
end

function pressBack(event)
	if event.phase=="ended" then
	audio.play( tapSound )
		director:changeScene("startscreen")
	end
end