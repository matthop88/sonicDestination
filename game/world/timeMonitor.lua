return {
	create = function(self, SOUND_MANAGER)
		return {
			timeModifier     = 1,
			timeModifierGoal = 1,
			rateOfChange     = 0.5,
			timer            = nil,
			soundPlayed      = false,

			getTimeModifier = function(self)
				return self.timeModifier
			end,

			setTimeModifier = function(self, value)
				self.timeModifierGoal = value
				if value ~= 1 then
					self.timer = 20
				end
			end,

			update = function(self, dt)
				if self.timeModifier > self.timeModifierGoal then
					self.timeModifier = math.max(self.timeModifierGoal, self.timeModifier - (self.rateOfChange * dt))
				elseif self.timeModifier < self.timeModifierGoal then
					self.timeModifier = math.min(self.timeModifierGoal, self.timeModifier + (self.rateOfChange * dt))
				end
				if self.timer then
					self.timer = self.timer - dt
					if self.timer < 2 and not self.soundPlayed then
						SOUND_MANAGER:playAction("timeMonitorDone")
						self.soundPlayed = true
					end
					if self.timer < 0 then
						self.timer = nil
						self:setTimeModifier(1)
					end
				end
			end,
		}
	end,
}
