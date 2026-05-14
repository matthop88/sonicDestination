local MUSIC_DATA = requireRelative("music/musicData")

return {
	create = function(self)
		return {
			tracks       = {},
			volumeScalar = 1,
							
			newTrack = function(self, trackName, effectName, delay, strength, echoCount)
				if effectName == "Reverb" then
					self:newReverbTrack(trackName, delay, strength)
				elseif effectName == "Echo" then
					self:newEchoTrack(trackName, delay, strength, echoCount)
				else
					local musicElement = require("game/music/musicElement"):create(MUSIC_DATA, trackName)
					table.insert(self.tracks, musicElement)
					musicElement:setVolumeScalar(self.volumeScalar)
					return musicElement
				end
			end,
		
			newReverbTrack = function(self, trackName, delay, strength)
				local musicElement = require("game/music/musicElement"):create(MUSIC_DATA, trackName)
				musicElement:setVolumeScalar(self.volumeScalar)
				table.insert(self.tracks, musicElement)
				local musicElementEcho = require("game/music/musicElement"):create(MUSIC_DATA, trackName)
				musicElementEcho:setEchoSource(musicElement, delay / 2, strength)
				musicElementEcho:setVolumeScalar(self.volumeScalar)
				table.insert(self.tracks, musicElementEcho)
			end,
				
			newEchoTrack = function(self, trackName, delay, strength, echoCount)
				echoCount = echoCount or 6
				local musicElement = require("game/music/musicElement"):create(MUSIC_DATA, trackName)
				musicElement:setVolumeScalar(self.volumeScalar)
				table.insert(self.tracks, musicElement)
				
				local previousTrack = musicElement
				for i = 1, echoCount do
					local musicElementEcho = require("game/music/musicElement"):create(MUSIC_DATA, trackName)
					musicElementEcho:setEchoSource(previousTrack, delay * 4, strength)
					musicElementEcho:setVolumeScalar(self.volumeScalar)
					table.insert(self.tracks, musicElementEcho)
					previousTrack = musicElementEcho
				end
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
				for _, track in ipairs(self.tracks) do
					if not track.echoSource then
						track:setVolume(volume * self.volumeScalar)
					else
						track:refreshVolume()
					end
				end
			end,
					
			setPitch = function(self, pitch)
				for _, track in ipairs(self.tracks) do
					track:setPitch(pitch)
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
