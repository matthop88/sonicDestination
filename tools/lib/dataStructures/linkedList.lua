local CELL_ID = 0

local cell = {
	create = function(self, data)
		CELL_ID = CELL_ID + 1

		return {
			__id   = CELL_ID,
			__next = nil,
			__prev = nil,
			__data = data,

			init = function(self, data)
				self.__next = nil
				self.__prev = nil
				self.__data = data
			end,

			next = function(self) return self.__next end,
			prev = function(self) return self.__prev end,
			data = function(self) return self.__data end,
			id   = function(self) return self.__id   end,

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
			__stack   = require("tools/lib/dataStructures/stack"):create(),
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

			newCell = function(self, data)
				local newCell = self.__stack:pop()
				if newCell == nil then newCell = cell:create(data)
				else                   newCell:init(data)      end
				return newCell
			end,

			add = function(self, data)
				local newCell = self:newCell(data)

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
					local newCell = self:newCell(data)
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

			getCellID = function(self)
				if self.__current == nil then return nil
				else                          return self.__current:id() end
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
					self.__stack:push(removedCell)
					return removedCell:data()
				end
			end,

			isEnd = function(self) return self.__current == nil end,
		}
	end,
}
