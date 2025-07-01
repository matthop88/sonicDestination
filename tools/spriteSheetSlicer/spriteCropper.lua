local MARGIN_BG_COLOR, SPRITE_BG_COLOR
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
    init = function(self, imageViewer, marginBGColor, spriteBGColor)
        IMAGE_VIEWER    = imageViewer
        MARGIN_BG_COLOR = marginBGColor
        SPRITE_BG_COLOR = spriteBGColor

        return self
    end,

    crop = function(self, spriteRects)
        for _, spriteRect in spriteRects:elements() do
            self:cropSpriteRect(spriteRect)
        end
    end,

    cropSpriteRect = function(self, spriteRect)
        -- Scan all lines, determine where each begins and each ends
        local minX, maxX, minY, maxY
        for y = spriteRect.y, spriteRect.y + spriteRect.h - 1 do
            for x = spriteRect.x, spriteRect.x + spriteRect.w - 1 do
                local pixelColor = IMAGE_VIEWER:getPixelColorAt(x, y)
                if not isCloseEnoughMatch(pixelColor, SPRITE_BG_COLOR) then
                    -- Update minX, maxX, minY, maxY
                end
            end
        end

        if minX ~= nil then spriteRect.x, spriteRect.w = minX, maxX - minX + 1 end
        if minY ~= nil then spriteRect.y, spriteRect.h = minY, maxY - minY + 1 end
    end,
}
