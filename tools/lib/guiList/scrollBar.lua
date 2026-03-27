local COLORS = require("tools/lib/colors")

return {
	create = function(self, params)
		return {
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 30,
			height = params.height or 400,
			buttonHeight = params.buttonHeight or 20,
			scrollSpeed = params.scrollSpeed or 300,
			scrollY = 0,
			listTotalHeight = params.listTotalHeight or 0,
			paneHeight = params.paneHeight or 400,
			mouseOverUpButton = false,
			mouseOverDownButton = false,
			mousePressed = false,
	
			draw = function(self, mx, my)
				self:drawScrollBarBackground()
				self:drawThumb()
				self:drawButtons(mx, my)
			end,
	
			drawScrollBarBackground = function(self)
				love.graphics.setColor(COLORS.MEDIUM_GREY)
				love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
				love.graphics.setColor(COLORS.DARK_GREY)
				love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
			end,
			
			drawThumb = function(self)
				if self.listTotalHeight <= self.paneHeight then return end
				
				-- Calculate thumb area (between buttons)
				local thumbAreaY = self.y + self.buttonHeight + 10
				local thumbAreaHeight = self.height - (2 * self.buttonHeight) - 20
				
				-- Calculate thumb size based on visible ratio
				local visibleRatio = self.paneHeight / self.listTotalHeight
				local thumbHeight = math.max(20, thumbAreaHeight * visibleRatio)
				
				-- Calculate thumb position based on scroll position
				local maxScroll, minScroll = self:calculateScrollConstraints()
				local scrollRange = maxScroll - minScroll
				local scrollProgress = scrollRange > 0 and ((self.scrollY - minScroll) / scrollRange) or 0
				
				-- Invert progress since scrollY is negative when scrolling down
				scrollProgress = 1 - scrollProgress
				
				local thumbY = thumbAreaY + (scrollProgress * (thumbAreaHeight - thumbHeight))
				
				love.graphics.setColor(1, 1, 1)
				love.graphics.rectangle("fill", self.x + 4, thumbY, self.width - 8, thumbHeight)
				love.graphics.setColor(0, 0, 0)
				love.graphics.rectangle("line", self.x + 4, thumbY, self.width - 8, thumbHeight)
			end,
	
			drawButtons = function(self, mx, my)
				local maxScroll, minScroll = self:calculateScrollConstraints()
				local upEnabled = self.scrollY < maxScroll
				local downEnabled = self.scrollY > minScroll
				
				-- Update hover states
				self.mouseOverUpButton = self:isOverUpButton(mx, my) and upEnabled
				self.mouseOverDownButton = self:isOverDownButton(mx, my) and downEnabled
				
				-- Draw buttons
				local upButtonY = self.y + 5
				local downButtonY = self.y + self.height - self.buttonHeight - 5
				self:drawUpButton(self.x, self.width, upButtonY, upEnabled)
				self:drawDownButton(self.x, self.width, downButtonY, downEnabled)
			end,
	
			drawUpButton = function(self, buttonX, buttonWidth, buttonY, enabled)
				if not enabled then
					self:drawUpIcon(buttonX, buttonWidth, buttonY, COLORS.VERY_DARK_GREY, "line")
				elseif self.mousePressed and self.mouseOverUpButton then
					self:drawUpIcon(buttonX, buttonWidth, buttonY, COLORS.PURE_WHITE, "fill")
				elseif self.mouseOverUpButton then
					self:drawUpIcon(buttonX, buttonWidth, buttonY, COLORS.DARK_GREY, "fill")
					love.graphics.setLineWidth(2)
					self:drawUpIcon(buttonX, buttonWidth, buttonY, COLORS.PURE_WHITE, "line")
				else
					self:drawUpIcon(buttonX, buttonWidth, buttonY, COLORS.DARK_GREY, "fill")
				end
			end,
	
			drawDownButton = function(self, buttonX, buttonWidth, buttonY, enabled)
				if not enabled then
					self:drawDownIcon(buttonX, buttonWidth, buttonY, COLORS.VERY_DARK_GREY, "line")
				elseif self.mousePressed and self.mouseOverDownButton then
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
	
			calculateScrollConstraints = function(self)
				local maxScroll = 0
				local minScroll = -(math.max(0, self.listTotalHeight - self.paneHeight))
				return maxScroll, minScroll
			end,
	
			scrollBy = function(self, deltaY)
				self.scrollY = self.scrollY + deltaY
				
				-- Constrain scrolling: don't scroll past the top or bottom
				local maxScroll, minScroll = self:calculateScrollConstraints()
				self.scrollY = math.max(minScroll, math.min(maxScroll, self.scrollY))
			end,
	
			scrollTo = function(self, y)
				self.scrollY = y
			end,
		
			getScrollY = function(self)
				return self.scrollY
			end,
		
			update = function(self, dt)
				if self.mousePressed then
					local mx, my = love.mouse.getPosition()
					if self:isOverUpButton(mx, my) then
						self:scrollBy(self.scrollSpeed * dt)
					elseif self:isOverDownButton(mx, my) then
						self:scrollBy(-self.scrollSpeed * dt)
					end
				end
			end,
		
			isOverUpButton = function(self, mx, my)
				local upButtonY = self.y + 5
				return mx >= self.x and mx <= self.x + self.width and
					   my >= upButtonY and my <= upButtonY + self.buttonHeight
			end,
		
			isOverDownButton = function(self, mx, my)
				local downButtonY = self.y + self.height - self.buttonHeight - 5
				return mx >= self.x and mx <= self.x + self.width and
					   my >= downButtonY and my <= downButtonY + self.buttonHeight
			end,
		
			handleMousePressed = function(self, mx, my)
				self.mousePressed = true
				if self:isOverUpButton(mx, my) or self:isOverDownButton(mx, my) then
					return true
				end
				return false
			end,
		
			handleMouseReleased = function(self)
				self.mousePressed = false
			end,
		}
	end,
}
