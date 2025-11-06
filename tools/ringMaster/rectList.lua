return {
	create = function(self)
		return {
			getLast = function(self) return self[#self] end,

			add = function(self, x)
				if self:canAppend(x) then
					self:getLast().w = self:getLast().w + 1
				else
					if #self == 0 or x ~= self:getLast().x then
						table.insert(self, { x = x, w = 1 })
					end
				end
			end,

			canAppend = function(self, x)
				if #self > 0 then
					return self:canJoinTogether(self:getLast(), x)
				end
			end,

			canJoinTogether = function(self, rect, x)
				return rect.x + rect.w == x
			end,

		}
	end
}
