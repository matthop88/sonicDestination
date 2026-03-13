local function isSelectable(item)
	return not item.notSelectable
end

local SIMPLE_GRAPHICS = require("tools/lib/simpleGraphics"):create()

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
	
	local list = ({
		x = params.x or 0,
		y = params.y or 0,
		width = params.width or 200,
		itemHeight = itemHeight,
		items = items,
		selectedIndex = nil,
		totalHeight = 0,
		needsBorder = true,
		
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
			local currentY = self.y
			for i, item in ipairs(self.items) do
				item.x = self.x
				item.y = currentY
				item.width = self.width
				if not item.height or item.height == 25 then
					item.height = self.itemHeight
				end
				currentY = currentY + item.height
			end
			self.totalHeight = currentY - self.y
		end,

		draw = function(self, graphics, mx, my)
			graphics = graphics or SIMPLE_GRAPHICS
			if not mx or not my then
				mx, my = love.mouse.getPosition()
			end
			self:drawBackground(graphics)
			self:drawItems(graphics, mx, my)
			if self.needsBorder then
				self:drawBorder(graphics)
			end
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

		drawBackground = function(self, graphics)
			graphics:setColor(COLORS.DARK_GREY)
			graphics:rectangle("fill", self.x, self.y, self.width, self.totalHeight)
		end,

		drawBorder = function(self, graphics)
			graphics:setColor(COLORS.PURE_WHITE)
			graphics:rectangle("line", self.x, self.y, self.width, self.totalHeight)
		end,

		drawItems = function(self, graphics, mx, my)
			for i, item in ipairs(self.items) do
				local isHovered = isSelectable(item) and item:containsPt(mx, my)
				local isFlashing = (self.flashIndex == i and self.flashing:isFlashing())

				item:setPressed(isFlashing or (isHovered and self.flashIndex ~= i))
				item:draw(graphics)
			end
		end,

		handleClick = function(self, mx, my)
			if self:listBoxContainsPt(mx, my) then
				for i, item in ipairs(self.items) do
					if isSelectable(item) and item:containsPt(mx, my) then
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
			return px >= self.x and px <= self.x + self.width and
			       py >= self.y and py <= self.y + self.totalHeight
		end,

		getSelectedItem = function(self)
			if self.selectedIndex then
				return self.items[self.selectedIndex]:getValue(), self.selectedIndex
			end
			return nil, nil
		end,
	}):init()
		
	-- Check if we need a scrollPane
	local maxHeight = params.height
	if maxHeight and list.totalHeight > maxHeight then
		list.needsBorder = false
		local SCROLL_PANE = require("tools/soundGraph/scrollPane")
		return SCROLL_PANE:create {
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 200,
			height = maxHeight,
			scrollSpeed = params.scrollSpeed,
			list = list
		}
	end
	
	return list
	end,
}
