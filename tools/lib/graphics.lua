return {
	x = 0,
	y = 0,

	setColor = function(self, color)
		love.graphics.setColor(color)
	end,

	rectangle = function(self, mode, x, y, w, h)
		love.graphics.rectangle(mode, x, y, w, h)
	end, 
}
