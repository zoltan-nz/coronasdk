-------------------------------------------------------------------------
--T and G Apps Ltd.
--Created by Jamie Trinder
--www.tandgapps.co.uk

--CoronaSDK version 2012.971 was used for this template.

--The art was sourced from http://biffybeebe.net/graphics/
--Created by Biffy Beebe, you would have to purchase the indie Graphics bundle
--yourself in order to use the graphics in this template in your own game.

--You are not allowed to publish this template to the Appstore as it is. 
--You need to work on it, improve it and replace the graphics. 

--For questions and/or bugs found, please contact me using our contact
--form on http://www.tandgapps.co.uk/contact-us/
-------------------------------------------------------------------------

--Initial Settings
display.setStatusBar( display.HiddenStatusBar ) --Hide status bar from the beginning


-- Import sqlite and storyboard
local sqlite3 = require("sqlite3")
local storyboard = require "storyboard"
storyboard.purgeOnSceneChange = true --So it automatically purges for us.



--Create a constantly looping background sound...
local bgSound = audio.loadStream("sounds/bgSound.mp3")
audio.reserveChannels(1)   --Reserve its channel
--audio.play(bgSound, {channel=1, loops=-1}) --Start looping the sound.


--Activate multi-touch so we can press multiple buttons at once.
system.activate("multitouch")


--Create some level globals used in the game itself/gameWon/gameOver scenes.
_G.amountofLevels = 2
_G.currentLevel = 1
_G.levelScore = 0  


--Create a database table for holding the high scores per level in.
--We only need a small database as we dont need to save much information.
local dbPath = system.pathForFile("levelScores.db3", system.DocumentsDirectory)
local db = sqlite3.open( dbPath )	

--Current 2 levels. Add more rows to make more levels available. Also remember if
--you add an extra row into this database you need to add an exta level to
--"amountofLevels" above.
local tablesetup = [[ 
		CREATE TABLE scores (id INTEGER PRIMARY KEY, highscore); 
		INSERT INTO scores VALUES (NULL, '0'); 
		INSERT INTO scores VALUES (NULL, '0'); 
	]]
db:exec( tablesetup ) --Create it now.
db:close() --Then close the database







local memoryRect = display.newRect(10, 5, 500, 100)
		memoryRect:setFillColor(255, 255, 255)
		memoryRect:setStrokeColor(45, 180, 100)
local memUsageText = display.newText( "Hello, World", 0, 0, "Helvetica", 50 )
		memUsageText:setTextColor(0, 0, 255)
local textureMemUsageText = display.newText( "Hello, World", 0, 50, "Helvetica", 50 )
		textureMemUsageText:setTextColor(0, 0, 255)


---------------------------------------------------------------------------------
local monitorMem = function()

   collectgarbage()

	 
   local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
	   memUsageText.text = collectgarbage("count")
	   memUsageText:setReferencePoint(display.TopLeftReferencePoint)
	   memUsageText.x = 10

	   textureMemUsageText.text = textMem
	   textureMemUsageText:setReferencePoint(display.TopLeftReferencePoint)
	   textureMemUsageText.x = 10

end


Runtime:addEventListener( "enterFrame", monitorMem )
--Now change scene to go to the menu.
storyboard.gotoScene( "menu", "fade", 400 )
