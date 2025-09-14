local TRACER_RECORD = require("plugins/modules/tracer/tracerRecord")

return {
    toggleShowKey      = nil,
    toggleRecordingKey = nil,
    showTracer         = false,
    isRecording        = false,
    graphics           = nil,
    posAndRadiusFn     = nil,
    switchModeKey      = nil,

    tracerRecords  = {
        index = 1,

        get = function(self)
            return self[self.index]
        end,

        clear = function(self)
            for _, v in ipairs(self) do
                v:clear()
            end
        end,

        next = function(self)
            self.index = self.index + 1
            if self.index > #self then self.index = 1 end
        end,

        add = function(self, color)
            table.insert(self, TRACER_RECORD:create(color))
        end,
    },
    
    init = function(self, params)
        self.toggleShowKey      = params.toggleShowKey
        self.graphics           = params.graphics
        self.posAndRadiusFn     = params.posAndRadiusFn
        self.switchModeKey      = params.switchModeKey
        self.toggleRecordingKey = params.toggleRecordingKey

        for _, color in ipairs(params.colors) do
            self.tracerRecords:add(color)
        end
        return self
    end,

    draw = function(self)
        if self.showTracer and self.graphics ~= nil then
            for _, tracerRecord in ipairs(self.tracerRecords) do
                for n, record in tracerRecord:each() do
    				n = n + (TRACER_RECORD.EVENT_LIMIT - tracerRecord:size())
    				self.graphics:setColor(tracerRecord:getColor())
                    self.graphics:setAlpha(n / 1024)
    				self.graphics:circle("fill", record.x, record.y, record.r)
                end
            end
        end
    end,

    update = function(self, dt)
        if self.isRecording and self.posAndRadiusFn ~= nil then
            local x, y, r = self.posAndRadiusFn()
            if self:getTracerRecord():canAdd(x, y, r) then
                self:getTracerRecord():add(x, y, r)
            end
        end
    end,

    handleKeypressed = function(self, key)
        if     key == self.toggleShowKey      then
            self.showTracer  = not self.showTracer
            self.isRecording = self.showTracer

            if not self.showTracer then
                self.tracerRecords:clear()
            end
        elseif key == self.switchModeKey      then
            self.tracerRecords:next()
        elseif key == self.toggleRecordingKey then
            self.isRecording = not self.isRecording
        end
    end,

    getTracerRecord = function(self)
        return self.tracerRecords:get()
    end,
}
