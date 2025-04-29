local COLORS = require("tools/lib/colors")
local GRID_SIZE

return {
    init = function(self, gridSize)
        GRID_SIZE = gridSize
        return self
    end,
    
    draw = function(self)
        self:drawBackground()
        self:drawHoles()
    end,

    drawBackground = function(self)
        love.graphics.setColor(COLORS.MOSS_GREEN)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end,

    drawHoles = function(self)
        for y = 0, love.graphics.getHeight(), GRID_SIZE do
            for x = 0, love.graphics.getWidth(), GRID_SIZE do
                self:drawHole(x, y)
            end
        end
    end,

    drawHole = function(self, x, y)
        love.graphics.setColor(COLORS.TRANSLUCENT_WHITE)
        love.graphics.rectangle("fill", x - 1, y - 1, 3, 3)
    end,
}
