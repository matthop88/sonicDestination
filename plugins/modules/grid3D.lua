return {
    init = function(self, parameters)
        self.graphics = parameters.graphics
        self.gridSize = parameters.gridSize or 64
        return self
    end,
    
    -----------------------------------------------
    --   Methods called by LOVE events go here   --
    -----------------------------------------------
    draw = function(self)
        local viewportRect = self.graphics:calculateViewportRect()
        
        self.graphics:setColor(1, 1, 1)
        self:drawTopLine(viewportRect)
        self:drawMidLine(viewportRect)
        self:drawGridTopMarkings(viewportRect)
    end,

    -----------------------------------------------
    --        Specialized Methods Go Here        --
    -----------------------------------------------
    drawTopLine = function(self, viewportRect)
        local topLineY = 512
        self.graphics:setLineWidth(4)
        self.graphics:line(viewportRect.x, topLineY, viewportRect.x + viewportRect.w, topLineY)
    end,
    
    drawMidLine = function(self, viewPortRect)
        local midLineY = 534
        self.graphics:setLineWidth(2)
        self.graphics:line(viewportRect.x, midLineY, viewportRect.x + viewportRect.w, midLineY)
    end,
    
    drawGridTopMarkings = function(self, viewportRect)
        local startX, endX = self:calculateGridTopStartXAndEndX()

        self.graphics:setColor(1, 0, 0)
        for x = startX, endX, self.gridSize do
            self.graphics:rectangle("fill", x - 1, 511, 3, 3)
        end
    end,

    calculateGridTopStartXAndEndX = function(self)
        local startX, startY, width, height = self.graphics:calculateViewport()
        startX = startX - (startX % self.gridSize)

        return startX, startX + width
    end,
}
