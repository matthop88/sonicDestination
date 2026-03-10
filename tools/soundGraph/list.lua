return {
	create = function(self, params)
		return {
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 200,
			itemHeight = params.itemHeight or 25,
			items = params.items or {},
			selectedIndex = nil,

			draw = function(self)
				-- Calculate total height
				local totalHeight = #self.items * self.itemHeight

				-- Draw background rectangle (black with white outline)
				love.graphics.setColor(0, 0, 0)
				love.graphics.rectangle("fill", self.x, self.y, self.width, totalHeight)
				love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("line", self.x, self.y, self.width, totalHeight)

				-- Get mouse position
				local mx, my = love.mouse.getPosition()

				-- Draw each item
				for i, item in ipairs(self.items) do
					local itemY = self.y + (i - 1) * self.itemHeight
					local isHovered = mx >= self.x and mx <= self.x + self.width and
					                  my >= itemY and my <= itemY + self.itemHeight

					if isHovered then
						-- Draw white background for hovered item
						love.graphics.setColor(1, 1, 1)
						love.graphics.rectangle("fill", self.x, itemY, self.width, self.itemHeight)
						-- Draw black text
						love.graphics.setColor(0, 0, 0)
					else
						-- Draw white text
						love.graphics.setColor(1, 1, 1)
					end

					-- Draw item text
					local font = love.graphics.getFont()
					local textY = itemY + (self.itemHeight - font:getHeight()) / 2
					love.graphics.print(item, self.x + 5, textY)
				end
			end,

			handleClick = function(self, mx, my)
				local totalHeight = #self.items * self.itemHeight

				-- Check if click is within list bounds
				if mx >= self.x and mx <= self.x + self.width and
				   my >= self.y and my <= self.y + totalHeight then
					-- Determine which item was clicked
					local relativeY = my - self.y
					local clickedIndex = math.floor(relativeY / self.itemHeight) + 1
					if clickedIndex >= 1 and clickedIndex <= #self.items then
						self.selectedIndex = clickedIndex
						return self.items[clickedIndex], clickedIndex
					end
				end
				return nil, nil
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
