return {
    toggleShowKey = nil,
    showTracker   = false,
    graphics      = nil,
    posAndWidthFn = nil,

    leftX         = 0,
    topY          = 0,
    rightX        = 1000,
        
    init = function(self, params)
        self.toggleShowKey = params.toggleShowKey
        self.graphics      = params.graphics
        self.posAndWidthFn = params.posAndWidthFn
        return self
    end,
    
    draw = function(self)
        if self.showTracker then
            self:updateWorldCoordinates()
            self:drawVerticalLine()
            self:drawHorizontalLineAboveSprite()
            self:drawHorizontalLineOnRuler()
        end
    end,

    updateWorldCoordinates = function(self)
        self.leftX,  self.topY    = self.graphics:screenToImageCoordinates(0, 0)
        self.rightX, _            = self.graphics:screenToImageCoordinates(love.graphics.getWidth() - 24, love.graphics.getHeight())
    end,

    drawVerticalLine = function(self)
        self.graphics:setColor(1, 1, 1)
        self.graphics:setLineWidth(2)
        self.graphics:line(self.rightX, self.topY, self.rightX, love.graphics.getHeight() * 3/4)
    end,

    drawHorizontalLineAboveSprite = function(self)
        if self.posAndWidthFn then
            local x, y, w = self.posAndWidthFn()
            self.graphics:line(x, y, x + w, y)
        end
    end,

    drawHorizontalLineOnRuler = function(self)
        if self.posAndWidthFn then
            local x, y, w = self.posAndWidtthFn()
            self.graphics:line(self.rightX - 115, y, self.rightX + 15, y)
        end
    end,
     
    handleKeypressed = function(self, key)
        if key == self.toggleShowKey then
            self.showTracker = not self.showTracker
        end
    end,
}
