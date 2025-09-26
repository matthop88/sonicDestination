local __VOLUME = 1.0

return {
	getVolume = function(self)  return __VOLUME          end,

	setVolume = function(self, volume) __VOLUME = volume end,

	play = function(self, soundPath, name)
		local sound = love.audio.newSource(soundPath .. name .. ".mp3", "static")

		sound:setVolume(self:getVolume())
		sound:play()
	end,
	
}
