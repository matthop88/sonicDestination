local COLOR = require("tools/lib/colors")

local calculateTabData = function(tabs, attrs)
	local tabsWithMeta = {}
	local x = 0
	for _, t in ipairs(tabs) do
		local w = attrs.FONT:getWidth(t) + (attrs.TAB_MARGIN * 2)
		local tabWithMeta = { label = t, x = x, w = w }
		table.insert(tabsWithMeta, tabWithMeta)
		x = x + w + attrs.TAB_SPACING
	end
	local xOffsetToCenter = 600 - (x / 2)
	for _, t in ipairs(tabsWithMeta) do t.x = t.x + xOffsetToCenter end

	tabsWithMeta.y = 760
	tabsWithMeta.h = 30
	return tabsWithMeta
end


return {
	create = function(self, params)
		local FONT_SIZE      = 24
		local FONT           = love.graphics.newFont(FONT_SIZE)

		local TAB_MARGIN  = params.TAB_MARGIN  or 20
		local TAB_SPACING = params.TAB_SPACING or 15

		return {
			TABS              = calculateTabData(params.TABS, { TAB_MARGIN = TAB_MARGIN, TAB_SPACING = TAB_SPACING, FONT = FONT }),
			TAB_INDEX         = 1,
			HIGHLIGHTED_INDEX = 0,

			draw = function(self)
    			self:drawTabFrame()
    			self:drawTabs()
			end,

			drawTabFrame = function(self)
				love.graphics.setColor(COLOR.DARK_GREY)
				love.graphics.rectangle("fill", 5, self.TABS.y + self.TABS.h, 1190, 295)
				love.graphics.setColor(COLOR.PURE_WHITE)
			    love.graphics.line(  5,  self.TABS.y + self.TABS.h + 295, 1195, self.TABS.y + self.TABS.h + 295)
			    love.graphics.line(1195, self.TABS.y + self.TABS.h + 295, 1195, self.TABS.y + self.TABS.h)
			    love.graphics.line(  5,  self.TABS.y + self.TABS.h,    5, self.TABS.y + self.TABS.h + 295)
			    love.graphics.line(  5,  self.TABS.y + self.TABS.h,  self.TABS[1].x, self.TABS.y + self.TABS.h)
			end,

			drawTabs = function(self)
				local x = 0
			    for n, t in ipairs(self.TABS) do
			    	self:drawTab(t, { isSelected = (n == self.TAB_INDEX), isHighlighted = (n == self.HIGHLIGHTED_INDEX) })
			    	x = t.x + t.w + TAB_SPACING
			    end
			    love.graphics.setColor(COLOR.PURE_WHITE)
			    love.graphics.line(x + 1, self.TABS.y + self.TABS.h, 1195, self.TABS.y + self.TABS.h)
			end,

			drawTab = function(self, t, params)
				self:drawTabBackground(t, params)
				self:drawTabOutline(t, params)
			    self:drawTabLabel(t, params)
			end,

			drawTabBackground = function(self, t, params)
				love.graphics.setColor(self:getBGColor(params))
				love.graphics.rectangle("fill", t.x, self.TABS.y, t.w, self.TABS.h)
			end,

			drawTabOutline = function(self, t, params)
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.line(t.x,       self.TABS.y, t.x + t.w, self.TABS.y)
			    love.graphics.line(t.x,       self.TABS.y, t.x,       self.TABS.y + self.TABS.h - 1)
			    love.graphics.line(t.x + t.w, self.TABS.y, t.x + t.w, self.TABS.y + self.TABS.h - 1)
			    if not params.isSelected then love.graphics.line(t.x + 1, self.TABS.y + self.TABS.h, t.x + t.w - 1, self.TABS.y + self.TABS.h) end
			    love.graphics.line(t.x + t.w, self.TABS.y + self.TABS.h, t.x + t.w + TAB_SPACING, self.TABS.y + self.TABS.h)
			end,

			drawTabLabel = function(self, t, params)
				love.graphics.setFont(FONT)
				love.graphics.setColor(self:getLabelColor(params))
			    love.graphics.printf(t.label, t.x + TAB_MARGIN, self.TABS.y, 500, "left")
			end,

			update = function(self, dt)
				local mx, my = love.mouse.getPosition()

				self.HIGHLIGHTED_INDEX = nil
				
				for n, t in ipairs(self.TABS) do
					if mx >= t.x and mx <= t.x + t.w and my >= self.TABS.y and my <= self.TABS.y + self.TABS.h then
						self.HIGHLIGHTED_INDEX = n
					end
				end
			end,

			handleMousepressed = function(self, mx, my, params)
				for n, t in ipairs(self.TABS) do
					if mx >= t.x and mx <= t.x + t.w and my >= self.TABS.y and my <= self.TABS.y + self.TABS.h then
						self.TAB_INDEX = n
					end
				end
				if params.doubleClicked then
					self.TABS.y = 1230 - self.TABS.y
				end
			end,

			getBGColor = function(self, params)
				if     params.isSelected    then return COLOR.DARK_GREY
				elseif params.isHighlighted then return COLOR.DARK_YELLOW
				else                             return COLOR.VERY_DARK_GREY  end
			end,

			getLabelColor = function(self, params)
				if     params.isSelected    then return COLOR.PURE_WHITE
				elseif params.isHighlighted then return COLOR.LIGHT_YELLOW
				else                             return COLOR.LIGHT_GREY      end
			end,
		}
	end,
}
