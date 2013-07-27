-- Project: PhysicsTest
-- Description:
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2013 . All Rights Reserved.
---- cpmgen main.lua



local physics = require("physics")
physics.start()

system.activate("multitouch")

display.setStatusBar(display.HiddenStatusBar)

function onUpdate(event)
    -- let the first call to onUpdate to return quickly;
    -- start the debugging during the second call to trick Corona SDK
    -- and avoid restarting the app.
    if done == nil then done = false return end
    if not done then
        require("mobdebug").start()
        done = true
    end
    -- try to modify the following three lines while running this code live
    -- (using `Project | Run as Scratchpad`)

    ground = display.newRect(100,0,400,400)
    ground2 = display.newRect(10,10,10,10)
    ground2.color = black
    
    display.remove(ground)
    ground = nil
       

end

Runtime:addEventListener("enterFrame", function(event) pcall(onUpdate, event) end)
