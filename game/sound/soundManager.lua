return ({
    sounds       = {},
    overrides    = {},
    queuedSounds = requireRelative("util/dataStructures/linkedList"):create(),
    volumeScalar = 1,

    actionSoundMap = {
        braking         = "sonicBraking",
        jumping         = "sonicJumping",
        collectOddRing  = "ringCollectL",
        collectEvenRing = "ringCollectR",
        giantRing       = "giantRing",
        vanish          = "vanish",
        sonicHit        = "sonicHit",
        badnikHit       = "badnikDeath",
    },

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
        sound:setVolumeScalar(self.volumeScalar)
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

    onPropertyChange = function(self, propData)
        if propData.volume and propData.volume.sounds then
            self.volumeScalar = propData.volume.sounds
        end
    end,

    setActionOverride = function(self, key, value)
        self:setOverride(self.actionSoundMap[key], value)
    end,

    overrideFromSoundProps = function(self, soundProps)
        if soundProps ~= nil then
            for action, sound in pairs(soundProps) do
                self:setActionOverride(action, sound)
            end
        end
    end,
        
}):init()
