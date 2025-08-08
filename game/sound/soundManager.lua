return ({
    init = function(self)
        return self
    end,

    play = function(self, soundName)
        self.data[soundName]:play()
    end,

    data = {
        sonicBraking = { 
            filename = "brake.ogg",
            sound    = nil,

            load = function(self)
                if self.sound == nil then
                    self.sound = love.audio.newSource("game/resources/sounds/" .. self.filename, "static")
                end
            end,

            play = function(self)
                self:load()
                self.sound:play()
            end,
        },
    },
}):init()
