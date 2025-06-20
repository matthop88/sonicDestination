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
        
        local topLineY, midLineY = 512, 534

        self.graphics:setColor(1, 1, 1)
        self.graphics:setLineWidth(4)
        self.graphics:line(viewPortRect.x, topLineY, viewPortRect.x + viewPortRect.w, topLineY)

        self.graphics:setLineWidth(2)
        self.graphics:line(viewPortRect.x, midLineY, viewPortRect.x + viewPortRect.w, midLineY)
    end,

    -----------------------------------------------
    --        Specialized Methods Go Here        --
    -----------------------------------------------
    -- ...
    -- ...
    -- ...

}
