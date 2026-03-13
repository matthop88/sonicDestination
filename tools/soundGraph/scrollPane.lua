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
			graphics = graphics,
			list = params.list,
			scrollY = 0,

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
		end,

		drawBorder = function(self)
			local COLORS = require("tools/lib/colors")
			love.graphics.setColor(COLORS.PURE_WHITE)
			love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
		end,

			update = function(self, dt)
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

		handleKeypressed = function(self, key)
			if key == "w" then
				self:scrollBy(10)
			elseif key == "s" then
				self:scrollBy(-10)
			end
		end,
		}):init()
	end,
}
