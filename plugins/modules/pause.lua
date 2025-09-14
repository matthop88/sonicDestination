return {
    paused   = false,
    stepping = false,

    init = function(self, params)
        self.pauseKey = params.pauseKey or "p"
        self.stepKey  = params.stepKey  or "s"
        return self
    end,

    handleKeypressed = function(self, key)
        if     key == self.pauseKey then self.paused = not self.paused
        elseif key == self.stepKey  then self.stepping = true         end
    end,

    update = function(self, dt)
        if self.paused and not self.stepping then
            return true
        else
            self.stepping = false
        end
    end,
}
