-- FEEDER creates an indexable wrapper around a data set.
-- If it is a list (size of > 0), simple.
-- If it is not a list (table with size of 0 or a non-table), inserts into table prior to wrapping.

return {
	create = function(self, data)
		return {
			data = nil,
			index = 1,

			init = function(self)
				self.data = { },
				if type(data) == "table" and #data > 0 then 
					for _, d in ipairs(data) do table.insert(self.data, d) end
				else                                        
					self.data = { data } 
				end
			end,

			next = function(self)
				local value = self.data[self.index]

				self.index = self.index + 1
				return value
			end,

			reset        = function(self) self.index = 1                  end,
			complete     = function(self) self.index = #self.data + 1     end,

			isComplete   = function(self) return self.index >  #self.data end,
			isProcessing = function(self) return self.index <= #self.data end,
		}
	end,
}
