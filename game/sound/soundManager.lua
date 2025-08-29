return ({
    init = function(self)
        self:initSoundData()
        return self
    end,

    play = function(self, soundName)
        self.data[soundName]:play()
    end,

    data = {
        sonicBraking   = { filename = "brake.ogg", },
        sonicJumping   = { filename = "jump.ogg",  },
        sonicCDJumping = { filename = "sonicCDJump.mp3", startPoint = 19520, },
    },

    initSoundData = function(self)
        for name, element in pairs(self.data) do
            element.load = function(self)
                if self.sound == nil then
                    self.sound = love.audio.newSource("game/resources/sounds/" .. self.filename, "static")
                end
            end
            element.play = function(self)
                self:load()
                self.sound:play()
                if self.startPoint then self.sound:seek(self.startPoint, "samples") end
            end
        end
    end,
        
}):init()
