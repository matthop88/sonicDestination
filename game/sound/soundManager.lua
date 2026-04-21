return {
	create = function(self, params)
		return {
			filename     = params.filename,
			volume       = params.volume or 1,
            pitch        = params.pitch or 1,
			startPoint   = params.startPoint,
            delay        = params.delay,
            volumeScalar = 1,
            
            -- Fixed pool size: do not use #tracks here — Lua # stops at first nil, so a
            -- partially filled pool would be length 1 and round-robin would never leave slot 1.
            trackCount   = 8,
            tracks       = { nil, nil, nil, nil, nil, nil, nil, nil, },
           	trackIndex   = 1,

            load = function(self)
                if self:getSound() == nil then self:setSound(love.audio.newSource(relativePath("resources/sounds/") .. self.filename, "static")) end
                --else                      love.audio.stop(self:getSound())                                                                   end
            end,

            play = function(self)
                self:load()
                local src = self:getSound()
                src:setVolume(self.volume * self.volumeScalar)
                src:setPitch(self.pitch)
                if self.startPoint then src:seek(self.startPoint, "samples") end
                src:play()
                self:next()
            end,

            getSound = function(self) return self.tracks[self.trackIndex]         end,
            setSound = function(self, sound) self.tracks[self.trackIndex] = sound end,
            next     = function(self)
                self.trackIndex = self.trackIndex + 1
                if self.trackIndex > self.trackCount then self.trackIndex = 1 end
            end,

            setVolumeScalar = function(self, volumeScalar)
                self.volumeScalar = volumeScalar
            end,

            setVolume = function(self, volume)
                self.volume = volume
            end,

            setPitch = function(self, pitch)
                self.pitch = pitch
            end,
        }
    end,
}
