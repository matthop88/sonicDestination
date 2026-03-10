return {
	create = function(self, params)
		local COLORS = require("tools/lib/colors")
		
		return {
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 200,
			itemHeight = params.itemHeight or 25,
			items = params.items or {},
			selectedIndex = nil,

			draw = function(self)
				self:drawBackground()
				self:drawItems()
			end,

			drawBackground = function(self)
				local totalHeight = #self.items * self.itemHeight
				
				love.graphics.setColor(COLORS.JET_BLACK)
				love.graphics.rectangle("fill", self.x, self.y, self.width, totalHeight)
				love.graphics.setColor(COLORS.PURE_WHITE)
				love.graphics.rectangle("line", self.x, self.y, self.width, totalHeight)
			end,

			drawItems = function(self)
				local mx, my = love.mouse.getPosition()

				for i, item in ipairs(self.items) do
					local itemY = self.y + (i - 1) * self.itemHeight
					local isHovered = self:itemContainsPt(i, mx, my)

					if isHovered then
						self:drawReversedText(item, itemY)
					else
						self:drawWhiteText(item, itemY)
					end
				end
			end,

			itemContainsPt = function(self, i, px, py)
				local itemY = self.y + (i - 1) * self.itemHeight
				return px >= self.x and px <= self.x + self.width and
				       py >= itemY and py <= itemY + self.itemHeight
			end,

			drawReversedText = function(self, item, itemY)
				love.graphics.setColor(COLORS.PURE_WHITE)
				love.graphics.rectangle("fill", self.x, itemY, self.width, self.itemHeight)
				
				love.graphics.setColor(COLORS.JET_BLACK)
				self:drawText(item, itemY)
			end,

			drawWhiteText = function(self, item, itemY)
				love.graphics.setColor(COLORS.PURE_WHITE)
				self:drawText(item, itemY)
			end,

			drawText = function(self, item, itemY)
				local font = love.graphics.getFont()
				local textY = itemY + (self.itemHeight - font:getHeight()) / 2
				love.graphics.print(item, self.x + 5, textY)
			end,

			handleClick = function(self, mx, my)
				if self:listBoxContainsPt(mx, my) then
					local clickedIndex = self:getClickedItemIndex(mx, my)
					if clickedIndex then
						self.selectedIndex = clickedIndex
						return self:getSelectedItem()
					end
				end
				return nil, nil
			end,

			getClickedItemIndex = function(self, mx, my)
				local relativeY = my - self.y
				local clickedIndex = math.floor(relativeY / self.itemHeight) + 1
				if clickedIndex >= 1 and clickedIndex <= #self.items then
					return clickedIndex
				end
				return nil
			end,

			listBoxContainsPt = function(self, px, py)
				local totalHeight = #self.items * self.itemHeight
				return px >= self.x and px <= self.x + self.width and
				       py >= self.y and py <= self.y + totalHeight
			end,

			getSelectedItem = function(self)
				if self.selectedIndex then
					return self.items[self.selectedIndex], self.selectedIndex
				end
				return nil, nil
			end,
		}
	end,
}
