return {
	create = function(self, callback)
		return {
			draw = function(self)
				love.graphics.setColor(1, 1, 1)
				love.graphics.setLineWidth(1)
				love.graphics.rectangle("line", 100, 380, 1000, 40)
			end,
		}
	end,
}
