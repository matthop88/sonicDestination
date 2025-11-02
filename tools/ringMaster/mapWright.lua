local PAGE_WIDTH, PAGE_HEIGHT, RING

local GRAFX        = require("tools/lib/graphics"):create()
local MAP_GRAFX 
local MAP_IMG_DATA
local RING_TOTAL   = 0

return {
    create = function(self, ring, pageWidth, pageHeight)
    	PAGE_WIDTH, PAGE_HEIGHT = pageWidth, pageHeight
    	RING                    = ring
    	MAP_GRAFX               = require("tools/lib/bufferedGraphics"):create(GRAFX, PAGE_WIDTH, PAGE_HEIGHT)
    	
    	MAP_GRAFX:setFilter("nearest", "nearest")

    	self:drawRingsToBuffer()
        
        MAP_IMG_DATA            = MAP_GRAFX:getBuffer():newImageData()
        
        return {
        	getImage = function(self)
        		return MAP_GRAFX:getBuffer()
        	end,

            getImageData = function(self)
                return MAP_IMG_DATA
            end,

            getRingTotal = function(self)
                return RING_TOTAL
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
        for y = 16, PAGE_HEIGHT - 32, 16 do
            local targetNumber = math.random(1, 320)
            local x = 16
            while x < PAGE_WIDTH - 32 do
                local guessingNumber = math.random(1, 320)
                if guessingNumber == targetNumber then 
                    MAP_GRAFX:drawImage(RING:getImage(), x, y)
                    RING_TOTAL = RING_TOTAL + 1
                    x = x + 16
                else
                    x = x + 1
                end
            end       
        end
        print("Number of rings: " .. RING_TOTAL)
    end,
}
