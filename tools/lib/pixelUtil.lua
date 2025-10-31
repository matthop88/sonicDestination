-- Much more optimized version of pixel matching algorithm.
-- Performance difference:
-- Chunkalyzation of 10240 x 1280 image -> 4.73 sec (was 8.36 sec)
-- Tileination of     2304 x 1280 image -> 7.20 sec (was 9.57 sec)
-- Over all, a 20-40% improvement in performance.

return {
    colorsMatch = function(self, r1, g1, b1, a1, r2, g2, b2, a2)
        return math.abs(r1 - r2) < 0.005
           and math.abs(g1 - g2) < 0.005 
           and math.abs(b1 - b2) < 0.005
           and math.abs(a1 - a2) < 0.005
    end,

    pixelsMatch = function(self, imageData1, x1, y1, imageData2, x2, y2)
        local r1, g1, b1, a1 = imageData1:getPixel(math.floor(x1), math.floor(y1))
        local r2, g2, b2, a2 = imageData2:getPixel(math.floor(x2), math.floor(y2))
        return self:colorsMatch(r1, g1, b1, a1, r2, g2, b2, a2)
    end,                 
}
