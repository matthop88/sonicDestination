return {
    toggleShowKey  = nil,
    showTracer     = false,
    graphics       = nil,
    posAndRadiusFn = nil,
    tracerRecord   = {
        EVENT_LIMIT = 256,
        headIndex   = 1,

        add = function(self, x, y, r)
            local newEvent    = { x = math.floor(x), y = math.floor(y), r = math.floor(r) }
            local tailEvent   = self:getTail()
            if #self == 0 or tailEvent.x ~= newEvent.x or tailEvent.y ~= newEvent.y or tailEvent.r ~= newEvent.r then
                if #self < self.EVENT_LIMIT then
                    table.insert(self, newEvent)
                else
                    self[self.headIndex] = newEvent
                    self:incrementHeadIndex()
                end
            end
        end,

        getTail = function(self)
            local tailIndex = self.headIndex - 1
            if tailIndex < 1 then
                tailIndex = #self
            end
            return self[tailIndex]
        end,

        incrementHeadIndex = function(self)
            self.headIndex = self.headIndex + 1
            if self.headIndex > #self then
                self.headIndex = 1
            end
        end,
    },
    
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
