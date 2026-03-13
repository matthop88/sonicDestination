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
				local buttonWidth = 20
				local buttonX = self.x + self.width - buttonWidth - 5
				local upButtonY = self.y + 5
				local downButtonY = self.y + self.height - self.buttonHeight - 5
				
				-- Update hover states
				self.mouseOverUpButton = self:isOverUpButton(mx, my)
				self.mouseOverDownButton = self:isOverDownButton(mx, my)
				
				-- Draw up button (triangle pointing up)
				if self.mouseOverUpButton then
					love.graphics.setColor(COLORS.PURE_WHITE)
				else
					love.graphics.setColor(COLORS.MEDIUM_GREY)
				end
				local upCenterX = buttonX + buttonWidth / 2
				local upTopY = upButtonY + 3
				local upBottomY = upButtonY + self.buttonHeight - 3
				love.graphics.polygon("fill", 
					upCenterX, upTopY,
					upCenterX - 8, upBottomY,
					upCenterX + 8, upBottomY
				)
				
				-- Draw down button (triangle pointing down)
				if self.mouseOverDownButton then
					love.graphics.setColor(COLORS.PURE_WHITE)
				else
					love.graphics.setColor(COLORS.MEDIUM_GREY)
				end
				local downCenterX = buttonX + buttonWidth / 2
				local downTopY = downButtonY + 3
				local downBottomY = downButtonY + self.buttonHeight - 3
				love.graphics.polygon("fill",
					downCenterX, downBottomY,
					downCenterX - 8, downTopY,
					downCenterX + 8, downTopY
				)
			end,

			isOverUpButton = function(self, mx, my)
				local buttonWidth = 20
				local buttonX = self.x + self.width - buttonWidth - 5
				local upButtonY = self.y + 5
				return mx >= buttonX and mx <= buttonX + buttonWidth and
				       my >= upButtonY and my <= upButtonY + self.buttonHeight
			end,

			isOverDownButton = function(self, mx, my)
				local buttonWidth = 20
				local buttonX = self.x + self.width - buttonWidth - 5
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
