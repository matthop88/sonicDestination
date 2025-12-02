return {
	build = function(self, stages)
		stages.index = 1

		stages.get       = function(self) return self[self.index]                      end
		stages.next      = function(self) self.index = math.min(self.index + 1, #self) end
		stages.completed = function(self) return self.index == #self                   end
	
		stages.readyForNext    = function(self, timer)
			local stage = self:get()
			return stage.duration and timer > stage.duration
		end

		stages.activateCurrent = function(self) 
			if self:get().activate then self:get():activate() end
		end

		return stages
	end,
}
