return {
    toggleShowKey = nil,
    showTracer    = false,
    graphics      = nil,

    init = function(self, params)
        self.toggleShowKey = params.toggleShowKey
        self.graphics      = params.graphics
        return self
    end,

    draw = function(self)
        if self.showTracer then
            -- Drawing happens here
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
