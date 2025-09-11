return {
    toggleShowKey  = nil,
    showTracer     = false,
    graphics       = nil,
    posAndRadiusFn = nil,
    tracerRecord   = {
        EVENT_LIMIT = 256,
        headIndex   = 1,

        records = {},

        each  = function(self)        return ipairs(self.records) end,
        size  = function(self)        return #self.records        end,
        get   = function(self, index) return self.records[index]  end,

        clear = function(self)        
            self.records = {}           
            headIndex = 1
        end,
        
        add = function(self, x, y, r)
            local newEvent    = { x = math.floor(x), y = math.floor(y), r = math.floor(r) }
            if self:size() < self.EVENT_LIMIT then
                table.insert(self.records, newEvent)
            else
                self.records[self.headIndex] = newEvent
                self:incrementHeadIndex()
            end
        end,

        canAdd = function(self, x, y, r)
            local tailEvent = self:getTail()
            return self:size() == 0 
                or tailEvent.x ~= math.floor(x) 
                or tailEvent.y ~= math.floor(y) 
                or tailEvent.r ~= math.floor(r)
        end,

        getTail = function(self)
            local tailIndex = self.headIndex - 1
            if tailIndex < 1 then
                tailIndex = self:size()
            end
            return self:get(tailIndex)
        end,

        incrementHeadIndex = function(self)
            self.headIndex = self.headIndex + 1
            if self.headIndex > self:size() then
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
        if self.showTracer and self.graphics ~= nil then
            self.graphics:setColor(1, 1, 0)
            for _, record in self.tracerRecord:each() do
                self.graphics:circle("fill", record.x, record.y, record.r)
            end
        end
    end,

    update = function(self, dt)
        if self.showTracer and self.posAndRadiusFn ~= nil then
            local x, y, r = self.posAndRadiusFn()
            if self.tracerRecord:canAdd(x, y, r) then
                self.tracerRecord:add(x, y, r)
            end
        end
    end,

    handleKeypressed = function(self, key)
        if key == self.toggleShowKey then
            self.showTracer = not self.showTracer
            if not self.showTracer then
                self.tracerRecord:clear()
            end
        end
    end,
}
