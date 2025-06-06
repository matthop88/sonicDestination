return {
    index = 1,

    "Stand Left",
    "Stand Right",
    "Run Left",
    "Run Right",
    "L On",
    "L Off",
    "R On",
    "R Off",

    next = function(self)
        self.index = math.min(#self, self.index + 1)
    end,

    prev = function(self)
        self.index = math.max(1, self.index - 1)
    end,

    get = function(self)
        return self[self.index]
    end,
}
