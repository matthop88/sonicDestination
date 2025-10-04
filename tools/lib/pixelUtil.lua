return {
    getPixelColorAt = function(self, imageData, x, y)
        local r, g, b, a = imageData:getPixel(math.floor(x), math.floor(y))
        return { r = r, g = g, b = b, a = a }
    end,

    colorsMatch = function(self, c1, c2)
        return c1 ~= nil 
           and c2 ~= nil
           and math.abs(c1.r - c2.r) < 0.005
           and math.abs(c1.g - c2.g) < 0.005 
           and math.abs(c1.b - c2.b) < 0.005
           and math.abs(c1.a - c2.a) < 0.005
    end,

    pixelsMatch = function(self, imageData1, x1, y1, imageData2, x2, y2)
        return self:colorsMatch(self:getPixelColorAt(imageData1, x1, y1), self:getPixelColorAt(imageData2, x2, y2))
    end, 
                
}
