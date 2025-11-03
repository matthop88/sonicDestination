--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local OBJECT_DATA = love.image.newImageData("tools/ringMaster/resources/commonObj.png")
local OBJECT_IMG  = love.graphics.newImage(OBJECT_DATA)
local RING_QUAD   = love.graphics.newQuad(24, 198, 16, 16, OBJECT_IMG:getWidth(), OBJECT_IMG:getHeight())

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

OBJECT_IMG:setFilter("nearest", "nearest")

return {
    data   = OBJECT_DATA, 
    width  = 16,
    height = 16, 
    startX = 24, 
    startY = 198,

    draw = function(self, x, y, scale, color)
        love.graphics.setColor(color)
        love.graphics.draw(OBJECT_IMG, RING_QUAD, x, y, 0, scale, scale)
    end,
}
