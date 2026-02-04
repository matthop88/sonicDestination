return {
	init = function(self, params)
		self.PANE_HEIGHT    = params.PANE_HEIGHT or 300
		self.FONT_SIZE      = 24
		self.WIDTH          = params.WIDTH or 1190
		self.FONT           = love.graphics.newFont(self.FONT_SIZE)
		self.GRAFX          = require("tools/lib/graphics"):create()
		self.BUFFERED_GRAFX = require("tools/lib/bufferedGraphics"):create(self.GRAFX, self.WIDTH, self.PANE_HEIGHT)
		self.TAB_MARGIN     = params.TAB_MARGIN  or 20
		self.TAB_SPACING    = params.TAB_SPACING or 15
		
		return self
    end,
}
