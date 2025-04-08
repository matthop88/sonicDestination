return {
    imageViewer   = nil,
    marginBGColor = nil,   
    spriteBGColor = nil,
    thisColor     = nil,
    prevColor     = nil,
    
    init = function(self, imageViewer, marginBGColor, spriteBGColor)
        self.imageViewer   = imageViewer
        self.marginBGColor = marginBGColor
        self.spriteBGColor = spriteBGColor
        return self
    end,

    processPixelAt = function(self, x, y)
        if x == 0 then self.prevColor = nil end
        self.thisColor = self.imageViewer:getPixelColorAt(x, y) 
        self.prevColor = self.thisColor
    end,
    
    isProbablyLeftEdge  = function(self)
        return      self:colorsMatch(self.prevColor, self.marginBGColor)
            and not self:colorsMatch(self.thisColor, self.marginBGColor)
    end,

    isDefinitelyLeftEdge  = function(self)
        return  self:colorsMatch(self.prevColor, self.marginBGColor)
            and self:colorsMatch(self.thisColor, self.spriteBGColor)
    end,

    isLikelyRightEdge = function(self)
        return not self:colorsMatch(self.prevColor, self.marginBGColor)
               and self:colorsMatch(self.thisColor, self.marginBGColor)
    end,
    
    colorsMatch = function(self, c1, c2)
        return c1 ~= nil 
           and c2 ~= nil
           and math.abs(c1.r - c2.r) < 0.005
           and math.abs(c1.g - c2.g) < 0.005 
           and math.abs(c1.b - c2.b) < 0.005
    end,
}
