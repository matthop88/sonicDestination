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

--]]

require "tools/colorInspector/scrolling"
require "tools/colorInspector/zooming"
require "tools/colorInspector/readout"
require "tools/colorInspector/image"
require "tools/colorInspector/selectColor"

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600

x,      y                   = 0, 0
scale                       = 1

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
    drawSelectedColor()
    drawReadout()
end

-- Function Name: love.update()
-- Called By:     LOVE2D application, every single frame
--------------------------------------------------------------
function love.update(dt)
    updateScrolling(dt)
    updateZooming(dt)
    updateImage()
    updateReadout(dt)
end

-- Function Name: love.keypressed()
-- Called By:     LOVE2D application, when any key is pressed
--------------------------------------------------------------
function love.keypressed(key)
    handleScrollKeypressed(key)
    handleZoomKeypressed(key)
end

-- Function Name: love.keyreleased()
-- Called By:     LOVE2D application, when any key is released
--------------------------------------------------------------
function love.keyreleased(key)
    handleScrollKeyreleased(key)
    handleZoomKeyreleased(key)
end

-- Function Name: love.mousepressed()
-- Called By:     LOVE2D application, when mouse button is pressed
--------------------------------------------------------------
function love.mousepressed(mx, my)
    selectColorAt(mx, my)
end

-- Function Name: love.mousereleased()
-- Called By:     LOVE2D application, when mouse button is released
--------------------------------------------------------------
function love.mousereleased(mx, my)
    clearSelectedColor()
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
