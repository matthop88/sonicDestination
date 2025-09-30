return {
    timedFunctions = {},
    timer          =  0,

    init   = function(self, params)
        self.timedFunctions = params
    end,

    update = function(self, dt)
        self.timer = self.timer + dt
        for _, timedFn in ipairs(self.timedFunctions) do
            self:processTimedFunction(timedFn)
        end
    end,

    processTimedFunction = function(self, timedFn)
        if not timedFn.activated and self.timer >= timedFn.secondsWait then
            timedFn.callback()
            timedFn.activated = true
        end
    end,
}
