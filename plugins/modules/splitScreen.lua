local SCREEN_HEIGHT = 768

return {
    degrees     = 90,
    destDegrees = 90,
    
    init = function(self, params)
        self.GFX1 = params.GFX1
        self.GFX2 = params.GFX2

        return self
    end,

    draw = function(self)
        local height = SCREEN_HEIGHT - (math.cos((self.degrees / 180) * math.pi) * SCREEN_HEIGHT)
        local yScale = height / SCREEN_HEIGHT
        self.GFX1:blitToScreen(0, SCREEN_HEIGHT - height, { 1, 1, 1 }, 0, 1,     yScale)
        self.GFX2:blitToScreen(0, 0,                      { 1, 1, 1 }, 0, 1, 1 - yScale)
    end,

    update = function(self, dt)
        if self.destDegrees > self.degrees then
            self.degrees = math.min(self.destDegrees, self.degrees + (180 * dt))
        else
            self.degrees = math.max(self.destDegrees, self.degrees - (180 * dt))
        end
    end,

    handleKeypressed = function(self, key)
        if key == "1" then
            if self.destDegrees == 60 then self.destDegrees = 90
            else                           self.destDegrees = 60  end
        elseif key == "2" then
            if self.destDegrees == 90 then self.destDegrees = 60
            else                           self.destDegrees = 0   end
        end
    end,
}
