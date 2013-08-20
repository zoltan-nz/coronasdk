--------- PLATFORMS

function makePlatform(x,y)

	local top = display.newImage("blockSuperLong.png")
	top.x = x
	top.y = y
	
	local left = display.newImage("blockLong1.png")
	left.x = x  + 100
	left.y = y + top.height
	
	local right = display.newImage("blockLong1.png")
	right.x = x-100
	right.y = y+top.height 
	
	local monster = display.newImage("monster.png")
	monster.x = x
	monster.y = y + 60
		
	physics.addBody(monster, "dynamic", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	physics.addBody(left, "dynamic", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	physics.addBody(right, "dynamic", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	physics.addBody(top, "dynamic", {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false})
	gameGroup:insert(left)
	gameGroup:insert(right)
	gameGroup:insert(top)
	gameGroup:insert(monster)
	monster:addEventListener("postCollision", hitMonster)
	top:addEventListener("postCollision", hitPlatform)
end

for i=1,3 do
	for j = 4, i+1, -1 do
		makePlatform(2500+(280*(j - (i/2))),-i*115)
	end
end