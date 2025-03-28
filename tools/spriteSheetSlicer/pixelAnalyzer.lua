local colorsMatch = function(c1, c2)
    return c1 ~= nil and c2 ~= nil
       and math.abs(c1.r - c2.r) < 0.005
       and math.abs(c1.g - c2.g) < 0.005 
       and math.abs(c1.b - c2.b) < 0.005
end

local leavingMarginBGColor = function(prevColor, thisColor, marginBGColor)
    return  colorsMatch(prevColor, marginBGColor)
    and not colorsMatch(thisColor, marginBGColor)
end

local enteringSpriteBGColor = function(prevColor, thisColor, spriteBGColor)
    return  colorsMatch(thisColor, spriteBGColor)
    and not colorsMatch(prevColor, spriteBGColor)
end

local leavingSpriteBGColor  = function(prevColor, thisColor, spriteBGColor)
    return  colorsMatch(prevColor, spriteBGColor)
    and not colorsMatch(thisColor, spriteBGColor)
end

local enteringMarginBGColor = function(prevColor, thisColor, marginBGColor)
    return  colorsMatch(thisColor, marginBGColor)
    and not colorsMatch(prevColor, marginBGColor)
end

return {
    state = {
        LEAVING_MARGIN_BG_COLOR  = false,
        ENTERING_SPRITE_BG_COLOR = false,
        LEAVING_SPRITE_BG_COLOR  = false,
        ENTERING_MARGIN_BG_COLOR = false,

        isPossiblyEnteringSprite = function(self)
            return self.LEAVING_MARGIN_BG_COLOR
        end,

        isDefinitelyEnteringSprite = function(self)
            return self.LEAVING_MARGIN_BG_COLOR and self.ENTERING_SPRITE_BG_COLOR
        end,

        isProbablyLeavingSprite = function(self)
            return self.ENTERING_MARGIN_BG_COLOR
        end,
    },

    init = function(self, marginBGColor, spriteBGColor)
        self.MARGIN_BG_COLOR = marginBGColor
        self.SPRITE_BG_COLOR = spriteBGColor
        return self
    end,

    analyzePixelTransition = function(self, prevColor, thisColor)
        self.state.LEAVING_MARGIN_BG_COLOR  = leavingMarginBGColor( prevColor, thisColor, self.MARGIN_BG_COLOR)
        self.state.ENTERING_SPRITE_BG_COLOR = enteringSpriteBGColor(prevColor, thisColor, self.SPRITE_BG_COLOR)
        self.state.LEAVING_SPRITE_BG_COLOR  = leavingSpriteBGColor( prevColor, thisColor, self.SPRITE_BG_COLOR)
        self.state.ENTERING_MARGIN_BG_COLOR = enteringMarginBGColor(prevColor, thisColor, self.MARGIN_BG_COLOR)
        return self.state
    end,
}
