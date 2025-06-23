return {
    init = function(self, parameters)
        self.graphics    = parameters.graphics
        self.gridSize    = parameters.gridSize or 64
        self.midLineY    = self.graphics:getScreenHeight() * 3/4
        self.topLineY    = self.midLineY - 24
        self.bottomLineY = self.midLineY + 42
        return self
    end,
    
    -----------------------------------------------
    --   Methods called by LOVE events go here   --
    -----------------------------------------------
    draw = function(self)
        local viewportRect = self.graphics:calculateViewportRect()
        
        self.graphics:setColor(1, 1, 1)
        self:drawTopLine(viewportRect)
        self:drawBottomLine(viewportRect)
        self:drawGridLines(viewportRect)
    end,

    -----------------------------------------------
    --        Specialized Methods Go Here        --
    -----------------------------------------------
    drawTopLine = function(self, viewportRect)
        self.graphics:setLineWidth(4)
        self.graphics:line(viewportRect.x, self.topLineY, viewportRect.x + viewportRect.w, self.topLineY)
    end,
    
    drawBottomLine = function(self, viewportRect)
        self.graphics:setLineWidth(2)
        self.graphics:line(viewportRect.x, self.bottomLineY, viewportRect.x + viewportRect.w, self.bottomLineY)
    end,
    
    drawGridLines = function(self, viewportRect)
        local startX, endX, offsetX = self:calculateGridTopAttributes()
        local bottomX               = startX - offsetX - (viewportRect.w / 2)
        
        self.graphics:setColor(1, 0, 0)
        for x = startX, endX, self.gridSize do
            self.graphics:rectangle("fill", x - 1, self.topLineY - 1, 3, 3)
            self.graphics:line(x, self.midLineY, bottomX, self.bottomLineY)
            bottomX = bottomX + (self.gridSize * 2)
        end
    end,

    calculateGridTopAttributes = function(self)
        local startX, startY, width, height = self.graphics:calculateViewport()
        local offsetX = startX % self.gridSize
        startX = startX - offsetX

        return startX, startX + width, offsetX
    end,
}
