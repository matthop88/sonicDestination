--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local GRAFX      = require("tools/lib/graphics"):create()
local RING_GRAFX = require("tools/lib/bufferedGraphics"):create(GRAFX, 16, 16)

local OBJ_IMG    = love.graphics.newImage("tools/ringMaster/resources/commonObj.png")
local RING_QUAD  = love.graphics.newQuad(24, 198, 16, 16, OBJ_IMG:getWidth(), OBJ_IMG:getHeight())

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

OBJ_IMG:setFilter("nearest", "nearest")

return {
    create = function(self)
        RING_GRAFX:setColor(1, 1, 1)
        RING_GRAFX:draw(OBJ_IMG, RING_QUAD, 0, 0, 0, 1, 1)
        RING_GRAFX:getBuffer():setFilter("nearest", "nearest")

        return {
            getImage = function(self)
                return RING_GRAFX:getBuffer()
            end,
        }
    end,
}
