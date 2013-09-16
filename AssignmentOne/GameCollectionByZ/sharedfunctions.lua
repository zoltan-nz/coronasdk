-- Shared functions

local widget = require ('widget')

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

local M = {}

local createAButton = function (left, top, width, height, default, over, label, onevent)

  local createdButton = widget.newButton
  {
    left = left,
    top = top,
    width = width,
    height = height,
    label = label,
    onEvent = onevent,
    fontSize = 40
  }

  return(createdButton)
end
M.createAButton = createAButton

local function drawSoundONOFFButton(screenGroup)

  -- Sound ON/OFF text in the bottom-right corner
  --  soundText = display.newText(screenGroup, "Sound: ON", 0, _H-30, "Arial", 20)
  --  soundText:setTextColor(50)

  function soundOnOff(event)
    local phase = event.phase
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

  soundButton = createAButton(0, _H-30, 240, 70, '', '', "Sound: ON", soundOnOff)
  screenGroup:insert(soundButton)

  -- This listener connect action to our button.
  --  soundText:addEventListener("tap", soundOnOff)



end
M.drawSoundONOFFButton = drawSoundONOFFButton

local drawBackground = function (group)

	local background = display.newRect(group, 0, 0, _W, _H )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
  background:setFillColor(20,20,20,20)


end
M.drawBackground = drawBackground

return M