--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local OBJECT_DATA = love.image.newImageData("tools/ringMaster/resources/commonObj.png")
local OBJECT_IMG  = love.graphics.newImage(OBJECT_DATA)

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
}
