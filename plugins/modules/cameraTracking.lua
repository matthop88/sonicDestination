return {
    positionFn      = nil,
    graphics        = nil,
    active          = true,
    toggleCameraKey = nil,
    vertical        = nil,

    init = function(self, parameters)
        self.graphics   = parameters.graphics
        self.positionFn = parameters.positionFn
        if parameters.toggleCameraKey then
            self.toggleCameraKey = parameters.toggleCameraKey
            self.active = false
        end
        self.vertical = parameters.vertical
        return self
    end,

    handleKeypressed = function(self, key)
        if key == self.toggleCameraKey then
            self.active = not self.active
        end
    end,
    
    update = function(self, dt)
        if self.active then
            local centerX          = self.graphics:getScreenWidth()  / 2
            local centerY          = self.graphics:getScreenHeight() / 2
            local objectX, objectY = self.positionFn()
    
            self.graphics:syncImageXWithScreen(objectX, centerX)
            if self.vertical then
                self.graphics:syncImageYWithScreen(objectY, centerY)
            end
        end
    end,
}
