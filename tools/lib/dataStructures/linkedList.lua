local link = {
	create = function(self, data)
		return {
			__next = nil,
			__prev = nil,
			__data = data,

			next = function(self) return self.__next end,
			prev = function(self) return self.__prev end,
			data = function(self) return self.__data end,
		}
	end,
}

local createLinkedList = function()
	return {
		-- Some implementation
	}
end

return createLinkedList()
