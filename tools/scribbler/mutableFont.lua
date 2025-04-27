return {
    index = 11,

    fontsBySize = {
        [9]  = love.graphics.newFont(9),
        [10] = love.graphics.newFont(10),
        [11] = love.graphics.newFont(11),
        [12] = love.graphics.newFont(12),
        [14] = love.graphics.newFont(14),
        [16] = love.graphics.newFont(16),
        [18] = love.graphics.newFont(18),
        [20] = love.graphics.newFont(20),
        [24] = love.graphics.newFont(24),
        [28] = love.graphics.newFont(28),
        [32] = love.graphics.newFont(32),
        [36] = love.graphics.newFont(36),
        [40] = love.graphics.newFont(40),
        [48] = love.graphics.newFont(48),
        [56] = love.graphics.newFont(56),
        [64] = love.graphics.newFont(64),
        [72] = love.graphics.newFont(72),
        [80] = love.graphics.newFont(80),
        [96] = love.graphics.newFont(96),

    },

    9,
    10,
    11,
    12,
    14,
    16,
    18,
    20,
    24,
    28,
    32,
    36,
    40,
    48,
    56,
    64,
    72,
    80,
    96,

    next = function(self)
        self.index = math.min(#self, self.index + 1)
    end,

    prev = function(self)
        self.index = math.max(1, self.index - 1)
    end,

    get = function(self)
        return self:getFontForSize(self:getFontSize())
    end,

    getFontSize = function(self)
        return self[self.index]
    end,

    getFontForSize = function(self, fontSize)
        return self.fontsBySize[fontSize]
    end,
}
