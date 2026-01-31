return {
	create = function(self, params)
		return {
			filename   = params.filename,
			volume     = params.volume or 1,
			startPoint = params.startPoint,
            delay      = params.delay,
            
            tracks     = { nil, nil, nil },
           	trackIndex = 1,

            load = function(self)
                if self:getSound() == nil then self:setSound(love.audio.newSource(relativePath("resources/sounds/") .. self.filename, "static"))
                else                      love.audio.stop(self:getSound())                                                                   end
            end,

            play = function(self)
                self:load()
                self:getSound():setVolume(self.volume)
                self:getSound():play()
                if self.startPoint then self:getSound():seek(self.startPoint, "samples") end
                self:next()
            end,

            getSound = function(self) return self.tracks[self.trackIndex]         end,
            setSound = function(self, sound) self.tracks[self.trackIndex] = sound end,
            next     = function(self)
                self.trackIndex = self.trackIndex + 1
                if self.trackIndex > #self.tracks then self.trackIndex = 1 end
            end,
        }
    end,
}
