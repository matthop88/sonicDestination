return {
	create = function(self, name, data)
		return ({
			name = nil,
			data = nil,
			index = 1,

			init = function(self)
				self.data = data 
				self.name = name
				return self
			end,

			getName = function(self) return self.name end,

			next = function(self)
				local value = self.data[self.index]
				if value ~= nil then
					self.index = self.index + 1
					return value
				end
			end,

			pushBack = function(self)
				self.index = math.max(0, self.index - 1)
			end,

			getIndex     = function(self) return self.index               end,
			get          = function(self) return self.data                end,

			reset        = function(self) self.index = 1                  end,
			complete     = function(self) self.index = #self.data + 1     end,

			isComplete   = function(self) return self.index >  #self.data end,
			isProcessing = function(self) return self.index <= #self.data end,
		}):init()
	end,
}
