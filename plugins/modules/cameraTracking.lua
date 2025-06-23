return {
    positionFn      = nil,
    graphics        = nil,
    active          = true,
    toggleCameraKey = nil,

    init = function(self, parameters)
        self.graphics   = parameters.graphics
        self.positionFn = parameters.positionFn
        if parameters.toggleCameraKey then
            self.toggleCameraKey = parameters.toggleCameraKey
            self.active = false
        end
        return self
    end,

    keypressed = function(self, key)
        if key == self.toggleCameraKey then
            self.active = not self.active
        end
    end,
    
    update = function(self, dt)
        if self.active then
            local centerX    = self.graphics:getScreenWidth()  / 2
            local objectX, _ = self.positionFn()
    
            self.graphics:syncImageXWithScreen(objectX, centerX)
        end
    end,
}
