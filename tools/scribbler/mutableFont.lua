return ({
    index = 11,

    fontsBySoze = { },
        
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
    120,

    init = function(self)
        for _, fontSize in ipairs(self) do
            self.fontsBySize[fontSize] = love.graphics.newFont(fontSize)
        end
        return self
    end,

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
}):init()
