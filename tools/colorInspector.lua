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

IMAGE          = love.graphics.newImage("resources/images/spriteSheets/sonic1.png")
                 -- https://www.spriters-resource.com/sega_genesis_32x/sonicth1/sheet/21628/
SCROLL_SPEED                = 400
WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600

x,      y                   = 0, 0
xSpeed, ySpeed              = 0, 0

lastKeypressed              = nil
lastKeypressedTime          = 0
dashing                     = false

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
end

-- Function Name: love.update()
-- Called By:     LOVE2D application, every single frame
-- Parameters:    dt - time lapsed between update calls
--                     (in fractions of a second)
--------------------------------------------------------------
function love.update(dt)
    x = x + (xSpeed * dt)
    y = y + (ySpeed * dt)
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
    if     key == "left"  then stopScrollingLeft()
    elseif key == "right" then stopScrollingRight()
    elseif key == "up"    then stopScrollingUp()
    elseif key == "down"  then stopScrollingDown()
    end
  
    keepImageInBounds()
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
    return lastKeypressed == key and getTimeElapsedSinceLastKeypress() < 0.3
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
  
function calculateScrollSpeed()
    if dashing then return SCROLL_SPEED * 2
    else            return SCROLL_SPEED
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































showMessage = false

if showMessage then
     oldKeypressed = love.keypressed
     oldKeyreleased = love.keyreleased
     oldDraw = love.draw
     oldUpdate = love.update

     keypressed  = nil
     keyreleased = nil

     keypressedTime = 0
     keyreleasedTime = 0

     keypressedAlpha  = 0
     keyreleasedAlpha = 0

     keypressedAlphaDelta  = -1
     keyreleasedAlphaDelta = -1
     
     keypressedMsg  = ""
     keyreleasedMsg = ""

     font = love.graphics.newFont(80)

     function love.keypressed(key)
          oldKeypressed(key)
          createMessageFromKeyPressed(key)
          if keypressedMsg ~= "" then 
               keypressedAlphaDelta = 1
               keyreleasedAlpha = 1.2
               keyreleasedAlphaDelta = -1
               keypressed = key
               keypressedTime = love.timer.getTime()
          end
     end

     function love.keyreleased(key)
          oldKeyreleased(key)
          createMessageFromKeyReleased(key)
          if keyreleasedMsg ~= "" then 
               if keypressed == key then
                    keypressedAlpha = 1.2
                    keypressedAlphaDelta = -1
               end
               keyreleasedAlphaDelta = 1
               keyreleased = key
               keyreleasedTime = love.timer.getTime()
          end
     end

     function love.draw()
          oldDraw()

          local keypressedY  = 500 - math.min(100, keyreleasedAlpha * 300)
          local keyreleasedY = 600 - math.min(100, keyreleasedAlpha * 300)

          if keyreleasedTime < keypressedTime then
               keypressedY  = 600 - math.min(100, keypressedAlpha * 300)
               keyreleasedY = 500 - math.min(100, keypressedAlpha * 300)
          end

          love.graphics.setFont(font)
          love.graphics.setColor(1, 1, 1, math.min(1, keypressedAlpha))
          love.graphics.printf(keypressedMsg,  0, keypressedY,  800, "center")
          love.graphics.setColor(1, 1, 1, math.min(1, keyreleasedAlpha))
          love.graphics.printf(keyreleasedMsg, 0, keyreleasedY, 800, "center")
          love.graphics.setColor(1, 1, 1)
     end

     function love.update(dt)
          if oldUpdate then oldUpdate(dt) end

          keypressedAlpha = keypressedAlpha + (keypressedAlphaDelta * dt)

          if keypressedAlpha > 1.2 then 
               keypressedAlpha = 1.2
          elseif keypressedAlpha < 0 then 
               keypressedAlpha = 0
               keypressedMsg = ""
          end

          keyreleasedAlpha = keyreleasedAlpha + (keyreleasedAlphaDelta * dt)

          if keyreleasedAlpha > 1.5 then 
               keyreleasedAlpha = 1.5
               if keypressedAlpha <= 0 then
                    keyreleasedAlphaDelta = -1
               end
          elseif keyreleasedAlpha < 0 then 
               keyreleasedAlpha = 0
               keyreleasedMsg = ""
          end

     end

     function createMessageFromKeyPressed(key)
          if     key == "left"  then keypressedMsg = "Left Key Pressed"
          elseif key == "right" then keypressedMsg = "Right Key Pressed"
          elseif key == "up"    then keypressedMsg = "Up Key Pressed"
          elseif key == "down"  then keypressedMsg = "Down Key Pressed"
          else
               if key == "lgui" or key == "rgui" or love.keyboard.isDown("lgui", "rgui") then
                    keypressedMsg = ""
               else
                    keypressedMsg = "Key Pressed: " .. key
               end
          end
     end 

     function createMessageFromKeyReleased(key)
          if     key == "left"  then keyreleasedMsg = "Left Key Released"
          elseif key == "right" then keyreleasedMsg = "Right Key Released"
          elseif key == "up"    then keyreleasedMsg = "Up Key Released"
          elseif key == "down"  then keyreleasedMsg = "Down Key Released"
          else
               if key == "lgui" or key == "rgui" or love.keyboard.isDown("lgui", "rgui") then
                    keyreleasedMsg = ""
               else
                    keyreleasedMsg = "Key Released: " .. key
               end
          end
     end 
end

