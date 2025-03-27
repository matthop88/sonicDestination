local MARGIN_BACKGROUND_COLOR = { r = 0.05, g = 0.28, b = 0.03 }
local SPRITE_BACKGROUND_COLOR = { r = 0.26, g = 0.60, b = 0.19 }

local SPRITE_RECTS = require("tools/spriteSheetSlicer/spriteRects")

local createPixelProcessor = function()
    local prevColor, leftX = nil, nil

    local processEnteringLeftOfSprite = function(x, y, thisColor)
        if enteringLeftOfSprite(prevColor, thisColor) then
            local hasValidLeftBorder = colorsMatch(thisColor, SPRITE_BACKGROUND_COLOR)
            SPRITE_RECTS:addSlice(x, y, hasValidLeftBorder)
            leftX = x
        end
    end

    local processExitingRightOfSprite = function(x, y, thisColor)
        if exitingRightOfSprite(prevColor, thisColor) then
            SPRITE_RECTS:updateSpriteWidth(leftX, y, x)
            leftX = nil
        end
    end

    local doPixelProcessing = function(x, y, thisColor)
        processEnteringLeftOfSprite(x, y, thisColor)
        processExitingRightOfSprite(x, y, thisColor)
    end

    return function(x, y, thisColor)
        if x == 0 then 
            prevColor, leftX = nil, nil 
        end
        doPixelProcessing(x, y, thisColor)
        prevColor = thisColor
    end
end

local enteringLeftOfSprite = function(prevColor, thisColor)
    return  colorsMatch(prevColor, MARGIN_BACKGROUND_COLOR)
    and not colorsMatch(thisColor, MARGIN_BACKGROUND_COLOR)
end

local exitingRightOfSprite = function(prevColor, thisColor)
    return not colorsMatch(prevColor, MARGIN_BACKGROUND_COLOR)
           and colorsMatch(thisColor, MARGIN_BACKGROUND_COLOR)
end

local processPixelAt = createPixelProcessor()

local colorsMatch = function(c1, c2)
    return c1 ~= nil and c2 ~= nil
       and math.abs(c1.r - c2.r) < 0.005
       and math.abs(c1.g - c2.g) < 0.005 
       and math.abs(c1.b - c2.b) < 0.005
end

return {
    slice = function(self)
        local widthInPixels, heightInPixels = getImageViewer():getImageSize()    
        
        self:doSlicing(widthInPixels, heightInPixels)

        print(ASCII_ART)

        return SPRITE_RECTS:getWalkableRectList()
    end,

    doSlicing = function(self, pixWidth, pixHeight)
        for y = 0, pixHeight - 1 do
            for x = 0, pixWidth - 1 do
                self:doSlicingAt(x, y)
            end
        end
    end,

    doSlicingAt = function(self, x, y)
        local pixelColor = getImageViewer():getPixelColorAt(x, y)
        processPixelAt(x, y, pixelColor)
    end,
}
