local MARGIN_BG_COLOR, SPRITE_BG_COLOR
local IMAGE_VIEWER

local thisColor, prevColor

return {
    init = function(self, imageViewer, marginBGColor, spriteBGColor)
        IMAGE_VIEWER    = imageViewer
        MARGIN_BG_COLOR = marginBGColor
        SPRITE_BG_COLOR = spriteBGColor

        return self
    end,

    crop = function(self, spriteRects)
        for _, spriteRect in ipairs(spriteRects:elements()) do
            self:cropSpriteRect(spriteRect)
        end
    end,

    cropSpriteRect = function(self, spriteRect)
        -- Scan all lines, determine where each begins and each ends
    end,
}
