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

SPRITE_RECTS            = require("tools/spriteSheetSlicer/spriteRects")

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Spritesheet Slicer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- ...
-- ...
-- ...

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

drawSlices = function()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(3 * getImageViewer():getScale())
    for _, rect in SPRITE_RECTS:elements() do
        love.graphics.rectangle("line", getImageViewer():imageToScreenRect(rect.x - 2, rect.y - 2, rect.w + 4, rect.h + 4))
    end
end

slice = function()
    local widthInPixels, heightInPixels = getImageViewer():getImageSize()

    for y = 0, heightInPixels - 1 do
        for x = 0, widthInPixels - 1 do
            processPixelAt(x, y)
        end
    end
end

createPixelProcessor = function()
    local prevColor = nil
    
    return function(x, y)
        -- Left edge: Transition from Margin Background color
        --                         to Sprite Background color.
    
        if x == 0 then prevColor = nil end
        
        local thisColor = getImageViewer():getPixelColorAt(x, y)
        
        if     colorsMatch(prevColor, MARGIN_BACKGROUND_COLOR)
           and colorsMatch(thisColor, SPRITE_BACKGROUND_COLOR) then
               SPRITE_RECTS:add({ x = x, y = y, w = 50, h = 1 })
        end
        prevColor = thisColor
    end
end

processPixelAt = createPixelProcessor()

colorsMatch = function(c1, c2)
    return c1 ~= nil and c2 ~= nil
       and math.abs(c1.r - c2.r) < 0.005
       and math.abs(c1.g - c2.g) < 0.005 
       and math.abs(c1.b - c2.b) < 0.005
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("imageViewer",  
    { 
        imagePath    = "resources/images/spriteSheets/sonic1.png",
        accessFnName = "getImageViewer" 
    })
    :add("zooming",      { imageViewer  = getImageViewer() })
    :add("scrolling",    { imageViewer  = getImageViewer() })
    :add("drawingLayer", { drawingFn    = drawSlices })
    :add("readout",      { accessFnName = "getReadout" })


--------------------------------------------------------------
--                Static code - is executed last            --
--------------------------------------------------------------

slice()
