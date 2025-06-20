return {
    init = function(self, parameters)
        self.graphics = parameters.graphics
        return self
    end,
    
    -----------------------------------------------
    --   Methods called by LOVE events go here   --
    -----------------------------------------------
    draw = function(self)
        local viewPortRect = self:calculateViewportRect()
        
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
    getScreenWidth  = function(self) return love.graphics.getWidth()  end,
    getScreenHeight = function(self) return love.graphics.getHeight() end,

    calculateViewportRect = function(self)
        local leftX,  topY    = self.graphics:screenToImageCoordinates(0, 0)
        local rightX, bottomY = self.graphics:screenToImageCoordinates(self:getScreenWidth(), self:getScreenHeight())

        return { x = leftX, y = topY, w = rightX - leftX, h = bottomY - topY }
    end,

}
