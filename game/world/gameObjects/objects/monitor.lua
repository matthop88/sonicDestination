return {
	create = function(self)
		return {
			player = nil,
			
			getLeftEdge = function(self)
				return self.x - self:getW() / 2
			end,

			getRightEdge = function(self)
				return self.x + self:getW() / 2
			end,

			getTop = function(self)
				return (self.y - self:getH() / 2) - 3
			end,

			isPlatform = function(self)
				return true
			end,
		}
	end,
}
