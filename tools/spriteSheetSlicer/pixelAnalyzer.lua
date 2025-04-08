return {
    marginBGColor = nil,   
    spriteBGColor = nil,

    init = function(self, marginBGColor, spriteBGColor)
        self.marginBGColor = marginBGColor
        self.spriteBGColor = spriteBGColor
    end,
    
    isProbablyLeftEdge  = function(self, thisColor)
        return      self:colorsMatch(self.prevColor, self.marginBGColor)
            and not self:colorsMatch(thisColor,      self.marginBGColor)
    end,

    isDefinitelyLeftEdge  = function(self, thisColor)
        return  self:colorsMatch(self.prevColor, self.marginBGColor)
            and self:colorsMatch(thisColor,      self.spriteBGColor)
    end,

    isLikelyRightEdge = function(self, thisColor)
        return not self:colorsMatch(self.prevColor, self.marginBGColor)
               and self:colorsMatch(thisColor,      self.marginBGColor)
    end,
    
    colorsMatch = function(self, c1, c2)
        return c1 ~= nil 
           and c2 ~= nil
           and math.abs(c1.r - c2.r) < 0.005
           and math.abs(c1.g - c2.g) < 0.005 
           and math.abs(c1.b - c2.b) < 0.005
    end,
}
