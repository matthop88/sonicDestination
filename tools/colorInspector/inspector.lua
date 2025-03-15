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
       [.] Palette (2 x 9 grid) is displayed on right side of screen
           - Palette is transparent until mouse enters it
           - Any time a color is selected, it is added to palette
           - Palette contains no duplicate colors
           - Colors can be selected from palette as well
           - If clicking on image color already existing in palette, 
             corresponding color in palette is highlighted
       
--]]

require "tools/colorInspector/scrolling"
require "tools/colorInspector/zooming"
require "tools/colorInspector/readout"
require "tools/colorInspector/image"
require "tools/colorInspector/selectColor"
require "tools/colorInspector/color"

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
    drawPalette()
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
    if isPaletteInFocus then
        selectPaletteColorAt(mx, my)
    else
        selectImageColorAt(mx, my)
    end
    insertColorIntoPalette(getSelectedColor())
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

--------------------------- PALETTE --------------------------

PALETTE      = { }
PALETTE_LEFT = WINDOW_WIDTH - 134

isPaletteInFocus = false

function drawPalette()
    local mx, my = love.mouse.getPosition()
   
    isPaletteInFocus = mx >= PALETTE_LEFT
    
    drawPaletteGrid()
    drawPaletteColors()
end

function drawPaletteGrid()
    love.graphics.setColor(calculatePaletteGridColor())
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", PALETTE_LEFT, 3, 132, WINDOW_HEIGHT - 6)
    drawPaletteGridLines()
end

function calculatePaletteGridColor()
    if isPaletteInFocus then
        return COLOR.MEDIUM_GREY
    else
        return COLOR.TRANSPARENT_WHITE
    end
end

function drawPaletteGridLines()
    for i = 0, 8 do
        love.graphics.rectangle("line", PALETTE_LEFT,      (i * 66) + 3, 66, 66)
        love.graphics.rectangle("line", WINDOW_WIDTH - 68, (i * 66) + 3, 66, 66)
    end
end

function drawPaletteColors()
    for colorIndex, color in ipairs(PALETTE) do
        love.graphics.setColor(calculatePaletteColorToDraw(color))
        local x, y = calculateCoordinatesOfPaletteColor(colorIndex)
        love.graphics.rectangle("fill", x, y, 60, 60)
    end
end

function calculatePaletteColorToDraw(baseColor)
    if isPaletteInFocus or baseColor == getSelectedColor() then
        return baseColor
    else
        return { baseColor[1], baseColor[2], baseColor[3], 0.5 }
    end
end

function calculateCoordinatesOfPaletteColor(colorIndex)
    local column = (colorIndex - 1) % 2
    local row    = math.floor((colorIndex - 1) / 2)

    local x = PALETTE_LEFT + (column * 66) + 3
    local y =                (row    * 66) + 6

    return x, y
end

function insertColorIntoPalette(color)
    if not colorBelongsToPalette(color) then
        table.insert(PALETTE, color)
    end
end

function colorBelongsToPalette(color)
    for _, c in ipairs(PALETTE) do
        if c[1] == color[1] and c[2] == color[2] and c[3] == color[3] then
            return true
        end
    end
end

function selectPaletteColorAt(mx, my)
    -- Temporary hack to prevent program from crashing
    selectImageColorAt(0, 0)
    local hIndex = math.floor((mx - PALETTE_LEFT) / 68)
    local vIndex = math.floor((my - 3           ) / 66)
    print("H Index = " .. hIndex .. ", V Index = " .. vIndex)
    local selectedIndex = vIndex * 2 + hIndex + 1
    print("Selected Index: " .. selectedIndex)
    if PALETTE[selectedIndex] then
        setSelectedColor(PALETTE[selectedIndex])
	end
end

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
