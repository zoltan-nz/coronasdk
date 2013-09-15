-- Shared functions

local widget = require ('widget')

local _W = display.contentWidth --Width and height parameters
local _H = display.contentHeight

local M = {}

local function drawSoundONOFFButton(screenGroup)

  print('Sound on off button draw function called')


  -- Sound ON/OFF text in the bottom-right corner
  soundText = display.newText(screenGroup, "Sound: ON", 380, 290, 100, 20, "Arial", 15)
  soundText:setTextColor(50)

  function soundOnOff()
    if audioPaused then
      print("Sound ON")
      audio.setMaxVolume(1)
      soundText.text = "Sound: ON"
      audioPaused = false
    else
      print("Sound OFF")
      audio.setMaxVolume(0) -- Handy option to turn off the music and every sound effects.
      audioPaused = true
      soundText.text = "Sound: OFF"
    end

  end
  -- This listener connect action to our button.
  soundText:addEventListener("tap", soundOnOff)



end
M.drawSoundONOFFButton = drawSoundONOFFButton

local createAButton = function (left, top, width, height, default, over, label, onevent)

  local createdButton = widget.newButton
  {
    left = left,
    top = top,
    width = width,
    height = height,
    default = default,
    over = over,
    defaultFile = "",
    overFile = "",
    label = label,
    onEvent = onevent
  }

  return(createdButton)
end
M.createAButton = createAButton


local drawBackground = function ()

	local background = display.newRect( 0, 0, _W, _H )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0
  background:setFillColor(140,140,140,140)
  background:setFillColor(180,180,180,180)
end
M.drawBackground = drawBackground

return M