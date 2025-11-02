local PAGE_WIDTH, PAGE_HEIGHT, RING

local GRAFX        = require("tools/lib/graphics"):create()
local MAP_GRAFX 
local MAP_IMG_DATA

local DEBUG_RING_X, DEBUG_RING_Y

return {
    create = function(self, ring, pageWidth, pageHeight)
    	PAGE_WIDTH, PAGE_HEIGHT = pageWidth, pageHeight
    	RING                    = ring
    	MAP_GRAFX               = require("tools/lib/bufferedGraphics"):create(GRAFX, PAGE_WIDTH, PAGE_HEIGHT)
    	MAP_IMG_DATA            = MAP_GRAFX:getBuffer():newImageData()
    	
    	MAP_GRAFX:setFilter("nearest", "nearest")

    	self:drawRingsToBuffer()
        
        return {
        	getImage = function(self)
        		return MAP_GRAFX:getBuffer()
        	end,

            getImageData = function(self)
                return MAP_IMG_DATA
            end,

            getDebugRingX = function(self)
                return DEBUG_RING_X
            end,

            getDebugRingY = function(self)
                return DEBUG_RING_Y
            end,
        }
    end,

    drawRingsToBuffer = function(self)
        self:drawBackground()
        self:drawRings()
    end,

    drawBackground = function(self)
        MAP_GRAFX:setColor(0, 0, 0)
        MAP_GRAFX:rectangle("fill", MAP_GRAFX:calculateViewport())
        MAP_GRAFX:setColor(0.3, 0.3, 0.3)
        MAP_GRAFX:rectangle("fill", 10, 10, PAGE_WIDTH - 20, PAGE_HEIGHT - 20)
    end,

    drawRings = function(self)
        MAP_GRAFX:setColor(1, 1, 1)
        for i = 1, 150 do
            local ringX = math.random(1, (PAGE_WIDTH  / 16) - 3) * 16
            local ringY = math.random(1, (PAGE_HEIGHT / 16) - 3) * 16
            MAP_GRAFX:drawImage(RING:getImage(), ringX, ringY)
            DEBUG_RING_X, DEBUG_RING_Y = ringX, ringY
        end
    end,
}
