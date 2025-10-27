return {
	create = function(self)
		return {
			innerList = {},
			ptr       = 0,
			listSize  = 0,

			add = function(self, elt)
				self.ptr = self.ptr + 1
				self.innerList[self.ptr] = elt
				self.listSize = self.ptr
			end,

			next = function(self)
				local result = self:getNext()
				self.ptr = math.min(self.ptr + 1, self.listSize)
				return result
			end,

			prev = function(self)
				local result = self:getPrev()
				self.ptr = math.max(self.ptr - 1, 0)
				return result
			end,

			getNext = function(self) 
				if self.ptr == self.listSize then return nil
				else                              return self.innerList[self.ptr + 1] end
			end,
			
			getPrev = function(self) return self.innerList[self.ptr]     end,
			get     = function(self) return self:getNext()               end,

			empty = function(self)
				self.innerList = {}
				self.ptr = 0
				self.listSize = 0
			end,

			size = function(self)
				return self.listSize
			end,
		}
	end,
}
