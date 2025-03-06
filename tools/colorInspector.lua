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

                         Design Details
                         --------------
    Smooth Scrolling:
        Pressing an arrow key begins scrolling in the proper direction.
        Scrolling continues at a constant rate once it has begun.
        Releasing an arrow key stops scrolling in that direction.

--]]

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

IMAGE = love.graphics.newImage("resources/images/spriteSheets/sonic1.png")
        -- https://www.spriters-resource.com/sega_genesis_32x/sonicth1/sheet/21628/

SCROLL_SPEED = 200

x = 0
y = 0

xSpeed = 0
ySpeed = 0

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Color Inspector")
love.window.setMode(800, 600, { display = 2 })
-- ...

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
    -- If scrolling has begun, continue scrolling in proper direction
    -- at a constant rate.
    x = x + (xSpeed * dt)
    y = y + (ySpeed * dt)
end

-- Function Name: love.keypressed()
-- Called By:     LOVE2D application, when any key is pressed
-- Parameters:    key - text value of key pressed by the user
--------------------------------------------------------------
function love.keypressed(key)
    if     key == "left"  then scrollLeft()
    elseif key == "right" then scrollRight()
    elseif key == "up"    then scrollUp()
    elseif key == "down"  then scrollDown()
    end
end

-- Function Name: love.keyreleased()
-- Called By:     LOVE2D application, when any key is released
-- Parameters:    key - text value of key released by the user
--------------------------------------------------------------
function love.keyreleased(key)
    if key == "left" then
        stopScrollingLeft()
    elseif key == "right" then
        stopScrollingRight()
    elseif key == "up" then
        stopScrollingUp()
    elseif key == "down" then
        stopScrollingDown()
    end
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function scrollLeft()
    xSpeed =  SCROLL_SPEED
    ySpeed =  0
end

function scrollRight()
    xSpeed = -SCROLL_SPEED
    ySpeed =  0
end

function scrollUp()
    ySpeed =  SCROLL_SPEED
    xSpeed =  0
end

function scrollDown()
    ySpeed = -SCROLL_SPEED
    xSpeed =  0
end

function stopScrollingLeft()
    if xSpeed > 0 then
        xSpeed = 0
    end
end

function stopScrollingRight()
    if xSpeed < 0 then
        xSpeed = 0
    end
end

function stopScrollingUp()
    if ySpeed > 0 then
        ySpeed = 0
    end
end

function stopScrollingDown()
    if ySpeed < 0 then
        ySpeed = 0
    end
end




































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
