return {
	create = function(self)
		local enabled = false

		return {
			draw = function(self)
				if enabled then
					self:drawTranslucentPane()
				end
			end,

			drawTranslucentPane = function(self)
				love.graphics.setColor(0, 0, 0, 0.5)
				love.graphics.rectangle("fill", 0, 0, 1024, 768)
			end,

			enable = function(self)
				enabled = true
			end,

			disable = function(self)
				enabled = false
			end,

		}
	end,
}
