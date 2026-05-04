local COLORS = require("tools/lib/colors")

return {
	create = function(self, params)
		local graphics = require("tools/lib/bufferedGraphics"):create(
			nil,
			params.width or 200, 
			params.height or 400
		)
		
		local scrollBarWidth = 30
		local scrollBar = require("tools/lib/guiList/scrollBar"):create {
			x = (params.x or 0) + (params.width or 200) - scrollBarWidth,
			y = params.y or 0,
			width = scrollBarWidth,
			height = params.height or 400,
			buttonHeight = 20,
			scrollSpeed = params.scrollSpeed or 300,
		}
		
		return ({
			x = params.x or 0,
			y = params.y or 0,
			width = params.width or 200,
			height = params.height or 400,
			scrollSpeed = params.scrollSpeed or 300,
			scrollBarWidth = scrollBarWidth,
			scrollBar = scrollBar,
			graphics = graphics,
			list = params.list,
			visible = true,
			onItemSelected = params.onItemSelected,
	
			init = function(self)
				self.list.x = 0
				self.list.y = 0
				self.list.width = self.width - self.scrollBarWidth
				self.list:layoutItems()
				self.graphics:setY(0)
					
				-- Wrap the list's callback to handle scrollPane visibility
				local originalCallback = self.list.onItemSelected
				self.list.onItemSelected = function(list, value, index)
					self.visible = false
					list.visible = false
					if originalCallback then
						originalCallback(self, value, index)
					end
				end
				
				return self
			end,

			draw = function(self)
				if not self.visible then return end
				
				self.graphics:clear(0, 0, 0, 0)
				local mx, my = love.mouse.getPosition()
				local bufferMx, bufferMy = self:translateMouseCoordinates(mx, my)
				self.list:draw(self.graphics, bufferMx, bufferMy)
				self.graphics:blitToScreen(self.x, self.y)
				self:drawBorder()
				self.scrollBar.listTotalHeight = self.list.totalHeight
				self.scrollBar.paneHeight = self.height
				self.scrollBar:draw(mx, my)
			end,
			
			drawBorder = function(self)
				love.graphics.setColor(COLORS.PURE_WHITE)
				love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
			end,
			
			update = function(self, dt)
				if not self.visible then return end
				
				-- Handle arrow key scrolling
				if love.keyboard.isDown("up") then
					self.scrollBar:scrollBy(self.scrollSpeed * dt)
					self:updateScrollPosition()
				elseif love.keyboard.isDown("down") then
					self.scrollBar:scrollBy(-self.scrollSpeed * dt)
					self:updateScrollPosition()
				end
				
				self.scrollBar:update(dt)
				self:updateScrollPosition()
				
				self.list:update(dt)
			end,
	
			translateMouseCoordinates = function(self, mx, my)
				local offsetX = mx - self.x - self.graphics:getX()
				local offsetY = my - self.y - self.graphics:getY()
				return offsetX, offsetY
			end,
	
			updateScrollPosition = function(self)
				self.graphics:setY(self.scrollBar:getScrollY())
			end,

			scrollTo = function(self, y)
				self.scrollBar:scrollTo(y)
				self:updateScrollPosition()
			end,
	
			getScrollY = function(self)
				return self.scrollBar:getScrollY()
			end,
	
			handleClick = function(self, mx, my)
				if not self.visible then return false end
				local bufferMx, bufferMy = self:translateMouseCoordinates(mx, my)
				return self.list:handleClick(bufferMx, bufferMy)
			end,
			
			setVisible = function(self, visible)
				self.visible = visible
				self.list.visible = visible
			end,

			getListHeight = function(self)
				return self.height
			end,
			
			setY = function(self, y)
				self.y = y
				self.scrollBar.y = y
			end,

			handleMousePressed = function(self, mx, my)
				if not self.visible then return false end
				local isOverButton = self.scrollBar:handleMousePressed(mx, my)
				-- If not clicking on a button, pass to list
				if not isOverButton then
					return self:handleClick(mx, my)
				end
				return true
			end,

			handleMouseReleased = function(self)
				if not self.visible then return end
				self.scrollBar:handleMouseReleased()
			end,

			handleKeyPressed = function(self, key)
				if not self.visible then return end
				if key == "escape" then
					self:setVisible(false)
					return true
				elseif key == "return" then
					return self:handleClick(love.mouse.getPosition())
				end
			end,
		}):init()
	end,
}
