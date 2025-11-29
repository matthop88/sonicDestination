return {
    init = function(self, params)
        self.interval  = params.interval or 0.3
        self.clickedAt = love.timer.getTime()
        return self
    end,

    prehandleMousepressed = function(self, mx, my, params)
        params.doubleClicked = self:withinThreshold()
        self.clickedAt       = love.timer.getTime()
    end,

    withinThreshold = function(self)
        return love.timer.getTime() - self.clickedAt < self.interval
    end,
}
