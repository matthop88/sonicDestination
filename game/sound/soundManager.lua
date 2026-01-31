return ({
    sounds       = {},
    overrides    = {},
    queuedSounds = requireRelative("util/dataStructures/linkedList"):create(),

    setOverride = function(self, key, value) self.overrides[key] = value end,

    init = function(self)
        self:initSoundData()
        return self
    end,

    initSoundData = function(self)
        for name, element in pairs(requireRelative("sound/soundData")) do
            if #element > 0 then self.sounds[name] = requireRelative("sound/complexSound"):create(element)
            else                 self.sounds[name] = requireRelative("sound/simpleSound"):create(element) end
        end
    end,

    play = function(self, soundName)
        if self.overrides[soundName] then soundName = self.overrides[soundName] end
        local sound = self.sounds[soundName]
        if sound.delay then self:addToQueue(sound)
        else                sound:play(self)    end
    end,

    addToQueue = function(self, sound)
        self.queuedSounds:add({ timer = sound.delay, sound = sound })
    end,

    update = function(self, dt)
        self.queuedSounds:forEach(function(delayedSound)
            delayedSound.timer = delayedSound.timer - dt
            if delayedSound.timer <= 0 then
                delayedSound.sound:play()
                self.queuedSounds:remove()
                return true
            end
        end)
    end,
        
}):init()
