display.setStatusBar (display.HiddenStatusBar)

local physics = require('physics')
physics.start()
physics.pause()

r = display.newRect(100, 100, 100, 100)
r:setFillColor(255, 0, 0)
physics.addBody(r, 'dynamic')

function start()
	physics.start()
end

Runtime:addEventListener('tap', start)