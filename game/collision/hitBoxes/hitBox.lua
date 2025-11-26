return {
	create = function(self, hitBoxData)
		if hitBoxData == nil then 
			return nil
		else
			return {
				radiusX = hitBoxData.rX,
				radiusY = hitBoxData.rY,
				width   = hitBoxData.rX * 2,
				height  = hitBoxData.rY * 2,
				x       = 0,
				y       = 0,

				draw = function(self, GRAFX, color, thickness, scaleX, scaleY)
					scaleX, scaleY = (scaleX or 1), (scaleY or 1)
					GRAFX:setColor(color)
					GRAFX:setLineWidth(thickness)
					GRAFX:rectangle("line", self.x - (self.radiusX * scaleX), self.y - (self.radiusY * scaleY), self.width * scaleX, self.height * scaleY)
	            end,

	            update = function(self, x, y)
	            	self.x, self.y = x, y
	            end,
			}
		end
	end,
}
