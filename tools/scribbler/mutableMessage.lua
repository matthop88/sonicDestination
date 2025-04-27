return {
    index = 1,

    "Standing Left",
    "Standing Right",
    "L On",
    "R On",

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
