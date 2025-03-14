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
       [.] Clicking on any pixel of the image prints
           an RGB description of the color both to
           the screen and to the text console.

--]]

require "tools/colorInspector/scrolling"
require "tools/colorInspector/zooming"
require "tools/colorInspector/readout"

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

if __INSPECTOR_FILE ~= nil then
    IMAGE_DATA = love.image.newImageData("resources/images/spriteSheets/" .. __INSPECTOR_FILE .. ".png")
else
    IMAGE_DATA = love.image.newImageData("resources/images/sadNoFileImage.png")
end

IMAGE = love.graphics.newImage(IMAGE_DATA)

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
    identifyColor(mx, my)
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

---------------------------- COLOR -------------------------------

function identifyColor(mx, my)
    local imageX = math.min(IMAGE_DATA:getWidth(),  math.floor((mx / scale) - x))
    local imageY = math.min(IMAGE_DATA:getHeight(), math.floor((my / scale) - y))
    
    local r, g, b = IMAGE_DATA:getPixel(imageX, imageY)
    print(string.format("{ %.2f, %.2f, %.2f }", r, g, b))
  
    r, g, b = love.math.colorToBytes(r, g, b)
    printToReadout("R = " .. r .. ", G = " .. g .. ", B = " .. b)
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
