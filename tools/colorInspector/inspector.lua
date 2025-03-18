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
       [X] Readout implemented - a translucent panel with
           centered text written in it "pops up" on screen
           from below, remains for 3-5 seconds and then
           recedes in same manner. Does not recede if content
           changes within 3-5 seconds.
       [X] Clicking on any pixel of the image prints
           an RGB description of the color both to
           the screen and to the text console.
       [X] Clicking on any pixel of the image draws a solid
           rectangular block of the selected color at the
           mouse position.
       [X] Palette (2 x 9 grid) is displayed on right side of screen
           - Palette is transparent until mouse enters it
           - Any time a color is selected, it is added to palette
           - Palette contains no duplicate colors
           - Colors can be selected from palette as well
           - If clicking on image color already existing in palette, 
             corresponding color in palette is highlighted
       
--]]

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600

--------------------------------------------------------------
--                     External Libraries                   --
--------------------------------------------------------------

require "tools/colorInspector/scrolling"
require "tools/colorInspector/zooming"
require "tools/colorInspector/readout"
require "tools/colorInspector/image"
require "tools/colorInspector/selectColor"
require "tools/colorInspector/palette"

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
    IMAGE_VIEWER:draw()
    PALETTE:draw()
    SELECTED_COLOR:draw()
    READOUT:draw()
end

-- Function Name: love.update()
-- Called By:     LOVE2D application, every single frame
--------------------------------------------------------------
function love.update(dt)
    SCROLLING:update(dt)
    ZOOMING:update(dt)
    IMAGE_VIEWER:update(dt)
    READOUT:update(dt)
end

-- Function Name: love.keypressed()
-- Called By:     LOVE2D application, when any key is pressed
--------------------------------------------------------------
function love.keypressed(key)
    SCROLLING:handleKeypressed(key)
    ZOOMING:handleKeypressed(key)
end

-- Function Name: love.keyreleased()
-- Called By:     LOVE2D application, when any key is released
--------------------------------------------------------------
function love.keyreleased(key)
    SCROLLING:handleKeyreleased(key)
    ZOOMING:handleKeyreleased(key)
end

-- Function Name: love.mousepressed()
-- Called By:     LOVE2D application, when mouse button is pressed
--------------------------------------------------------------
function love.mousepressed(mx, my)
    if PALETTE:isInFocus() then PALETTE:selectColorAt(mx, my)
    else                        SELECTED_COLOR:selectFromImageAt(mx, my)
    end
    
    PALETTE:insertColor(SELECTED_COLOR:get())
end

-- Function Name: love.mousereleased()
-- Called By:     LOVE2D application, when mouse button is released
--------------------------------------------------------------
function love.mousereleased(mx, my)
    SELECTED_COLOR:clear()
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

-- ...
-- ...
-- ...


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
