local COLORS = require("tools/lib/colors")
local GRID_SIZE, GRAFX

local GRAFX = require("tools/lib/graphics")

return {
    init = function(self, gridSize, graphics)
        GRID_SIZE = gridSize
        GRAFX     = graphics
        return self
    end,
    
    draw = function(self)
        self:drawBackground()
        self:drawHoles()
    end,

    drawBackground = function(self)
        GRAFX:setColor(COLORS.MOSS_GREEN)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end,

    drawHoles = function(self)
        local startX, endX, startY, endY = self:calculateHolePositions()

        for y = startY, endY, GRID_SIZE do
            for x = startX, endX, GRID_SIZE do
                self:drawHole(x, y)
            end
        end
    end,
    
    calculateHolePositions = function(self)
        local startX, startY, width, height = GRAFX:calculateViewport()
        startX = startX - (startX % GRID_SIZE)
        startY = startY - (startY % GRID_SIZE)
         
        return startX, startX + width, startY, startY + height
    end,

    drawHole = function(self, x, y)
        GRAFX:setColor(COLORS.TRANSLUCENT_WHITE)
        GRAFX:rectangle("fill", x - 1, y - 1, 3, 3)
    end,
}
