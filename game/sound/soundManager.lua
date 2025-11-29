return ({
    init = function(self)
        self:initSoundData()
        return self
    end,

    play = function(self, soundName)
        self.data[soundName]:play()
    end,

    data = {
        sonicBraking   = { filename = "brake.ogg",          volume     = 0.2, },
        sonicJumping   = { filename = "jump.ogg",           volume     = 0.2, },
        sonicCDJumping = { filename = "sonicCDJump.mp3",    volume     = 0.9,  startPoint = 19520, },
        ringCollectL   = { filename = "ring-collect-L.mp3", volume     = 0.4, },
        ringCollectR   = { filename = "ring-collect-R.mp3", volume     = 0.4, },
    },

    initSoundData = function(self)
        for name, element in pairs(self.data) do
            element.load = function(self)
                if self.sound ~= nil then
                    love.audio.stop(self.sound)
                else
                    self.sound = love.audio.newSource(relativePath("resources/sounds/") .. self.filename, "static")
                end
            end
            element.play = function(self)
                self:load()
                self.sound:setVolume(self.volume or 1)
                self.sound:play()
                if self.startPoint then self.sound:seek(self.startPoint, "samples") end
            end
        end
    end,
        
}):init()
