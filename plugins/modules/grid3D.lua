return {
    init = function(self, parameters)
        self.graphics = parameters.graphics
        return self
    end,
    
    -----------------------------------------------
    --   Methods called by LOVE events go here   --
    -----------------------------------------------
    draw = function(self)
        local viewPortRect = self.graphics:calculateViewportRect()
        
        self.graphics:setColor(1, 1, 1)
        self:drawTopLine(viewPortRect)
        self:drawMidLine(viewPortRect)
    end,

    -----------------------------------------------
    --        Specialized Methods Go Here        --
    -----------------------------------------------
    drawTopLine = function(self, viewPortRect)
        local topLineY = 512
        self.graphics:setLineWidth(4)
        self.graphics:line(viewPortRect.x, topLineY, viewPortRect.x + viewPortRect.w, topLineY)
    end,
    
    drawMidLine = function(self, viewPortRect)
        local midLine = 534
        self.graphics:setLineWidth(2)
        self.graphics:line(viewPortRect.x, midLineY, viewPortRect.x + viewPortRect.w, midLineY)
    end,
    
    -- ...

}
