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
       [.] Clicking on any pixel of the image draws a solid
           rectangular block of the selected color at the
           mouse position.

--]]

require "tools/colorInspector/scrolling"
require "tools/colorInspector/zooming"
require "tools/colorInspector/readout"
require "tools/colorInspector/color"
require "tools/colorInspector/image"

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600

x,      y                   = 0, 0
scale                       = 1

selectedColor               = nil

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
    selectedColor = identifyColor(mx, my)
end

-- Function Name: love.mousereleased()
-- Called By:     LOVE2D application, when mouse button is released
-- Parameters:    mx - x coordinate of mouse
--                my - y coordinate of mouse
--------------------------------------------------------------
function love.mousereleased(mx, my)
     selectedColor = nil
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

---------------------------- COLOR -------------------------------

function identifyColor(mx, my)
    local imageX = math.min(getImageWidth(),  math.floor((mx / scale) - x))
    local imageY = math.min(getImageHeight(), math.floor((my / scale) - y))
    
    local r, g, b = getImagePixelAt(imageX, imageY)
    
    print(string.format("{ %.2f, %.2f, %.2f }", r, g, b))
    printToReadout(string.format("R = %s, G = %s, B = %s", love.math.colorToBytes(r, g, b)))

    return { r, g, b }
end

function drawSelectedColor()
    if selectedColor ~= nil then
        local mx, my = love.mouse.getPosition()
        love.graphics.setColor(selectedColor)
        love.graphics.rectangle("fill", mx - 50, my - 50, 100, 100)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(COLOR.JET_BLACK)
        love.graphics.rectangle("line", mx - 50, my - 50, 100, 100)
    end
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
