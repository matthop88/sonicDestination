return {
    init = function(self, parameters)
        self.graphics = parameters.graphics
        return self
    end,
    
    -----------------------------------------------
    --   Methods called by LOVE events go here   --
    -----------------------------------------------
    draw = function(self)
        local topLineY, midLineY = 512, 534

        self.graphics:setColor(1, 1, 1)
        self.graphics:setLineWidth(4)
        self.graphics:line(0, topLineY, 1024, topLineY)

        self.graphics:setLineWidth(2)
        self.graphics:line(0, midLineY, 1024, midLineY)
    end,

}
