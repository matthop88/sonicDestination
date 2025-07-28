return {
    degrees     = 0,
    destDegrees = 0,
    
    init = function(self, params)
        self.GFX1 = params.GFX1
        self.GFX2 = params.GFX2

        return self
    end,

    draw = function(self)
        local height = math.sin((degrees / 180) * math.PI) * 768
        local yScale = height / 768
        self.GFX1:blitToScreen(0, 768 - height, { 1, 1, 1 }, 0, 1,     yScale)
        self.GFX2:blitToScreen(0, 0,            { 1, 1, 1 }, 0, 1, 1 - yScale)
    end,

    update = function(self, dt)
        if self.destDegrees > self.degrees then
            self.degrees = math.min(self.destDegrees, self.degrees + (360 * dt))
        else
            self.degrees = math.max(self.destDegrees, self.degrees - (360 * dt))
        end
    end,

    handleKeypressed = function(self, key)
        if key == "1" then
            self.destDegrees = math.min(180, self.destDegrees + 90)
        elseif key == "2" then
            self.destDegrees = math.max(0,   self.destDegrees - 90)
        end
    end,
}
