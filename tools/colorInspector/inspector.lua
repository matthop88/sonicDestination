--------------------------------------------------------------
--                 Functional Specifications                --
--------------------------------------------------------------

--[[
                       Short Description
                       -----------------
          An image of choice is drawn to the screen.
          Clicking on any pixel of the image prints
          an RGB description of the color both to
          the screen and to the text console.

                           Features
                           --------
       [X] Image can be scrolled using the up, down,
           left and right arrow keys.
       [.] Image can be zoomed in using the 'z' key
           and zoomed out using the 'a' key
       [ ] Clicking on any pixel of the image prints
           an RGB description of the color both to
           the screen and to the text console.

--]]

require "tools/colorInspector/scrolling"
require "tools/colorInspector/zooming"

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

IMAGE                       = love.graphics.newImage("game/resources/images/spriteSheets/sonic1.png")
                              -- https://www.spriters-resource.com/sega_genesis_32x/sonicth1/sheet/21628/
WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600
DOUBLE_TAP_THRESHOLD        = 0.2

lastKeypressed              = nil
lastKeypressedTime          = 0
dashing                     = false

x,      y                   = 0, 0
scale                       = 1

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Color Inspector")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

if __INSPECTOR_FILE ~= nil then
    IMAGE = love.graphics.newImage("game/resources/images/spriteSheets/" .. __INSPECTOR_FILE .. ".png")
else
    IMAGE = love.graphics.newImage("tools/resources/images/sadNoFileImage.png")
end

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.draw()
-- Called By:     LOVE2D application, every single frame
--------------------------------------------------------------
function love.draw()
    love.graphics.draw(IMAGE, x, y, 0, scale, scale)
end

-- Function Name: love.update()
-- Called By:     LOVE2D application, every single frame
-- Parameters:    dt - time lapsed between update calls
--                     (in fractions of a second)
--------------------------------------------------------------
function love.update(dt)
    updateScrolling(dt)
    updateZooming(dt)
end

-- Function Name: love.keypressed()
-- Called By:     LOVE2D application, when any key is pressed
-- Parameters:    key - text value of key pressed by the user
--------------------------------------------------------------
function love.keypressed(key)
    handleKeypressed(key)
end

-- Function Name: love.keyreleased()
-- Called By:     LOVE2D application, when any key is released
-- Parameters:    key - text value of key released by the user
--------------------------------------------------------------
function love.keyreleased(key)
    handleKeyreleased(key)
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function handleKeypressed(key)
    dashing = isDoubleTap(key)
    
    handleScrollKeypressed(key)
    handleZoomKeypressed(key)
    
    lastKeypressed     = key 
    lastKeypressedTime = love.timer.getTime()
end

function isDoubleTap(key)
    return lastKeypressed == key and getTimeElapsedSinceLastKeypress() < DOUBLE_TAP_THRESHOLD
end

function getTimeElapsedSinceLastKeypress()
    return love.timer.getTime() - lastKeypressedTime
end

function handleKeyreleased(key)
    handleScrollKeyreleased(key)
    handleZoomKeyreleased(key)
    
    if getTimeElapsedSinceLastKeypress() >= DOUBLE_TAP_THRESHOLD then
        keepImageInBounds()
    end
end

function keepImageInBounds()
    keepImage_X_InBounds()
    keepImage_Y_InBounds()
end

function keepImage_X_InBounds()
    x = math.min(0, math.max(x, WINDOW_WIDTH  - (IMAGE:getWidth() * scale)))
end

function keepImage_Y_InBounds()
    y = math.min(0, math.max(y, WINDOW_HEIGHT - (IMAGE:getHeight() * scale)))
end
