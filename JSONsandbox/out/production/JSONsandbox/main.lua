--
-- Created by IntelliJ IDEA.
-- User: szines
-- Date: 03/10/13
-- Time: 23:39
-- To change this template use File | Settings | File Templates.
--

require('physics')
local square = display.newRect(20, 20, 20, 20)
physics.addBody(square, 'dynamic')