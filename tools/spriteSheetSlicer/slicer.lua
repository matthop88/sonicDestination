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

SPRITE_RECTS            = { 
    add = function(self, rect)
        local adjacentRect = self:findAdjacentRect(rect.x, rect.y)
        if adjacentRect == nil then
            self:addNewRect(rect)
        else
            adjacentRect.h = adjacentRect.h + 1
        end
    end,

    findAdjacentRect = function(self, x, y)
        for _, rect in ipairs(self:getRectsWithLeftX(x)) do
            if rect.y + rect.h == y then
                return rect
            end
        end
    end,

    addNewRect = function(self, rect)
        table.insert(self:getRectsWithLeftX(rect.x), rect)
    end,

    getRectsWithLeftX = function(self, x)
        if self[x] == nil then self[x] = {} end
        return self[x]
    end,

    getWalkableRectList = function(self)
        self.walkableList = self.walkableList or self:createWalkableList()
        return self.walkableList
    end,

    createWalkableList = function(self)
        local list = {}

        for _, spriteRects in pairs(self) do
            if type(spriteRects) ~= "function" then
                for _, spriteRect in ipairs(spriteRects) do
                    table.insert(list, spriteRect)
                end
            end
        end

        return list
    end,
}

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

drawSlices = function()
    love.graphics.setColor(1, 1, 1)
    for _, spriteRect in pairs(SPRITE_RECTS:getWalkableRectList()) do
        local x, y = getIMAGE_VIEWER():imageToScreenCoordinates(spriteRect.x, spriteRect.y)
        local w    = spriteRect.w * getIMAGE_VIEWER():getScale()
        local h    = spriteRect.h * getIMAGE_VIEWER():getScale()
        love.graphics.rectangle("line", x, y, w, h))
    end
end

getIMAGE_VIEWER = function()
    -- Overridden by imageViewer plugin
end

slice = function()
    local widthInPixels, heightInPixels = getIMAGE_VIEWER():getImageSize()

    for y = 0, heightInPixels - 1 do
        for x = 0, widthInPixels - 1 do
            processPixelAt(x, y)
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

createPixelProcessor = function()
    local prevColor = nil
    
    return function(x, y)
        -- Left edge: Transition from Margin Background color
        --                         to Sprite Background color.
    
        if x == 0 then prevColor = nil end
        
        local thisColor = getIMAGE_VIEWER():getPixelColorAt(x, y)
        
        if     colorsMatch(prevColor, MARGIN_BACKGROUND_COLOR)
           and colorsMatch(thisColor, SPRITE_BACKGROUND_COLOR) then
               SPRITE_RECTS:add({ x = x, y = y, w = 100, h = 1 })
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
    :add("imageViewer",  "resources/images/spriteSheets/sonic1.png")
    :add("zooming")
    :add("scrolling")
    :add("drawingLayer", drawSlices)

--------------------------------------------------------------
--                Static code - is executed last            --
--------------------------------------------------------------

slice()
