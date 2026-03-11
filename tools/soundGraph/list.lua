return {
	create = function(self, params)
		local COLORS = require("tools/lib/colors")
		local TEXT_ITEM = require("tools/soundGraph/textItem")
		
		local fontSize = params.fontSize or 12
		local font = love.graphics.newFont(fontSize)
		local itemHeight = params.itemHeight or (font:getHeight() + 10)
		
		-- Convert string items to TextItem objects
		local items = {}
		for _, item in ipairs(params.items or {}) do
			if type(item) == "string" then
				table.insert(items, TEXT_ITEM:create { text = item, font = font })
			else
				table.insert(items, item)
			end
		end
		
		return ({
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 200,
			itemHeight = itemHeight,
			items = items,
			selectedIndex = nil,
			
			flashIndex = nil,
			flashing = require("tools/soundGraph/flashing"):create {
				flashCount = 2,
				flashDuration = 0.08,
			},

			init = function(self)
				self:layoutItems()
				return self
			end,

			layoutItems = function(self)
				for i, item in ipairs(self.items) do
					item.x = self.x
					item.y = self.y + (i - 1) * self.itemHeight
					item.width = self.width
					item.height = self.itemHeight
				end
			end,

			draw = function(self)
				self:drawBackground()
				self:drawItems()
			end,

			update = function(self, dt)
				self.flashing:update(dt)
				if not self.flashing:isActive() then
					self.flashIndex = nil
				end
				
				for _, item in ipairs(self.items) do
					item:update(dt)
				end
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
					local isHovered = item:containsPt(mx, my)
					local isFlashing = (self.flashIndex == i and self.flashing:isFlashing())

					item:setPressed(isFlashing or (isHovered and self.flashIndex ~= i))
					item:draw()
				end
			end,

			handleClick = function(self, mx, my)
				if self:listBoxContainsPt(mx, my) then
					for i, item in ipairs(self.items) do
						if item:containsPt(mx, my) then
							self.selectedIndex = i
							self.flashIndex = i
							self.flashing:start()
							return self:getSelectedItem()
						end
					end
				end
				return nil, nil
			end,

			listBoxContainsPt = function(self, px, py)
				local totalHeight = #self.items * self.itemHeight
				return px >= self.x and px <= self.x + self.width and
				       py >= self.y and py <= self.y + totalHeight
			end,

			getSelectedItem = function(self)
				if self.selectedIndex then
					return self.items[self.selectedIndex]:getValue(), self.selectedIndex
				end
				return nil, nil
			end,
		}):init()
	end,
}
