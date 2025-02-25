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

IMAGE = love.graphics.newImage("game/resources/images/spriteSheets/sonic1.png")
        -- https://www.spriters-resource.com/sega_genesis_32x/sonicth1/sheet/21628/

x = 0
y = 0

SCROLL_SPEED = 200
X_SPEED = 0
Y_SPEED = 0

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
     x = x + (X_SPEED * dt)
     y = y + (Y_SPEED * dt)
end

-- Function Name: love.keypressed()
-- Called By:     LOVE2D application, when any key is pressed
-- Parameters:    key - text value of key pressed by the user
--------------------------------------------------------------
function love.keypressed(key)
     if key == "left" then
          scrollLeft()
     elseif key == "right" then
          scrollRight()
     elseif key == "up" then
          scrollUp()
     elseif key == "down" then
          scrollDown()
     end
end

-- Function Name: love.keyreleased()
-- Called By:     LOVE2D application, when any key is released
-- Parameters:    key - text value of key released by the user
--------------------------------------------------------------
function love.keyreleased(key)
     if key == "left" then
          X_SPEED = 0
     elseif key == "right" then
          X_SPEED = 0
     elseif key == "up" then
          Y_SPEED = 0
     elseif key == "down" then
          Y_SPEED = 0
     end
end

-- ...

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function scrollLeft()
     X_SPEED =  SCROLL_SPEED
     Y_SPEED =  0
end

function scrollRight()
     X_SPEED = -SCROLL_SPEED
     Y_SPEED =  0
end

function scrollUp()
     Y_SPEED =  SCROLL_SPEED
     X_SPEED =  0
end

function scrollDown()
     Y_SPEED = -SCROLL_SPEED
     X_SPEED =  0
end




































showMessage = false

if showMessage then
     oldKeypressed = love.keypressed
     oldDraw = love.draw
     oldUpdate = love.update

     alpha = 0

     alphaDelta = -1
     
     msg  = ""
     font = love.graphics.newFont(80)

     function love.keypressed(key)
          oldKeypressed(key)
          createMessageFromKey(key)
          if msg ~= "" then 
               alphaDelta = 1
          end
     end

     function love.draw()
          oldDraw()

          love.graphics.setFont(font)
          love.graphics.setColor(1, 1, 1, math.min(1, alpha))
          love.graphics.printf(msg, 0, 500, 800, "center")
          love.graphics.setColor(1, 1, 1)
     end

     function love.update(dt)
          if oldUpdate then oldUpdate(dt) end

          alpha = alpha + (alphaDelta * dt)

          if alpha > 1.5 then 
               alpha = 1.5
               alphaDelta = -1
          elseif alpha < 0 then 
               alpha = 0
          end

     end

     function createMessageFromKey(key)
          if     key == "left"  then msg = "Left Key Pressed"
          elseif key == "right" then msg = "Right Key Pressed"
          elseif key == "up"    then msg = "Up Key Pressed"
          elseif key == "down"  then msg = "Down Key Pressed"
          else
               if key == "lgui" or key == "rgui" or love.keyboard.isDown("lgui", "rgui") then
                    msg = ""
               else
                    msg = "Key Pressed: " .. key
               end
          end
     end 
end
