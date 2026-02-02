local calculateTabData = function(tabs, attrs)
	local tabsWithMeta = {}
	local x = 100 - attrs.TAB_MARGIN
	for _, t in ipairs(tabs) do
		local w = attrs.FONT:getWidth(t) + (attrs.TAB_MARGIN * 2)
		local tabWithMeta = { title = t, x = x, y = 470, w = w, h = 30 }
		table.insert(tabsWithMeta, tabWithMeta)
		x = x + w + attrs.TAB_SPACING
	end

	return tabsWithMeta
end


return {
	create = function(self, params)
		local FONT_SIZE      = 24
		local FONT           = love.graphics.newFont(FONT_SIZE)

		local TAB_MARGIN  = params.TAB_MARGIN  or 15
		local TAB_SPACING = params.TAB_SPACING or 25

		return {
			TABS      = calculateTabData(params.TABS, { TAB_MARGIN = TAB_MARGIN, TAB_SPACING = TAB_SPACING, FONT = FONT }),
			TAB_INDEX = 1,

			draw = function(self)
    			self:drawTabFrame()
    			self:drawTabs()
			end,

			drawTabFrame = function(self)
				love.graphics.setColor(1, 1, 1)
			    love.graphics.line(  5,  795, 1195, 795)
			    love.graphics.line(1195, 795, 1195, 500)
			    love.graphics.line(  5,  500,    5, 795)
			    love.graphics.line(  5,  500,  self.TABS[1].x, 500)
			end,

			drawTabs = function(self)
				local x = 0
			    for n, t in ipairs(self.TABS) do
			    	self:drawTab(t, n == self.TAB_INDEX)
			    	x = t.x + t.w + TAB_SPACING
			    end
			    love.graphics.line(x + 1, 500, 1195, 500)
			end,

			drawTab = function(self, t, isSelected)
				love.graphics.setFont(FONT)
			    love.graphics.line(t.x,       t.y, t.x + t.w, t.y)
			    love.graphics.line(t.x,       t.y, t.x,       t.y + t.h - 1)
			    love.graphics.line(t.x + t.w, t.y, t.x + t.w, t.y + t.h - 1)
			    if not isSelected then love.graphics.line(t.x + 1, 500, t.x + t.w - 1, 500) end
			    love.graphics.line(t.x + t.w, 500, t.x + t.w + TAB_SPACING, 500)
			    love.graphics.printf(t.title, t.x + TAB_MARGIN, 470, 500, "left")
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
