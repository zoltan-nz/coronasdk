--import director class
local director = require("director")

--create a main group
local localGroup = display.newGroup()
_W = display.contentWidth
_H = display.contentHeight

--main function
local function main()

	-- add the group from director class
	localGroup:insert(director.directorView)

	--change scene without effects
	director:changeScene("startscreen")

	return true
end
	
--begin
main()