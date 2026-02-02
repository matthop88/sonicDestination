local COLOR = require("tools/lib/colors")

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
				love.graphics.rectangle("fill", 5, 500, 1190, 295)
				love.graphics.setColor(COLOR.PURE_WHITE)
			    love.graphics.line(  5,  795, 1195, 795)
			    love.graphics.line(1195, 795, 1195, 500)
			    love.graphics.line(  5,  500,    5, 795)
			    love.graphics.line(  5,  500,  self.TABS[1].x, 500)
			end,

			drawTabs = function(self)
				local x = 0
			    for n, t in ipairs(self.TABS) do
			    	self:drawTab(t, { isSelected = (n == self.TAB_INDEX), isHighlighted = (n == self.HIGHLIGHTED_INDEX) })
			    	x = t.x + t.w + TAB_SPACING
			    end
			    love.graphics.setColor(COLOR.PURE_WHITE)
			    love.graphics.line(x + 1, 500, 1195, 500)
			end,

			drawTab = function(self, t, params)
				if     params.isSelected    then love.graphics.setColor(COLOR.DARK_GREY)
				elseif params.isHighlighted then love.graphics.setColor(COLOR.DARK_YELLOW)
				else                             love.graphics.setColor(COLOR.VERY_DARK_GREY) end
				love.graphics.rectangle("fill", t.x, t.y, t.w, t.h)
				love.graphics.setColor(COLOR.PURE_WHITE)
				love.graphics.setFont(FONT)
			    love.graphics.line(t.x,       t.y, t.x + t.w, t.y)
			    love.graphics.line(t.x,       t.y, t.x,       t.y + t.h - 1)
			    love.graphics.line(t.x + t.w, t.y, t.x + t.w, t.y + t.h - 1)
			    if not params.isSelected then love.graphics.line(t.x + 1, 500, t.x + t.w - 1, 500) end
			    love.graphics.line(t.x + t.w, 500, t.x + t.w + TAB_SPACING, 500)
			    if not params.isSelected then 
			    	if params.isHighlighted then love.graphics.setColor(COLOR.LIGHT_YELLOW)
			        else                         love.graphics.setColor(COLOR.LIGHT_GREY) end
			    end
			    love.graphics.printf(t.title, t.x + TAB_MARGIN, 470, 500, "left")
			end,

			update = function(self, dt)
				local mx, my = love.mouse.getPosition()

				self.HIGHLIGHTED_INDEX = nil
				
				for n, t in ipairs(self.TABS) do
					if mx >= t.x and mx <= t.x + t.w and my >= t.y and my <= t.y + t.h then
						self.HIGHLIGHTED_INDEX = n
					end
				end
			end,

			handleMousepressed = function(self, mx, my)
				for n, t in ipairs(self.TABS) do
					if mx >= t.x and mx <= t.x + t.w and my >= t.y and my <= t.y + t.h then
						self.TAB_INDEX = n
					end
				end
			end,
		}
	end,
}
