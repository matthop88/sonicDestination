return {
	create = function(self)
		return {
			getLast = function(self) return self[#self] end,

			add = function(self, offset)
				if self:canAppend(offset) then
					self:getLast().size = self:getLast().size + 1
				else
					if #self == 0 or offset ~= self:getLast().offset then
						table.insert(self, { offset = offset, size = 1 })
					end
				end
			end,

			canAppend = function(self, offset)
				if #self > 0 then
					return self:canJoinTogether(self:getLast(), offset)
				end
			end,

			canJoinTogether = function(self, rect, offset)
				return rect.offset + rect.size == offset
			end,

		}
	end
}
