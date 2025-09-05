return {
    toggleShowKey = nil,
    showTracker   = false,
    graphics      = nil,

    leftX         = 0,
    topY          = 0,
    rightX        = 1000,
        
    init = function(self, params)
        self.toggleShowKey = params.toggleShowKey
        self.graphics      = params.graphics
        return self
    end,
    
    draw = function(self)
        if self.showTracker then
            self:updateWorldCoordinates()
            self.graphics:setColor(1, 1, 1)
            self.graphics:setLineWidth(2)
            self.graphics:line(self.rightX, self.topY, self.rightX, love.graphics.getHeight() * 3/4)
        end
    end,

    updateWorldCoordinates = function(self)
        self.leftX,  self.topY    = self.graphics:screenToImageCoordinates(0, 0)
        self.rightX, _            = self.graphics:screenToImageCoordinates(love.graphics.getWidth() - 24, love.graphics.getHeight())
    end,
    
    handleKeypressed = function(self, key)
        if key == self.toggleShowKey then
            self.showTracker = not self.showTracker
        end
    end,
}
