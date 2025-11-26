return {
	create = function(self, radiusX, radiusY)
		return {
			radiusX = radiusX,
			radiusY = radiusY,
			width   = radiusX * 2,
			height  = radiusY * 2,

			draw = function(self, GRAFX, x, y, color, thickness, scaleX, scaleY)
				scaleX, scaleY = (scaleX or 1), (scaleY or 1)
				GRAFX:setColor(color)
				GRAFX:setLineWidth(thickness)
				GRAFX:rectangle("line", x - (self.radiusX * scaleX), y - (self.radiusY * scaleY), self.width * scaleX, self.height * scaleY)
            end,
		}
	end,
}
