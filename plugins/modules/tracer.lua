return {
    toggleShowKey  = nil,
    showTracer     = false,
    graphics       = nil,
    posAndRadiusFn = nil,

    init = function(self, params)
        self.toggleShowKey  = params.toggleShowKey
        self.graphics       = params.graphics
        self.posAndRadiusFn = params.posAndRadiusFn
        return self
    end,

    draw = function(self)
        if self.showTracer and self.graphics ~= nil and self.posAndRadiusFn ~= nil then
            local x, y, r = self.posAndRadiusFn()
            self.graphics:setColor(1, 1, 0)
            self.graphics:circle("fill", x, y, r)
        end
    end,

    update = function(self, dt)
        -- Do nothing
    end,

    handleKeypressed = function(self, key)
        if key == self.toggleShowKey then
            self.showTracer = not self.showTracer
            print("Show Tracer set to:", self.showTracer)
        end
    end,
}
