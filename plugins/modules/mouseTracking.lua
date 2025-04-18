return {
    origX  = 0,
    origY  = 0,
    object = nil,

    init   = function(self, params)
        self.object = params.object
        self.origX  = params.originX
        self.origY  = params.originY

        return self
    end,

    draw   = function(self)
        self.object:draw()
    end,
}
