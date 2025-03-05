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
       [X] Image can be zoomed in using the 'z' key
           and zoomed out using the 'a' key
       [.] Readout implemented - a translucent panel with
           centered text written in it "pops up" on screen
           from below, remains for 3-5 seconds and then
           recedes in same manner. Does not recede if content
           changes within 3-5 seconds.
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

FONT_SIZE                   = 40
READOUT_FONT                = love.graphics.newFont(FONT_SIZE)
MAX_TIMER_VALUE             = 300

x,      y                   = 0, 0
scale                       = 1

readoutMsg                  = nil
readoutTimer                = 0
readoutYOffset              = 70

--[[
          Aspects of Timer:

          printToReadout() sets timer to max value
          drawReadout()    draws readout if timer is > 0
          updateReadout()  decreases timer (minimum value is 0)
--]]

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
    drawImage()
    drawReadout()
end

-- Function Name: love.update()
-- Called By:     LOVE2D application, every single frame
-- Parameters:    dt - time lapsed between update calls
--                     (in fractions of a second)
--------------------------------------------------------------
function love.update(dt)
    updateScrolling(dt)
    updateZooming(dt)
    updateReadout(dt)
end

-- Function Name: love.keypressed()
-- Called By:     LOVE2D application, when any key is pressed
-- Parameters:    key - text value of key pressed by the user
--------------------------------------------------------------
function love.keypressed(key)
    handleScrollKeypressed(key)
    handleZoomKeypressed(key)
end

-- Function Name: love.keyreleased()
-- Called By:     LOVE2D application, when any key is released
-- Parameters:    key - text value of key released by the user
--------------------------------------------------------------
function love.keyreleased(key)
    handleScrollKeyreleased(key)
    handleZoomKeyreleased(key)
end

-- Function Name: love.mousepressed()
-- Called By:     LOVE2D application, when mouse button is pressed
-- Parameters:    mx - x coordinate of mouse
--                my - y coordinate of mouse
--------------------------------------------------------------
function love.mousepressed(mx, my)
     printToReadout("Mouse clicked at (" .. mx .. ", " .. my .. ")")
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

---------------------------- IMAGE -------------------------------

function drawImage()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(IMAGE, x * scale, y * scale, 0, scale, scale)
end

function keepImageInBounds()
    x = math.min(0, math.max(x, (WINDOW_WIDTH  / scale) - IMAGE:getWidth()))
    y = math.min(0, math.max(y, (WINDOW_HEIGHT / scale) - IMAGE:getHeight()))
end

--------------------------- READOUT ------------------------------

function printToReadout(msg)
    print("Printing to readout: ", msg)
    readoutMsg = msg
    readoutTimer = MAX_TIMER_VALUE
end

function drawReadout()
    if readoutMsg ~= nil and readoutTimer > 0 then
        --[[
            Value of readoutYOffset over time:
            At MAX_TIMER_VALUE      : 70
            At MAX_TIMER_VALUE - 30 :  0
            At 30                   :  0
            At 0                    : 70
        --]]

        if readoutTimer >= MAX_TIMER_VALUE - 30 then
            readoutYOffset = 70 - (70 / 30 * (MAX_TIMER_VALUE - readoutTimer))
        elseif readoutTimer <= 30 then
            readoutYOffset = 70 - (70 / 30 * readoutTimer)
        end

        drawReadoutBox()
        drawReadoutMessage()
    end
end

function drawReadoutBox()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0,  WINDOW_HEIGHT - 70 + readoutYOffset, WINDOW_WIDTH, 70)
              
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0,  WINDOW_HEIGHT - 70 + readoutYOffset, WINDOW_WIDTH, 70)
end

function drawReadoutMessage()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(READOUT_FONT)
    love.graphics.printf(readoutMsg, 0, WINDOW_HEIGHT - 60 + readoutYOffset, WINDOW_WIDTH, "center")
end

function updateReadout(dt)
    readoutTimer = math.max(0, readoutTimer - (60 * dt))
end
