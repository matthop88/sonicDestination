return {
    index = 1,

    "Standing Left",
    "Standing Right",
    "L On",
    "R On",

    next = function(self)
        self.index = self.index + 1
        if self.index > #self then self.index = 1 end
    end,

    get = function(self)
        return self[self.index]
    end,
}
