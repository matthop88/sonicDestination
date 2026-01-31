return {
	create = function(self, sounds)
        local soundList = {}
        for _, sound in ipairs(sounds) do
            table.insert(soundList, requireRelative("sound/simpleSound"):create(sound))
        end

		return {
			sounds = soundList,
            
            play = function(self, SOUND_MANAGER)
                for _, sound in ipairs(self.sounds) do 
                    if sound.delay then SOUND_MANAGER:addToQueue(sound)
                    else                sound:play()                end
                end
            end,
        }
    end,
}
