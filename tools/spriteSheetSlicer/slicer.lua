--[[

--------------------------------------------------------------
--                  Functional Specifications               --
--------------------------------------------------------------

[ ] 1. Program "automagically" finds borders of all sprites in image
[ ] 2. Border is drawn when mouse moves over a sprite
[ ] 3. When a sprite is clicked on, x, y, width and height are
       displayed on screen.

                    Border Finding Algorithm
                    ------------------------
       Scan each line of image.
       Look for edges of borders.

       Left edge:  Transition from Margin Background color
                                to Sprite Background color.

       Right edge: Transition from Sprite Background color
                                to Margin Background color.

       Same transition applies to top and bottom edges.

       Border information is captured in a data structure.

                          Prerequisites
                          -------------
       [X] Identify Margin Background color
       [X] Identify Sprite Background color

--]]

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

WINDOW_WIDTH  = 1024
WINDOW_HEIGHT = 768

--MARGIN_BACKGROUND_COLOR = { 0.05, 0.28, 0.03 }
MARGIN_BACKGROUND_COLOR   = { 0,    0,    0    }
SPRITE_BACKGROUND_COLOR   = { 0.26, 0.60, 0.19 }

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Spritesheet Slicer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

-- ...
-- ...

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.draw()
-- Called By:     LOVE2D application, every single frame
--------------------------------------------------------------
function love.draw()
    -- All drawing code goes here
end

-- ...
-- ...

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function getIMAGE_VIEWER()
    -- Overridden by imageViewer plugin
end

function scan()
    -- Scan all pixels in image in a systematic way
    -- Print out the coordinates of the first pixel in each row 
    -- that matches MARGIN_BACKGROUND_COLOR

    local imageViewer = getIMAGE_VIEWER()
    local widthInPixels, heightInPixels = imageViewer:getImageSize()

    for y = 0, heightInPixels - 1 do
        for x = 0, widthInPixels - 1 do
            local r, g, b = imageViewer:getImagePixelAt(x, y)
            if colorsMatch(r, g, b, MARGIN_BACKGROUND_COLOR) then
                print("Found MARGIN_BACKGROUND_COLOR at x =", x, "y =", y)
                break
            end
        end
    end
end

function colorsMatch(r, g, b, color)
    return r == color[1] and g == color[2] and b == color[3]
end

-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("imageViewer", "resources/images/spriteSheets/sonic1.png")
    :add("zooming")
    :add("scrolling")

--------------------------------------------------------------
--                Static code - is executed last            --
--------------------------------------------------------------

scan()
