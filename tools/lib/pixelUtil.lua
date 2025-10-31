-- More optimized version of pixel matching algorithm.
-- Reuses same two tables rather than dynamically creating and destroying millions.
-- Performance difference:
-- Chunkalyzation of 10240 x 1280 image -> 7.30 sec (was 8.36 sec)
-- Tileination of     2304 x 1280 image -> 7.57 sec (was 9.57 sec)

local PIXEL_COLOR_1 = {
    r = nil, g = nil, b = nil, a = nil,

    init = function(self, r, g, b, a)
        self.r, self.g, self.b, self.a = r, g, b, a
        
        return self
    end,
}

local PIXEL_COLOR_2 = {
    r = nil, g = nil, b = nil, a = nil,

    init = function(self, r, g, b, a)
        self.r, self.g, self.b, self.a = r, g, b, a
        
        return self
    end,
}

local getPixelColor1At = function(imageData, x, y)
    local r, g, b, a = imageData:getPixel(math.floor(x), math.floor(y))
    return PIXEL_COLOR_1:init(r, g, b, a)
end

local getPixelColor2At = function(imageData, x, y)
    local r, g, b, a = imageData:getPixel(math.floor(x), math.floor(y))
    return PIXEL_COLOR_2:init(r, g, b, a)
end

return {
    colorsMatch = function(self, c1, c2)
        return c1 ~= nil 
           and c2 ~= nil
           and math.abs(c1.r - c2.r) < 0.005
           and math.abs(c1.g - c2.g) < 0.005 
           and math.abs(c1.b - c2.b) < 0.005
           and math.abs(c1.a - c2.a) < 0.005
    end,

    pixelsMatch = function(self, imageData1, x1, y1, imageData2, x2, y2)
        return self:colorsMatch(getPixelColor1At(imageData1, x1, y1), getPixelColor2At(imageData2, x2, y2))
    end, 
                
}
