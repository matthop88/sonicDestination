local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 768
local COLORS                      = require("tools/lib/colors")

return {
    init = function(self, gridSize)
        self.gridSize = gridSize
        return self
    end,
    
    draw = function(self)
        self:drawBackground()
        self:drawHoles()
    end,

    drawBackground = function(self)
        love.graphics.setColor(COLORS.MOSS_GREEN)
        love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    end,

    drawHoles = function(self)
        for y = 0, WINDOW_HEIGHT, self.gridSize do
            for x = 0, WINDOW_WIDTH, self.gridSize do
                self:drawHole(x, y)
            end
        end
    end,

    drawHole = function(self, x, y)
        love.graphics.setColor(COLORS.TRANSLUCENT_WHITE)
        love.graphics.rectangle("fill", x - 1, y - 1, 3, 3)
    end,
}
