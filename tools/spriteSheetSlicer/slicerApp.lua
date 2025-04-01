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

--]]

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

--MARGIN_BACKGROUND_COLOR = { 0.05, 0.28, 0.03 }
MARGIN_BACKGROUND_COLOR = { 0,    0,    0    }
SPRITE_BACKGROUND_COLOR = { 0.26, 0.60, 0.19 }

WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 768

scanY = 0

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Sprite Sheet Slicer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })
-- ...

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.draw()
-- Called By:	  LOVE2D application, every single frame
--------------------------------------------------------------
function love.draw()
    -- All drawing code goes here
end

function love.update(dt)
    scanner:scan(scanY)
    scanY = scanY + 1
end

-- ...

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function getImageViewer()
    -- Overridden by imageViewer plugin
end

local scanner = {
    scan = function(self, y)
        -- Scan all pixels in image pixel row in a systematic way
        -- Print out the coordinates of every pixel
        -- that matches MARGIN_BACKGROUND_COLOR
    
        local imageViewer                   = getImageViewer()
        local widthInPixels, heightInPixels = imageViewer:getImageSize()
        
        if y < heightInPixels then
            for x = 0, widthInPixels - 1 do
                local r, g, b = imageViewer:getImagePixelAt(x, y)
                if  r == MARGIN_BACKGROUND_COLOR[1]
                and g == MARGIN_BACKGROUND_COLOR[2]
                and b == MARGIN_BACKGROUND_COLOR[3] then
                    print("Found MARGIN_BACKGROUND_COLOR at x = " .. x .. ", y = " .. y)
                end
            end
        end
    end
}

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("imageViewer",
    {
        imagePath      = "resources/images/spriteSheets/sonic1.png",
        accessorFnName = "getImageViewer"
    })
    :add("zooming",   { imageViewer = getImageViewer() })
    :add("scrolling", { imageViewer = getImageViewer() })
