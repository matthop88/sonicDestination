return {
	create = function(self, sounds)
        local soundList = {}
        for _, sound in ipairs(sounds) do
            sound.effect = sounds.effect
            table.insert(soundList, requireRelative("sound/simpleSound"):create(sound))
        end

		return {
			sounds       = soundList,
            volumeScalar = 1,
            
            play = function(self, SOUND_MANAGER)
                for _, sound in ipairs(self.sounds) do 
                    sound:setVolumeScalar(self.volumeScalar)
                    if sound.delay then SOUND_MANAGER:addToQueue(sound)
                    else                sound:play()                end
                end
            end,

            setVolumeScalar = function(self, volumeScalar)
                self.volumeScalar = volumeScalar
                for _, sound in ipairs(self.sounds) do
                    sound:setVolumeScalar(volumeScalar)
                end
            end,

            setVolume = function(self, volume)
                for _, sound in ipairs(self.sounds) do
                    sound:setVolume(volume)
                end
            end,

            setPitch = function(self, pitch)
                for _, sound in ipairs(self.sounds) do
                    sound:setPitch(pitch)
                end
            end,

            update = function(self, dt)
                for _, sound in ipairs(self.sounds) do
                    if sound.update then sound:update(dt) end
                end
            end,
        }
    end,
}
