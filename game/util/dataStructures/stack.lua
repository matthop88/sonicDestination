return {
	create = function(self)
		return {
			list = {},

			__sz = 0,

			size = function(self) return self.__sz end,

			push = function(self, item)
				if #self.list == self:size() then table.insert(self.list, item)
				else                              self.list[self:size() + 1] = item end

				self.__sz = self.__sz + 1

				return self
			end,

			pop  = function(self)
				if self:size() == 0 then
					return nil
				else
					local item = self.list[self:size()]
					self.__sz = self.__sz - 1
					return item
				end
			end,

			peek = function(self)
				return self.list[self:size()]
			end,
		}
	end,
}
