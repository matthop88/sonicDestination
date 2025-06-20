return {
    paused = false,

    handleKeypressed = function(self, key)
        if key == "p" then
            self.paused = not self.paused
            print("PAUSED: ", self.paused)
        end
    end,
}
