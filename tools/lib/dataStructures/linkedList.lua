local cell = {
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

			addBefore = function(self, newCell)
				if self.__prev then self.__prev:setNext(newCell) end
				newCell:setPrev(self.__prev)
				newCell:setNext(self)
				self.__prev = newCell
				return newCell
			end,

			addAfter = function(self, newCell)
				if self.__next then self.__next:setPrev(newCell) end
				newCell:setNext(self.__next)
				newCell:setPrev(self)
				self.__next = newCell
				return newCell
			end,
		}
	end,
}

return {
	create = function(self)
		return {
			__head    = nil,
			__tail    = nil,
			__size    = 0,
			__current = nil,

			head = function(self) 
				self.__current = self.__head
				return self
			end,

			tail = function(self) 
				self.__current = self.__tail 
				return self
			end,

			size = function(self) return self.__size end,

			add = function(self, data)
				local newCell = cell:create(data)
				if self.__tail ~= nil then self.__tail:addAfter(newCell) end
				self.__tail = newCell
				if self.__head    == nil then 
					self.__head    = newCell
					self.__current = newCell
				end
				self.__size = self.__size + 1
				return self
			end,

			insert = function(self, data)
				if self.__current == nil then 
					return self:add(data)
				else
					local newCell = cell:create(data)
					self.__current:addAfter(newCell)
					if self.__tail == self.__current then self.__tail = newCell end
					self.__current = newCell
					self.__size = self.__size + 1
				end
				return self
			end,

			get = function(self)
				if self.__current == nil then return nil
				else                          return self.__current:data() end
			end,

			next = function(self)
				if self.__current ~= nil then self.__current = self.__current:next() end
				
				return self
			end,

			getNext = function(self)
				local result = self:get()
				self:next()
				return result
			end,

			prev = function(self)
				if self.__current ~= nil then self.__current = self.__current:prev() end
				
				return self
			end,

			remove = function(self)
				if self.__current == nil then
					return nil
				else
					if self.__tail == self.__current then self.__tail = self.__current:prev() end
					if self.__head == self.__current then self.__head = self.__current:next() end
					local cellAfterCurrent = self.__current:next()
					local removedCell = self.__current:remove()
					self.__current = cellAfterCurrent
					self.__size = self.__size - 1
					return removedCell:data()
				end
			end,

			isEnd = function(self) return self.__current == nil end,
		}
	end,
}
