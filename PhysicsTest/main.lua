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

-- Create a goroundground = display.newRect(0,0,200,200)