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
       [.] Image can be scrolled using the up, down,
           left and right arrow keys.
       [ ] Image can be zoomed in using the 'z' key
           and zoomed out using the 'a' key
       [ ] Clicking on any pixel of the image prints
           an RGB description of the color both to
           the screen and to the text console.

--]]

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

if __INSPECTOR_FILE ~= nil then
    IMAGE = love.graphics.newImage("resources/images/spriteSheets/" .. __INSPECTOR_FILE .. ".png")
else
    IMAGE = love.graphics.newImage("resources/images/sadNoFileImage.png")
end

TIME_OVER_IMAGE             = love.graphics.newImage("resources/images/spriteSheets/timeOverSheet.png")
TIME_OVER_QUAD              = love.graphics.newQuad(474, 431, 138, 16, TIME_OVER_IMAGE:getWidth(), TIME_OVER_IMAGE:getHeight())

SCROLL_SPEED                = 400
WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600
DOUBLE_TAP_THRESHOLD        = 0.2

x,      y                   = 0, 0
xSpeed, ySpeed              = 0, 0

lastKeypressed              = nil
lastKeypressedTime          = 0
dashing                     = false

showTimeOver                = false

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
    love.graphics.draw(IMAGE, x, y)
    if showTimeOver then
        love.graphics.draw(TIME_OVER_IMAGE, TIME_OVER_QUAD, 55, 260, 0, 5, 5)
    end
end

-- Function Name: love.update()
-- Called By:     LOVE2D application, every single frame
-- Parameters:    dt - time lapsed between update calls
--                     (in fractions of a second)
--------------------------------------------------------------
function love.update(dt)
    x = x + (xSpeed * dt)
    y = y + (ySpeed * dt)

    normalizeImage()
end

-- Function Name: love.keypressed()
-- Called By:     LOVE2D application, when any key is pressed
-- Parameters:    key - text value of key pressed by the user
--------------------------------------------------------------
function love.keypressed(key)
    handleKeypressed(key)
    if key == "space" then
        showTimeOver = not showTimeOver
    end
end

-- Function Name: love.keyreleased()
-- Called By:     LOVE2D application, when any key is released
-- Parameters:    key - text value of key released by the user
--------------------------------------------------------------
function love.keyreleased(key)
    if     key == "left"  then stopScrollingLeft()
    elseif key == "right" then stopScrollingRight()
    elseif key == "up"    then stopScrollingUp()
    elseif key == "down"  then stopScrollingDown()
    end
  
    normalizeImage()
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function handleKeypressed(key)
    dashing = isDoubleTap(key)
    handleDirectionalKeypressed(key)
    lastKeypressed     = key 
    lastKeypressedTime = love.timer.getTime()
end

function isDoubleTap(key)
    return lastKeypressed == key and getTimeElapsedSinceLastKeypress() < DOUBLE_TAP_THRESHOLD
end

function getTimeElapsedSinceLastKeypress()
    return love.timer.getTime() - lastKeypressedTime
end

function handleDirectionalKeypressed(key)
    if     key == "left"   then scrollLeft()
    elseif key == "right"  then scrollRight()
    elseif key == "up"     then scrollUp()
    elseif key == "down"   then scrollDown()
    end
end
  
function scrollLeft()         xSpeed =   calculateScrollSpeed()  end
function scrollRight()        xSpeed = -(calculateScrollSpeed()) end  
function scrollUp()           ySpeed =   calculateScrollSpeed()  end
function scrollDown()         ySpeed = -(calculateScrollSpeed()) end
  
function stopScrollingLeft()  xSpeed = math.min(0, xSpeed)       end
function stopScrollingRight() xSpeed = math.max(0, xSpeed)       end
function stopScrollingUp()    ySpeed = math.min(0, ySpeed)       end
function stopScrollingDown()  ySpeed = math.max(0, ySpeed)       end

function calculateScrollSpeed()
    if dashing then return SCROLL_SPEED * 2
    else            return SCROLL_SPEED
    end
end

function normalizeImage()
    if getTimeElapsedSinceLastKeypress() >= DOUBLE_TAP_THRESHOLD and xSpeed == 0 and ySpeed == 0 then
        keepImageInBounds()
    end
end

function keepImageInBounds()
    x = math.min(0, math.max(x, WINDOW_WIDTH  - IMAGE:getWidth()))
    y = math.min(0, math.max(y, WINDOW_HEIGHT - IMAGE:getHeight()))
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





