local next = function(self)
	self.ndx = self.ndx + 1
	if self.ndx > self:size() then self.ndx = 1 end
end

local prev = function(self)
	self.ndx = self.ndx - 1
	if self.ndx < 1 then self.ndx = self:size() end
end

local size = function(self)
	return #self.list
end

local get = function(self)
	return self.list[self.ndx]
end

local index = function(self)
	return self.ndx
end

return {
	create = function(self, baseList)
		return {
			list  = baseList,
			ndx = 1,

			next  = next,
			prev  = prev,
			size  = size,
			get   = get,
			index = index,
		}
	end,
}
