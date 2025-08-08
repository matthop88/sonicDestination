return ({
    init = function(self)
        return self
    end,

    data = {
        sonicBraking = { 
            filename = "brake.ogg",
            sound    = nil,

            load     = function(self)
                if self.sound == nil then
                    self.sound = love.audio.newSource("game/resources/sounds/" .. self.filename, "static")
                end
            end,
        },
    },
}):init()
