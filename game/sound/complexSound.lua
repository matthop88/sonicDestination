return {
	create = function(self, sounds)
        local soundList = {}
        for _, sound in ipairs(sounds) do
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
            end,
        }
    end,
}
