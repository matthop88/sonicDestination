return {
	create = function(self, params)
		local FONT_SIZE      = 24
		local FONT           = love.graphics.newFont(FONT_SIZE)

		local TAB_MARGIN  = params.TAB_MARGIN  or 15
		local TAB_SPACING = params.TAB_SPACING or 40

		return {
			TABS      = params.TABS or { "Sample", "TabPanel", "Tabs" },
			TAB_INDEX = 1,

			draw = function(self)
    			love.graphics.setColor(1, 1, 1)
			    love.graphics.line(  5,  795, 1195, 795)
			    love.graphics.line(1195, 795, 1195, 500)
			    love.graphics.line(  5,  500,    5, 795)
			    love.graphics.line(  5,  500,  100 - TAB_MARGIN, 500)

			    love.graphics.setFont(FONT)
			    local x = 100
			    local index = 1
			    for _, t in ipairs(self.TABS) do
			        local w = FONT:getWidth(t)
			        love.graphics.line(x - TAB_MARGIN,     470, x + w + TAB_MARGIN, 470)
			        love.graphics.line(x - TAB_MARGIN,     470, x - TAB_MARGIN,     499)
			        love.graphics.line(x + w + TAB_MARGIN, 470, x + w + TAB_MARGIN, 499)
			        if index ~= self.TAB_INDEX then
			            love.graphics.line(x - TAB_MARGIN + 1, 500, x + w + TAB_MARGIN - 1, 500)
			        end
			        love.graphics.line(x + w + TAB_MARGIN, 500, x + w + TAB_SPACING - TAB_MARGIN, 500)
			        index = index + 1
			        love.graphics.printf(t, x, 470, 500, "left")
			        x = x + w + TAB_SPACING
			    end
			    love.graphics.line(x - TAB_MARGIN + 1, 500, 1195, 500)
			end,

			next = function(self)
				self.TAB_INDEX = self.TAB_INDEX + 1
				if self.TAB_INDEX > #self.TABS then self.TAB_INDEX = 1 end
			end,

			prev = function(self)
				self.TAB_INDEX = self.TAB_INDEX - 1
				if self.TAB_INDEX < 1 then self.TAB_INDEX = #self.TABS end
			end,
		}
	end,
}
