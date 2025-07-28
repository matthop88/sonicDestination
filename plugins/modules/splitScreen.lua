return {
    init = function(self, params)
        self.GFX1 = params.GFX1
        self.GFX2 = params.GFX2

        return self
    end,

    draw = function(self)
        self.GFX1:blitToScreen(0, 384, { 1, 1, 1 }, 0, 1, 0.5)
        self.GFX2:blitToScreen(0, 0,   { 1, 1, 1 }, 0, 1, 0.5)
    end,
}
