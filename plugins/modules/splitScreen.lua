return {
    height     = 768,
    destHeight = 768,
    
    init = function(self, params)
        self.GFX1 = params.GFX1
        self.GFX2 = params.GFX2

        return self
    end,

    draw = function(self)
        self.yScale = self.height / 768
        self.GFX1:blitToScreen(0, 768 - self.height, { 1, 1, 1 }, 0, 1,     self.yScale)
        self.GFX2:blitToScreen(0, 0,                 { 1, 1, 1 }, 0, 1, 1 - self.yScale)
    end,

    update = function(self, dt)
        if self.destHeight > self.height then
            self.height = math.min(self.destHeight, self.height + (1536 * dt))
        else
            self.height = math.max(self.destHeight, self.height - (1536 * dt))
        end
    end,

    handleKeypressed = function(self, key)
        if key == "1" then
            self.destHeight = math.min(768, self.destHeight + 384)
        elseif key == "2" then
            self.destHeight = math.max(0,   self.destHeight - 384)
        end
    end,
}
