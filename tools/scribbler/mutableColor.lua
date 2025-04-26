return {
    index = 1,

    { 1, 1, 1 },
    { 1, 1, 0 },
    { 1, 0, 1 },
    { 1, 0, 0 },
    { 0, 1, 1 },
    { 0, 1, 0 },
    { 0, 0, 1 },
    { 0, 0, 0 },

    next = function(self)
        self.index = self.index + 1
        if self.index > #self then
            self.index = 1
        end
    end,

    get = function(self)
        return self[self.index]
    end,
}
