return {
    init = function(self, parameters)
        self.graphics     = parameters.graphics
        self.gridSize     = parameters.gridSize or 64
        self.standingLine = self.graphics:getScreenHeight() * 3/4
        self.midLineY     = self.standingLine + 48
        self.topLineY     = self.standingLine - 24
        self.bottomLineY  = self.standingLine + 144
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

    drawMidLine = function(self, viewportRect)
        self.graphics:setLineWidth(3)
        self.graphics:line(viewportRect.x, self.midLineY, viewportRect.x + viewportRect.w, self.midLineY)
    end,
    
    drawBottomLine = function(self, viewportRect)
        self.graphics:setLineWidth(2)
        self.graphics:line(viewportRect.x, self.bottomLineY, viewportRect.x + viewportRect.w, self.bottomLineY)
    end,
    
    drawGridLines = function(self, viewportRect)
        local startX, endX, offsetX = self:calculateGridTopAttributes()
        local bottomX               = startX - offsetX - (viewportRect.w / 2)
        
        self.graphics:setColor(1, 1, 1)
        for x = startX, endX, self.gridSize do
            self.graphics:rectangle("fill", x - 1, self.topLineY - 1, 3, 3)
            self.graphics:line(x, self.standingLine, bottomX, self.bottomLineY)
            local delta = (bottomX - x) / 6
            self.graphics:line(x - delta, self.topLineY, x, self.standingLine)
            bottomX = bottomX + (self.gridSize * 2)
        end
    end,

    calculateGridTopAttributes = function(self)
        local startX, startY, width, height = self.graphics:calculateViewport()
        local offsetX = startX % self.gridSize
        startX = startX - offsetX

        return startX, startX + (width * 1.5), offsetX
    end,
}
