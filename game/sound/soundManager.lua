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
        giantRing      = { filename = "giantRing.mp3",      volume     = 0.5,  startPoint =  4352, },
        vanish         = { filename = "vanish.mp3",         volume     = 0.5,  startPoint =  3968, },
    },

    initSoundData = function(self)
        for name, element in pairs(self.data) do
            element.soundIndex = 1
            element.load = function(self)
                if self:getSound() == nil then self:setSound(love.audio.newSource(relativePath("resources/sounds/") .. self.filename, "static"))
                else                      love.audio.stop(self:getSound())                                                                   end
            end
            element.play = function(self)
                self:load()
                self:getSound():setVolume(self.volume or 1)
                self:getSound():play()
                if self.startPoint then self:getSound():seek(self.startPoint, "samples") end
            end
            element.getSound = function(self) return self.sounds[self.soundIndex]         end
            element.setSound = function(self, sound) self.sounds[self.soundIndex] = sound end
            element.next     = function(self)
                self.soundIndex = self.soundIndex + 1
                if self.soundIndex > #self.sounds then self.soundIndex = 1 end
            end
            element.sounds = { nil, nil, nil }
        end
    end,
        
}):init()
