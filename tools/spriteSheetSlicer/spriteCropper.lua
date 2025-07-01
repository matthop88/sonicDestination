local SPRITE_BG_COLOR
local IMAGE_VIEWER

local thisColor, prevColor

local isCloseEnoughMatch = function(c1, c2)
    return  c1 ~= nil
        and c2 ~= nil
        and math.abs(c1.r - c2.r) < 0.005
        and math.abs(c1.g - c2.g) < 0.005
        and math.abs(c1.b - c2.b) < 0.005
        and math.abs(c1.a - c2.a) < 0.005
end

return {
    init = function(self, imageViewer, spriteBGColor)
        IMAGE_VIEWER    = imageViewer
        SPRITE_BG_COLOR = spriteBGColor

        return self
    end,

    crop = function(self, spriteRects)
        for _, spriteRect in spriteRects:elements() do
            self:cropSpriteRect(spriteRect)
        end
    end,

    cropSpriteRect = function(self, spriteRect)
        local bounds = { minX = nil, maxX = nil, minY = nil, maxY = nil }
        for y = spriteRect.y, spriteRect.y + spriteRect.h - 1 do
            for x = spriteRect.x, spriteRect.x + spriteRect.w - 1 do
                self:adjustBounds(bounds, x, y)
            end
        end

        if bounds.minX ~= nil then spriteRect.x, spriteRect.w = bounds.minX, bounds.maxX - bounds.minX + 1 end
        if bounds.minY ~= nil then spriteRect.y, spriteRect.h = bounds.minY, bounds.maxY - bounds.minY + 1 end
    end,

    adjustBounds = function(self, bounds, x, y)
        local pixelColor = IMAGE_VIEWER:getPixelColorAt(x, y)
        if not isCloseEnoughMatch(pixelColor, SPRITE_BG_COLOR) then
            if bounds.minX == nil then bounds.minX = x else bounds.minX = math.min(x, bounds.minX) end
            if bounds.minY == nil then bounds.minY = y else bounds.minY = math.min(y, bounds.minY) end
            if bounds.maxX == nil then bounds.maxX = x else bounds.maxX = math.max(x, bounds.maxX) end
            if bounds.maxY == nil then bounds.maxY = y else bounds.maxY = math.max(y, bounds.maxY) end
        end
    end,
}
