return {
	create = function(self, params)
		local graphics = require("tools/lib/bufferedGraphics"):create(
			nil,
			params.width or 200, 
			params.height or 400
		)
		
		return ({
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 200,
			height = params.height or 400,
			scrollSpeed = params.scrollSpeed or 300,
			scrollBarWidth = 30,
			graphics = graphics,
			list = params.list,
			scrollY = 0,
			buttonHeight = 20,
			mouseOverUpButton = false,
			mouseOverDownButton = false,
			mousePressed = false,

			init = function(self)
				self.list.x = 0
				self.list.y = 0
				self.list.width = self.width - self.scrollBarWidth
				self.list:layoutItems()
				self.graphics:setY(0)
				return self
			end,

			draw = function(self)
				self.graphics:clear(0, 0, 0, 0)
				local mx, my = love.mouse.getPosition()
				local bufferMx, bufferMy = self:translateMouseCoordinates(mx, my)
				self.list:draw(self.graphics, bufferMx, bufferMy)
				self.graphics:blitToScreen(self.x, self.y)
				self:drawBorder()
				self:drawButtons(mx, my)
			end,
	
			drawBorder = function(self)
				local COLORS = require("tools/lib/colors")
				love.graphics.setColor(COLORS.PURE_WHITE)
				love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
			end,
	
			drawButtons = function(self, mx, my)
				local COLORS = require("tools/lib/colors")
				local scrollBarX = self.x + self.list.width
				local scrollBarY = self.y
				local scrollBarHeight = self.height
				
				-- Draw scroll bar background
				love.graphics.setColor(COLORS.MEDIUM_GREY)
				love.graphics.rectangle("fill", scrollBarX, scrollBarY, self.scrollBarWidth, scrollBarHeight)
				love.graphics.setColor(COLORS.DARK_GREY)
				love.graphics.rectangle("line", scrollBarX, scrollBarY, self.scrollBarWidth, scrollBarHeight)
				
				-- Button positioning
				local buttonWidth = self.scrollBarWidth
				local buttonX = scrollBarX
				local upButtonY = scrollBarY + 5
				local downButtonY = scrollBarY + scrollBarHeight - self.buttonHeight - 5
				
				-- Update hover states
				self.mouseOverUpButton = self:isOverUpButton(mx, my)
				self.mouseOverDownButton = self:isOverDownButton(mx, my)
				
				-- Draw buttons
				self:drawUpButton(buttonX, buttonWidth, upButtonY, COLORS)
				self:drawDownButton(buttonX, buttonWidth, downButtonY, COLORS)
			end,
	
			drawUpButton = function(self, buttonX, buttonWidth, buttonY, COLORS)
				if self.mousePressed and self.mouseOverUpButton then
					self:drawUpIcon(buttonX, buttonWidth, buttonY, COLORS.PURE_WHITE, "fill")
				elseif self.mouseOverUpButton then
					self:drawUpIcon(buttonX, buttonWidth, buttonY, COLORS.DARK_GREY, "fill")
					love.graphics.setLineWidth(2)
					self:drawUpIcon(buttonX, buttonWidth, buttonY, COLORS.PURE_WHITE, "line")
				else
					self:drawUpIcon(buttonX, buttonWidth, buttonY, COLORS.DARK_GREY, "fill")
				end
			end,
	
			drawDownButton = function(self, buttonX, buttonWidth, buttonY, COLORS)
				if self.mousePressed and self.mouseOverDownButton then
					self:drawDownIcon(buttonX, buttonWidth, buttonY, COLORS.PURE_WHITE, "fill")
				elseif self.mouseOverDownButton then
					self:drawDownIcon(buttonX, buttonWidth, buttonY, COLORS.DARK_GREY, "fill")
					love.graphics.setLineWidth(2)
					self:drawDownIcon(buttonX, buttonWidth, buttonY, COLORS.PURE_WHITE, "line")
				else
					self:drawDownIcon(buttonX, buttonWidth, buttonY, COLORS.DARK_GREY, "fill")
				end
			end,
		
			drawUpIcon = function(self, buttonX, buttonWidth, buttonY, color, drawMode)
				love.graphics.setColor(color)
				local centerX = buttonX + buttonWidth / 2
				local topY = buttonY + 3
				local bottomY = buttonY + self.buttonHeight - 3
				love.graphics.polygon(drawMode,
					centerX, topY,
					centerX - 8, bottomY,
					centerX + 8, bottomY
				)
			end,
		
			drawDownIcon = function(self, buttonX, buttonWidth, buttonY, color, drawMode)
				love.graphics.setColor(color)
				local centerX = buttonX + buttonWidth / 2
				local topY = buttonY + 3
				local bottomY = buttonY + self.buttonHeight - 3
				love.graphics.polygon(drawMode,
					centerX, bottomY,
					centerX - 8, topY,
					centerX + 8, topY
				)
			end,

			isOverUpButton = function(self, mx, my)
				local buttonWidth = self.scrollBarWidth
				local buttonX = self.x + self.list.width
				local upButtonY = self.y + 5
				return mx >= buttonX and mx <= buttonX + buttonWidth and
				       my >= upButtonY and my <= upButtonY + self.buttonHeight
			end,

			isOverDownButton = function(self, mx, my)
				local buttonWidth = self.scrollBarWidth
				local buttonX = self.x + self.list.width
				local downButtonY = self.y + self.height - self.buttonHeight - 5
				return mx >= buttonX and mx <= buttonX + buttonWidth and
				       my >= downButtonY and my <= downButtonY + self.buttonHeight
			end,

			update = function(self, dt)
				if love.keyboard.isDown("w") then
					self:scrollBy(self.scrollSpeed * dt)
				elseif love.keyboard.isDown("s") then
					self:scrollBy(-self.scrollSpeed * dt)
				end
				
				-- Handle button scrolling
				if self.mousePressed then
					local mx, my = love.mouse.getPosition()
					if self:isOverUpButton(mx, my) then
						self:scrollBy(self.scrollSpeed * dt)
					elseif self:isOverDownButton(mx, my) then
						self:scrollBy(-self.scrollSpeed * dt)
					end
				end
				
				self.list:update(dt)
			end,

			translateMouseCoordinates = function(self, mx, my)
				local offsetX = mx - self.x - self.graphics:getX()
				local offsetY = my - self.y - self.graphics:getY()
				return offsetX, offsetY
			end,

			scrollBy = function(self, deltaY)
				self.scrollY = self.scrollY + deltaY
				
				-- Constrain scrolling: don't scroll past the top or bottom
				local maxScroll = 0
				local minScroll = -(math.max(0, self.list.totalHeight - self.height))
				self.scrollY = math.max(minScroll, math.min(maxScroll, self.scrollY))
				
				self.graphics:setY(self.scrollY)
			end,

			scrollTo = function(self, y)
				self.scrollY = y
				self.graphics:setY(self.scrollY)
			end,

			getScrollY = function(self)
				return self.scrollY
			end,

			handleClick = function(self, mx, my)
				local bufferMx, bufferMy = self:translateMouseCoordinates(mx, my)
				return self.list:handleClick(bufferMx, bufferMy)
			end,

			handleMousePressed = function(self, mx, my)
				self.mousePressed = true
				-- Check if clicking on a button; if not, pass to list
				if not self:isOverUpButton(mx, my) and not self:isOverDownButton(mx, my) then
					return self:handleClick(mx, my)
				end
				return nil, nil
			end,

			handleMouseReleased = function(self)
				self.mousePressed = false
			end,
		}):init()
	end,
}
