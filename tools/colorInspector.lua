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

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

IMAGE                       = love.graphics.newImage("game/resources/images/spriteSheets/sonic1.png")
                              -- https://www.spriters-resource.com/sega_genesis_32x/sonicth1/sheet/21628/
SCROLL_SPEED                = 400
ZOOM_SPEED                  = 2
WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600
DOUBLE_TAP_THRESHOLD        = 0.2

x,      y                   = 0, 0
xSpeed, ySpeed              = 0, 0

lastKeypressed              = nil
lastKeypressedTime          = 0
dashing                     = false

scale                       = 1
scaleDelta                  = 0

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

------------------------- SCROLLING --------------------------

function updateScrolling(dt)
    x = x + xSpeed * dt * scale
    y = y + ySpeed * dt * scale
end

function scrollLeft()         xSpeed =    calculateScrollSpeed()  end
function scrollRight()        xSpeed = - (calculateScrollSpeed()) end          
function scrollUp()           ySpeed =    calculateScrollSpeed()  end
function scrollDown()         ySpeed = - (calculateScrollSpeed()) end

function stopScrollingLeft()  xSpeed = math.min(0, xSpeed)        end
function stopScrollingRight() xSpeed = math.max(0, xSpeed)        end
function stopScrollingUp()    ySpeed = math.min(0, ySpeed)        end
function stopScrollingDown()  ySpeed = math.max(0, ySpeed)        end

function calculateScrollSpeed()
    if dashing then return SCROLL_SPEED * 2
    else            return SCROLL_SPEED
    end
end

-------------------------- ZOOMING ---------------------------

function updateZooming(dt)
    if scaleDelta ~= 0 then
        --[[
            Adjust x and y of image so that we are zooming in at point
            the mouse is at
        --]]
        
        scale = scale + scaleDelta * dt * scale

        keepImageInBounds()
    end
end

function zoomIn()         scaleDelta =  ZOOM_SPEED end
function zoomOut()        scaleDelta = -ZOOM_SPEED end

function stopZoomingIn()  scaleDelta =  0          end
function stopZoomingOut() scaleDelta =  0          end

------------------------ MISCELLANEOUS -------------------------

function handleKeypressed(key)
    dashing = isDoubleTap(key)
    handleDirectionalKeyPressed(key)
    lastKeypressed     = key 
    lastKeypressedTime = love.timer.getTime()
end

function isDoubleTap(key)
    return lastKeypressed == key and getTimeElapsedSinceLastKeypress() < DOUBLE_TAP_THRESHOLD
end

function getTimeElapsedSinceLastKeypress()
    return love.timer.getTime() - lastKeypressedTime
end

function handleDirectionalKeyPressed(key)
    handleScrollKeypressed(key)
    handleZoomKeypressed(key)
end

function handleScrollKeypressed(key)
    if     key == "left"  then scrollLeft()
    elseif key == "right" then scrollRight()
    elseif key == "up"    then scrollUp()
    elseif key == "down"  then scrollDown()
    end
end

function handleZoomKeypressed(key)
    if     key == "z"     then zoomIn()
    elseif key == "a"     then zoomOut()
    end
end

function handleKeyreleased(key)
    if     key == "left"  then stopScrollingLeft()
    elseif key == "right" then stopScrollingRight()
    elseif key == "up"    then stopScrollingUp()
    elseif key == "down"  then stopScrollingDown()
    elseif key == "z"     then stopZoomingIn()
    elseif key == "a"     then stopZoomingOut()
    end
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

