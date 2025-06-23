return {
    updateFn = nil,

    init     = function(self, parameters)
        self.updateFn = parameters.updateFn
        return self
    end,

    update  = function(self, dt)
        self.updateFn(dt)
    end,
}
