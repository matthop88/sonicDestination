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
		__head    = nil,
		__tail    = nil,
		__size    = 0,
		__current = nil,

		head = function(self) 
			self.__current = self.__head
			return not self:isEnd()
		end,

		tail = function(self) 
			self.__current = self.__tail 
			return not self:isEnd()
		end,

		size = function(self) return self.__size end,

		add = function(self, data)
			local newLink = link:create(data)
			if self.__tail ~= nil then self.__tail:addAfter(newLink) end
			self.__tail = newLink
			if self.__head    == nil then 
				self.__head    = newLink
				self.__current = newLink
			end
			self.__size = self.__size + 1
			return self
		end,

		insert = function(self, data)
			if self.__current == nil then 
				return self:add(data)
			else
				local newLink = link:create(data)
				self.__current:addAfter(newLink)
				if self.__tail == self.__current then self.__tail = newLink end
			end
			return self
		end,

		get = function(self)
			if self.__current == nil then return nil
			else                          return self.__current:data() end
		end,

		next = function(self)
			if self.__current == nil then self.__current = self.__head
			else                          self.__current = self.__current:next() end
			
			return self
		end,

		prev = function(self)
			if self.__current == nil then self.__current = self.__tail
			else                          self.__current = self.__current:prev() end
			
			return self
		end,

		remove = function(self)
			if self.__current == nil then
				return nil
			else
				if self.__tail == self.__current then self.__tail = self.__current:prev() end
				if self.__head == self.__current then self.__head = self.__current:next() end
				local linkAfterCurrent = self.__current:next()
				local removedLink = self.__current:remove()
				self.__current = linkAfterCurrent
				self.__size = self.__size - 1
				return removedLink
			end
		end,

		isEnd = function(self) return self.__current == nil end,
	}
end

return createLinkedList()
