return ({
    init = function(self)
        self:initSoundData()
        return self
    end,

    play = function(self, soundName)
        self.data[soundName]:play()
    end,

    soundFiles = {
        sonicBraking   = "brake.ogg",
        sonicJumping   = "jump.ogg",
        sonicCDJumping = "sonicCDJump.mp3",
    },
        
    data       = nil,

    initSoundData = function(self)
        self.data = {}
        for k, v in pairs(self.soundFiles) do
            self.data[k] = {
                filename = v,
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
            }
        end
    end,
        
}):init()
