return {
    paused = false,

    handleKeypressed = function(self, key)
        if key == "p" then
            self.paused = not self.paused
        end
    end,

    update = function(self, dt)
        if self.paused then
            return true
        else
            -- do nothing
        end
    end,
}
