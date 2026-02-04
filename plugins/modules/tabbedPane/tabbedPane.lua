local COLOR = require("tools/lib/colors")

local createTabData = function(tabs, attrs)
	local tabData = {}
	local x = 0
	for _, tab in ipairs(tabs) do
		local t = tab.label
		local w = attrs.FONT:getWidth(t) + (attrs.TAB_MARGIN * 2)
		local tabWithMeta = { label = t, x = x, w = w, panel = tab.panel }
		table.insert(tabData, tabWithMeta)
		x = x + w + attrs.TAB_SPACING
	end
	local xOffsetToCenter = (attrs.WIDTH / 2) - (x / 2)
	for _, t in ipairs(tabData) do t.x = t.x + xOffsetToCenter end

	tabData.y = require("tools/lib/tweenableValue"):create(attrs.HEIGHT - 40, { speed = 12 })
	tabData.h = 30
	tabData.opened = false
	return tabData
end

return {
	init = function(self, params)
		local FONT_SIZE  = 24
		self.FONT        = love.graphics.newFont(FONT_SIZE)

		self.WIDTH       = params.WIDTH       or 1200
		self.HEIGHT      = params.HEIGHT      or 800
		self.PANE_HEIGHT = params.PANE_HEIGHT or 300
		
		self.TAB_MARGIN  = params.TAB_MARGIN  or 20
		self.TAB_SPACING = params.TAB_SPACING or 15
		
		local GRAFX      = require("tools/lib/graphics"):create()
		self.graphics    = require("tools/lib/bufferedGraphics"):create(GRAFX, self.WIDTH, self.PANE_HEIGHT)
		
		self.TABS        = createTabData(params.TABS, 
							{
		 						TAB_MARGIN  = self.TAB_MARGIN, 
		 						TAB_SPACING = self.TAB_SPACING, 
		 						FONT        = self.FONT,
		 						WIDTH       = self.WIDTH,
		 						HEIGHT      = self.HEIGHT,
		 					})

		return self
    end,

    TAB_INDEX         = 1,
	HIGHLIGHTED_INDEX = 0,

	getTabsY      = function(self) return self.TABS.y:get()             end,
	getTabsBottom = function(self) return self:getTabsY() + self.TABS.h end,

	draw = function(self)
    	self:drawTabFrame()
    	self:drawTabs()
    	if self.TABS[self.TAB_INDEX].panel then self.graphics:blitToScreen(5, self.TABS.y:get() + 30) end
	end,

	drawTabFrame = function(self)
		love.graphics.setColor(self:getBGColor({ isSelected = true }))
		love.graphics.rectangle("fill", 5, self:getTabsBottom(), self.WIDTH - 10, self.PANE_HEIGHT)
		love.graphics.setColor(COLOR.PURE_WHITE)
	    love.graphics.line(             5,  self:getTabsBottom() + self.PANE_HEIGHT, self.WIDTH - 5, self:getTabsBottom() + self.PANE_HEIGHT)
	    love.graphics.line(self.WIDTH - 5,  self:getTabsBottom() + self.PANE_HEIGHT, self.WIDTH - 5, self:getTabsBottom())
	    love.graphics.line(             5,  self:getTabsBottom(),                                 5, self:getTabsBottom() + self.PANE_HEIGHT)
	    love.graphics.line(             5,  self:getTabsBottom(),                    self.TABS[1].x, self:getTabsBottom())
	end,

	drawTabs = function(self)
		local x = 0
	    for n, t in ipairs(self.TABS) do
	    	self:drawTab(t, { isSelected = (n == self.TAB_INDEX), isHighlighted = (n == self.HIGHLIGHTED_INDEX) })
	    	x = t.x + t.w + self.TAB_SPACING
	    end
	    love.graphics.setColor(COLOR.PURE_WHITE)
	    love.graphics.line(x + 1, self:getTabsBottom(), 1195, self:getTabsBottom())
	end,

	drawTab = function(self, t, params)
		self:drawTabBackground(t, params)
		self:drawTabOutline(t, params)
	    self:drawTabLabel(t, params)
	    if t.panel then self:drawPanel(t.panel) end
	end,

	drawTabBackground = function(self, t, params)
		love.graphics.setColor(self:getBGColor(params))
		love.graphics.rectangle("fill", t.x, self:getTabsY(), t.w, self.TABS.h)
	end,

	drawTabOutline = function(self, t, params)
		love.graphics.setColor(COLOR.PURE_WHITE)
		love.graphics.setLineWidth(1)
		love.graphics.line(t.x,       self:getTabsY(), t.x + t.w, self:getTabsY())
	    love.graphics.line(t.x,       self:getTabsY(), t.x,       self:getTabsBottom() - 1)
	    love.graphics.line(t.x + t.w, self:getTabsY(), t.x + t.w, self:getTabsBottom() - 1)
	    if not params.isSelected or not self.TABS.opened then love.graphics.line(t.x + 1, self:getTabsBottom(), t.x + t.w - 1, self:getTabsBottom()) end
	    love.graphics.line(t.x + t.w, self:getTabsBottom(), t.x + t.w + self.TAB_SPACING, self:getTabsBottom())
	end,

	drawTabLabel = function(self, t, params)
		love.graphics.setFont(self.FONT)
		love.graphics.setColor(self:getLabelColor(params))
	    love.graphics.printf(t.label, t.x + self.TAB_MARGIN, self:getTabsY(), 500, "left")
	end,

	drawPanel = function(self, panel)
		panel:draw(self.graphics)
	end,

	update = function(self, dt)
		local mx, my = love.mouse.getPosition()

		self.HIGHLIGHTED_INDEX = nil
		
		if self.TABS.opened then
			for n, t in ipairs(self.TABS) do
				if mx >= t.x and mx <= t.x + t.w and my >= self:getTabsY() and my <= self:getTabsBottom() then
					self.HIGHLIGHTED_INDEX = n
				end
			end
		end

		self.TABS.y:update(dt)

		self:updateCurrentTab(dt)
	end,

	updateCurrentTab = function(self, dt)
		local currentTab = self.TABS[self.TAB_INDEX]
		if currentTab.panel then
			local mx, my = love.mouse.getPosition()
			currentTab.panel:update(dt, mx, my - self:getTabsBottom())
		end
	end,

	handleMousepressed = function(self, mx, my, params)
		if params.doubleClicked then
			if self.TABS.opened then self.TABS.y:setDestination(self.HEIGHT - 40)
			else                     self.TABS.y:setDestination(self.HEIGHT - 35 - self.PANE_HEIGHT) end
			self.TABS.opened = not self.TABS.opened
		elseif self.TABS.opened then
			for n, t in ipairs(self.TABS) do
				if mx >= t.x and mx <= t.x + t.w and my >= self:getTabsY() and my <= self:getTabsBottom() then
					self.TAB_INDEX = n
					return
				end
			end

			self:handleMousepressedCurrentTab(mx, my - self:getTabsBottom()) 
		end
	end,

	handleMousepressedCurrentTab = function(self, mx, my)
		local currentTab = self.TABS[self.TAB_INDEX]
		if currentTab.panel then
			currentTab.panel:handleMousepressed(mx, my)
		end
	end,

	getBGColor = function(self, params)
		if not self.TABS.opened     then return COLOR.JET_BLACK
		elseif params.isSelected    then return COLOR.DARK_GREY
		elseif params.isHighlighted then return COLOR.DARK_YELLOW
		else                             return COLOR.VERY_DARK_GREY  end
	end,

	getLabelColor = function(self, params)
		if not self.TABS.opened     then return COLOR.MEDIUM_GREY
		elseif params.isSelected    then return COLOR.PURE_WHITE
		elseif params.isHighlighted then return COLOR.LIGHT_YELLOW
		else                             return COLOR.LIGHT_GREY      end
	end,
}
