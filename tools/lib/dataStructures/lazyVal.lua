return {
	create = function(self)
		return {
			value = nil,

			isValid = function(self)
				return self.value ~= nil
			end,

			get     = function(self)
				return self.value
			end,

			set     = function(self, value)
				self.value = value
			end,
		}
	end,
}
