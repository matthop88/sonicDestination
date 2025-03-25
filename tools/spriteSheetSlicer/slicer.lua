--[[

--------------------------------------------------------------
--                  Functional Specifications               --
--------------------------------------------------------------

[ ] 1. Program "automagically" finds borders of all sprites in image
[ ] 2. Border is drawn when mouse moves over a sprite
[ ] 3. When a sprite is clicked on, x, y, width and height are
       displayed on screen.

--]]

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

WINDOW_WIDTH  = 1024
WINDOW_HEIGHT = 768

MARGIN_BACKGROUND_COLOR = { r = 0.05, g = 0.28, b = 0.03 }
SPRITE_BACKGROUND_COLOR = { r = 0.26, g = 0.60, b = 0.19 }

SPRITE_RECTS            = { }

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

function drawSlices()
    love.graphics.setColor(1, 1, 1)
    for _, spriteRect in ipairs(SPRITE_RECTS) do
        local x, y = getIMAGE_VIEWER():imageToScreenCoordinates(spriteRect.x, spriteRect.y)
        love.graphics.rectangle("line", x - 5, y, 5, 1)
    end
end

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
            local pixelColor = imageViewer:getPixelColorAt(x, y)
            if colorsMatch(pixelColor, MARGIN_BACKGROUND_COLOR) then
                print("Found MARGIN_BACKGROUND_COLOR at x =", x, "y =", y)
                break
            end
        end
    end
end

function colorsMatch(c1, c2)
    return c1 ~= nil and c2 ~= nil
       and math.abs(c1.r - c2.r) < 0.005
       and math.abs(c1.g - c2.g) < 0.005 
       and math.abs(c1.b - c2.b) < 0.005
end

function slice()
    local imageViewer = getIMAGE_VIEWER()
    local widthInPixels, heightInPixels = imageViewer:getImageSize()
    
    local colorData = { }
    for y = 0, heightInPixels - 1 do
        for x = 0, widthInPixels - 1 do
            processPixelAt(x, y, colorData)
        end
    end
    
    --[[
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
end

function processPixelAt(x, y, colorData)
    -- Left edge: Transition from Margin Background color
    --                         to Sprite Background color.

    if x == 0 then
        colorData.prevColor = nil
    end
    
    colorData.thisColor = getIMAGE_VIEWER():getPixelColorAt(x, y)
    if colorsMatch(colorData.prevColor, MARGIN_BACKGROUND_COLOR) and
       colorsMatch(colorData.thisColor, SPRITE_BACKGROUND_COLOR) then
        table.insert(SPRITE_RECTS, { x = x, y = y, w = 100, h = 100 })
    end
    colorData.prevColor = colorData.thisColor
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("imageViewer",  "resources/images/spriteSheets/sonic1.png")
    :add("zooming")
    :add("scrolling")
    :add("drawingLayer", drawSlices)

--------------------------------------------------------------
--                Static code - is executed last            --
--------------------------------------------------------------

slice()
