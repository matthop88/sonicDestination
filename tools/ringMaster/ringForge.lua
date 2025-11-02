--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local GRAFX      = require("tools/lib/graphics"):create()
local RING_GRAFX = require("tools/lib/bufferedGraphics"):create(GRAFX, 16, 16)

local OBJECT_IMG = love.graphics.newImage("tools/ringMaster/resources/commonObj.png")
local RING_QUAD  = love.graphics.newQuad(24, 198, 16, 16, OBJECT_IMG:getWidth(), OBJECT_IMG:getHeight())

local RING_IMG_DATA

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

OBJECT_IMG:setFilter("nearest", "nearest")
RING_GRAFX:setFilter("nearest", "nearest")

return {
    create = function(self)
        RING_GRAFX:setColor(1, 1, 1)
        RING_GRAFX:draw(OBJECT_IMG, RING_QUAD, 0, 0, 0, 1, 1)
        
        RING_IMG_DATA = RING_GRAFX:getBuffer():newImageData()
        
        return {
            getImage = function(self)
                return RING_GRAFX:getBuffer()
            end,

            getImageData = function(self)
                return RING_IMG_DATA
            end,
        }
    end,
}
