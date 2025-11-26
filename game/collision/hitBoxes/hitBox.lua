return {
	create = function(self, hitBoxData)
		if hitBoxData == nil then 
			return nil
		else
			return {
				radiusX          = hitBoxData.rX,
				radiusY          = hitBoxData.rY,
				width            = hitBoxData.rX * 2,
				height           = hitBoxData.rY * 2,
				x                = 0,
				y                = 0,

				lastIntersection = nil,

				draw = function(self, GRAFX, color, thickness, scaleX, scaleY)
					scaleX, scaleY = (scaleX or 1), (scaleY or 1)
					if self:intersectsLast() then GRAFX:setColor(1, 1, 1)
					else                          GRAFX:setColor(color)  end
					GRAFX:setLineWidth(thickness)
					GRAFX:rectangle("line", self.x - (self.radiusX * scaleX), self.y - (self.radiusY * scaleY), self.width * scaleX, self.height * scaleY)
	            end,

	            update = function(self, x, y)
	            	self.x, self.y = x, y
	            end,

	            intersectsIntern = function(self, otherHitBox)
	            	return self.x + self.radiusX  > otherHitBox.x - otherHitBox.radiusX
	            	   and self.x - self.radiusX  < otherHitBox.x + otherHitBox.radiusX
	            	   and self.y + self.radiusY  > otherHitBox.y - otherHitBox.radiusY
	            	   and self.y - self.radiusY  < otherHitBox.y + otherHitBox.radiusY
	            end,

	            intersects = function(self, otherHitBox)
	            	local result = self:intersectsIntern(otherHitBox)
	            	if result then self.lastIntersection = otherHitBox end
	            	return result
	            end,

	            intersectsLast = function(self)
	            	if self.lastIntersection and self:intersectsIntern(self.lastIntersection) then
	            		return true
	            	else
	            		self.lastIntersection = nil
	            		return false
	            	end
	            end,

	            setLastIntersectionWith = function(self, object)
	            	if object == nil then self.lastIntersection = nil
	            	else                  self.lastIntersection = object:getHitBox() end
	            end,

			}
		end
	end,
}
