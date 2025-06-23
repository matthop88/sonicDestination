return {
    positionFn = nil,
    graphics   = nil,

    init = function(self, parameters)
        self.graphics   = parameters.graphics
        self.positionFn = parameters.positionFn
        return self
    end,

    update = function(self, dt)
        local centerX = self.graphics:getScreenWidth()  / 2
        local centerY = self.graphics:getScreenHeight() / 2

        local objectX, objectY = self.positionFn()

        self.graphics:syncImageCoordinatesWithScreen(objectX, objectY, centerX, centerY)
    end,
}
