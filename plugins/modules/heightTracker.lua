return {
    toggleShowKey = nil,
    showTracker   = false,

    init = function(self, params)
        self.toggleShowKey = params.toggleShowKey
        return self
    end,
    
    draw = function(self)
        if self.showTracker then
            love.graphics.setColor(1, 1, 1)
            love.graphics.setLineWidth(2)
            love.graphics.line(1000, 0, 1000, 576)
        end
    end,

    handleKeypressed = function(self, key)
        if key == self.toggleShowKey then
            self.showTracker = not self.showTracker
        end
    end,
}
