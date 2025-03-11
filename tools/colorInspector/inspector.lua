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

if __INSPECTOR_FILE ~= nil then
    IMAGE = love.graphics.newImage("resources/images/spriteSheets/" .. __INSPECTOR_FILE .. ".png")
else
    IMAGE = love.graphics.newImage("resources/images/sadNoFileImage.png")
end

WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600

x,      y                   = 0, 0
scale                       = 1

--[[
    Aspects of Timer:

    printToReadout() sets timer to 0
    drawReadout()    draws readout if timer is non-nil
    updateReadout()  increases timer. If timer passes MAX_TIMER_VALUE,
                                      timer is set to nil.
--]]

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Color Inspector")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

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
    updateImage()
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

function updateImage()
    if isMotionless() then keepImageInBounds() end
end

function keepImageInBounds()
    x = math.min(0, math.max(x, (WINDOW_WIDTH  / scale) - IMAGE:getWidth()))
    y = math.min(0, math.max(y, (WINDOW_HEIGHT / scale) - IMAGE:getHeight()))
end

--------------------------- READOUT ------------------------------

FONT_SIZE         = 40
READOUT_FONT      = love.graphics.newFont(FONT_SIZE)
READOUT_SUSTAIN   = 180
READOUT_ATTACK    = 10
READOUT_DECAY     = 30
READOUT_DURATION  = READOUT_SUSTAIN + READOUT_ATTACK + READOUT_DECAY
READOUT_AMPLITUDE = 140
READOUT_HEIGHT    = 70

readoutMsg        = nil
readoutTimer      = READOUT_DURATION
readoutYOffset    = 20

function drawReadout()
    if readoutMsg ~= nil and readoutTimer ~= nil then
        drawReadoutBox()
        drawReadoutMessage()
    end
end

function drawReadoutBox()
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0,  WINDOW_HEIGHT - readoutYOffset, WINDOW_WIDTH, READOUT_HEIGHT)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 0,  WINDOW_HEIGHT - readoutYOffset, WINDOW_WIDTH, READOUT_HEIGHT) 
end

function drawReadoutMessage()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(READOUT_FONT)
    love.graphics.printf(readoutMsg, 0, WINDOW_HEIGHT - readoutYOffset + 10, WINDOW_WIDTH, "center")
end

function updateReadout(dt)
    if isReadoutActive() then
        readoutTimer = readoutTimer + (60 * dt)
    end
    --[[
        Value of readoutYOffset over time:
        At 0                                : 0
        At READOUT_ATTACK                   : READOUT_AMPLITUDE
        At READOUT_DURATION - READOUT_DECAY : READOUT_AMPLITUDE
        At READOUT_DURATION                 : 0
    --]]
    if     isReadoutAttacking() then
        readoutYOffset = calculateAttackingYOffset()
    elseif isReadoutDecaying()  then
        readoutYOffset = calculateDecayingYOffset()
    else
        readoutYOffset = calculateSustainingYOffset()  
    end
end

function isReadoutActive()
    return readoutTimer < READOUT_DURATION
end

function isReadoutAttacking()
    return readoutTimer <= READOUT_ATTACK
end

function calculateAttackingYOffset()
    return readoutTimer * READOUT_AMPLITUDE / READOUT_ATTACK
end

function isReadoutDecaying()
    return getTimeRemaining() <= READOUT_DECAY
end

function getTimeRemaining()
    return READOUT_DURATION - readoutTimer
end

function calculateDecayingYOffset()
    return getTimeRemaining() * READOUT_AMPLITUDE / READOUT_DECAY
end

function calculateSustainingYOffset()
    return READOUT_AMPLITUDE
end

function printToReadout(msg)
    readoutMsg   = msg
    readoutTimer = 0
    print("Printing to readout: ", msg)
end
















--[[

          *************     ******************    ******************           *****           
      *****************   ********************  ********************         **********      
     ******              ******                *****                        ************            
    ****   ************  ***** *************** **** ****************       *****   ******           
   ****  **************  ***** *************** **** ****************      *****  ** *****           
   **** ****             ***** ***             **** ****                  ***** ***  *****          
    ***  **********      ***** *************   **** **** ***********     ***** ***** ******         
     ****    ********    ***** *************   **** **** ***********    ****** ****** *****         
      *******     ****   ***** *************   **** **** ****** ****    ***** ******* ******        
        **********  ***  ***** *************   **** **** ****** ****   *****  *** **** *****        
               **** **** ***** ***             **** ****   **** ****  ****** ****  **** *****       
    **************  ***  ***** *************** **** *********** ****  ***** *********** ******      
    ************   ****  ***** *************** **** *********** **** ****** ************ *****      
                ******   ******                *****            **** ***** ***            *****     
    ****************      ********************  ************************* ***  *****************    
    *************           ******************    *********************** ***  *****************   

--]]
