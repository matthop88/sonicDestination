local MUSIC_DATA = requireRelative("music/musicData")

return {
	create = function(self)
		return {
			tracks       = {},
			volumeScalar = 1,
			
			newTrack = function(self, trackName)
				local musicElement = require("game/music/musicElement"):create(MUSIC_DATA, trackName)
				table.insert(self.tracks, musicElement)
				musicElement:setVolumeScalar(self.volumeScalar)
				return musicElement
			end,
			
			play = function(self)
				for _, track in ipairs(self.tracks) do
					track:play()
				end
			end,
			
			stop = function(self)
				for _, track in ipairs(self.tracks) do
					track:stop()
				end
			end,
			
			pause = function(self)
				for _, track in ipairs(self.tracks) do
					track:pause()
				end
			end,
			
			update = function(self, dt)
				for _, track in ipairs(self.tracks) do
					track:update(dt)
				end
			end,
			
			clear = function(self)
				for _, track in ipairs(self.tracks) do
					track:stop()
				end
				self.tracks = {}
			end,
			
			setVolume = function(self, volume)
				self.volumeScalar = volume
				for _, track in ipairs(self.tracks) do
					track:setVolume(volume)
				end
			end,
	
			onPropertyChange = function(self, propData)
				if propData.volume and propData.volume.music then
					self.volumeScalar = propData.volume.music
					for _, track in ipairs(self.tracks) do
						track:setVolumeScalar(self.volumeScalar)
					end
				end
			end,
		}
	end,
}
