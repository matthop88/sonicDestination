return ({
    sounds    = {},
    overrides = {},

    init = function(self)
        self:initSoundData()
        return self
    end,

    play = function(self, soundName)
        if self.overrides[soundName] then soundName = self.overrides[soundName] end
        self.sounds[soundName]:play()
    end,

    setOverride    = function(self, key, value) self.overrides[key] = value end,

    initSoundData = function(self)
        for name, element in pairs(requireRelative("sound/soundData")) do
            self.sounds[name] = requireRelative("sound/simpleSound"):create(element)
        end
    end,
        
}):init()
