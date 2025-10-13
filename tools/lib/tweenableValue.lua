return {
	create = function(self, initialValue, params)
		params = params or {}

		return {
			value       = initialValue,
			origin      = initialValue,
			destination = initialValue,

			speed       = params.speed or 1,
			delay       = params.delay or 0,
			timer       = 0,

			get = function(self)
				return math.floor(self.value)
			end,

			setDestination = function(self, destination)
				self.destination = destination
			end,

			set = function(self, value)
				self.value       = value
				self.origin      = value
				self.destination = value
			end,

			update = function(self, dt)
				if self.timer <= self.delay then
					self.timer = self.timer + dt
				elseif self.value ~= self.destination then
					self.value = self.value + (self.destination - self.origin) * dt * self.speed
	                if math.abs(self.origin - self.value) > math.abs(self.destination - self.origin) then
	                    self.value  = self.destination
	                    self.origin = self.value
	                end 
				end
			end,
		}
	end,
}
