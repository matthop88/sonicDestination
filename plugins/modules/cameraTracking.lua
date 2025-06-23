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
        
        local objectX, _ = self.positionFn()

        self.graphics:syncImageXWithScreen(objectX, centerX)
    end,
}
