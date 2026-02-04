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
	local xOffsetToCenter = attrs.WIDTH - (x / 2)
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
}
