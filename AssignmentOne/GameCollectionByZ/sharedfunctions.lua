-- Shared functions

local widget = require ('widget')
local storyboard = require "storyboard"

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

local tapChannel

local M = {}

local createAButton = function (left, top, width, height, default, over, label, onevent, fontsize)

  fontsize = fontsize or 12

  local createdButton = widget.newButton
  {
    left = left,
    top = top,
    width = width,
    height = height,
    label = label,
    onEvent = onevent,
    fontSize = fontsize
  }

  return(createdButton)
end
M.createAButton = createAButton

local function drawSoundONOFFButton()

  -- Sound ON/OFF text in the bottom-right corner
  --  soundText = display.newText(screenGroup, "Sound: ON", 0, _H-30, "Arial", 20)
  --  soundText:setTextColor(50)

  function soundOnOff(event)
    local phase = event.phase

    if phase == "began" then
      tapChannel = audio.play( tapSound )
    end

    if phase == "ended" then
      if audioPaused then
        print("Sound ON")
        audio.setMaxVolume(1)
        soundButton:setLabel("Sound: ON")
        audioPaused = false
      else
        print("Sound OFF")
        audio.setMaxVolume(0) -- Handy option to turn off the music and every sound effects.
        audioPaused = true
        soundButton:setLabel("Sound: OFF")
      end
    end


  end
  local buttonLabel
  if audioPaused then
    buttonLabel = "Sound: OFF"
  else
    buttonLabel = "Sound: ON"
  end

  soundButton = createAButton(5, _H-50, 100, 40, '', '', buttonLabel, soundOnOff)
  --  screenGroup:insert(soundButton)


  -- This listener connect action to our button.
  --  soundText:addEventListener("tap", soundOnOff)



end
M.drawSoundONOFFButton = drawSoundONOFFButton

local drawBackground = function (group)

	local background = display.newRect(group, 0, 0, _W, _H )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
  background:setFillColor(0,20,0)


end
M.drawBackground = drawBackground

local drawBackToMenu = function (group)

  local backToMenuEvent = function (event)
    local phase = event.phase

    if phase == "began" then
      tapChannel = audio.play( tapSound )
    end

    if phase == "ended" then
      storyboard.gotoScene( "menu" )
    end
  end

  backButton = createAButton(_W-110, _H-50, 100, 40, '', '', "Menu", backToMenuEvent)
  group:insert(backButton)

end
M.drawBackToMenu = drawBackToMenu

return M