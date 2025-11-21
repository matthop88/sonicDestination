local link = {
	create = function(self, data)
		return {
			__next = nil,
			__prev = nil,
			__data = data,

			next = function(self) return self.__next end,
			prev = function(self) return self.__prev end,
			data = function(self) return self.__data end,

			setNext = function(self, next) self.__next = next end,
			setPrev = function(self, prev) self.__prev = prev end,
			setData = function(self, data) self.__data = data end,

			remove  = function(self)
				if self.__prev then self.__prev:setNext(self.__next) end
				if self.__next then self.__next:setPrev(self.__prev) end
				self.__prev = nil
				self.__next = nil
				return self
			end,

			addBefore = function(self, newLink)
				if self.__prev then self.__prev:setNext(newLink) end
				newLink:setPrev(self.__prev)
				newLink:setNext(self)
				self.__prev = newLink
				return newLink
			end,

			addAfter = function(self, newLink)
				if self.__next then self.__next:setPrev(newLink) end
				newLink:setNext(self.__next)
				newLink:setPrev(self)
				self.__next = newLink
				return newLink
			end,
		}
	end,
}

local createLinkedList = function()
	return {
		-- Some implementation
	}
end

return createLinkedList()
