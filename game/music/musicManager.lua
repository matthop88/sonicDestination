local MUSIC_DATA = requireRelative("music/musicData")

return {
	create = function(self)
		return {
			tracks       = {},
			volumeScalar = 1,
					
			newTrack = function(self, trackName, effectName, delay, strength, echoCount)
				print(string.format("[musicManager] newTrack called: trackName=%s, effect=%s, delay=%.2f, strength=%.2f, echoCount=%d, current track count=%d", 
					trackName, tostring(effectName), delay or 0, strength or 0, echoCount or 6, #self.tracks))
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
				musicElementEcho:setDelay(delay / 4)
				musicElementEcho:setVolumeFn(function() return musicElement:getVolume() * strength end)
				musicElementEcho:setVolumeScalar(self.volumeScalar)
				table.insert(self.tracks, musicElementEcho)
			end,
		
			newEchoTrack = function(self, trackName, delay, strength, echoCount)
				echoCount = echoCount or 6
				print(string.format("[musicManager] newEchoTrack called: trackName=%s, delay=%.2f, strength=%.2f, echoCount=%d", trackName, delay, strength, echoCount))
				local musicElement = require("game/music/musicElement"):create(MUSIC_DATA, trackName)
				musicElement:setVolumeScalar(self.volumeScalar)
				table.insert(self.tracks, musicElement)
				print(string.format("[musicManager] Created main track, now have %d tracks", #self.tracks))
				
				local previousTrack = musicElement
				for i = 1, echoCount do
					local musicElementEcho = require("game/music/musicElement"):create(MUSIC_DATA, trackName)
					musicElementEcho:setEchoSource(previousTrack, delay, strength)
					musicElementEcho:setVolumeScalar(self.volumeScalar)
					table.insert(self.tracks, musicElementEcho)
					print(string.format("[musicManager] Created echo track %d (delay=%.2f sec, %d samples), now have %d tracks", 
						i, delay, delay * 44100, #self.tracks))
					previousTrack = musicElementEcho
				end
			end,
					
			play = function(self)
				print(string.format("[musicManager] play() called: playing %d tracks", #self.tracks))
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
				print(string.format("[musicManager] clear() called: clearing %d tracks", #self.tracks))
				for _, track in ipairs(self.tracks) do
					track:stop()
				end
				self.tracks = {}
			end,
						
			setVolume = function(self, volume)
				print(string.format("[musicManager] setVolume(%.2f) called: %d tracks", volume, #self.tracks))
				self.volumeScalar = volume
				for _, track in ipairs(self.tracks) do
					if not track.echoSource then
						track:setVolume(volume)
					else
						track:refreshVolume()
					end
				end
			end,
			
			setPitch = function(self, pitch)
				print(string.format("[musicManager] setPitch(%.2f) called: %d tracks", pitch, #self.tracks))
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
