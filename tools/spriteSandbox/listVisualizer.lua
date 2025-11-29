return {
	create = function(self, list)

		return {
			list     = list,
			graphics = require("tools/lib/graphics"):create(), 
    
			draw = function(self)
				if self.list:size() > 0 then
					self.graphics:setColor(0.5, 0.5, 0.5, 0.8)
					self.graphics:rectangle("fill", 0, 700, 1200, 100)

					self:drawList()
				end
			end,

			drawList = function(self)
				self.list:head()

				local n, x = 1, 50
				while not self.list:isEnd() do
					self:drawListElement(n, x)
					n, x = n + 1, x + 100
					self.list:next()
				end
			end,

			drawListElement = function(self, n, x)
				local sprite = self.list:get()
				self:checkMousedOver(sprite, x)
					
				self:drawCellID(x)
				self:drawCell(sprite, x)

				if n < self.list:size() then self:drawArrows(x) end
			end,

			checkMousedOver = function(self, sprite, x)
				local mx, my = love.mouse.getPosition()
				sprite.mousedOverInVisualizer = (mx >= x and mx < x + 50 and my >= 725 and my < 775)
			end,
				
			drawCellID = function(self, x)
				local cellID = self.list:getCellID()
				self.graphics:setColor(0.5, 0.5, 0.5)
				self.graphics:rectangle("fill", x + 5, 775, 40, 18)
				self.graphics:setColor(1, 1, 1)
				self.graphics:setLineWidth(2)
				self.graphics:rectangle("line", x + 5, 775, 40, 18)
				self.graphics:setFontSize(12)
				self.graphics:printf("" .. cellID, x + 5, 777, 40, "center")
			end,

			drawCell = function(self, sprite, x)
				if sprite.selected then 
					self.graphics:setColor(1, 1, 0.3, 0.9)
				else                    
					if sprite.mousedOver then self.graphics:setColor(0, 1, 1, 0.7)
					else                      self.graphics:setColor(1, 1, 1, 0.9) end
				end
				
				self.graphics:setLineWidth(3)
				self.graphics:rectangle("line", x, 725, 50, 50)
				
				if sprite.selected then
					self.graphics:setColor(1, 1, 1, 0.4)
					self:drawThumbnail(sprite, x)
					self.graphics:setColor(1, 1, 1)
					self:drawSpriteID(sprite, x)
				else
					self.graphics:setColor(1, 1, 1)
					self:drawThumbnail(sprite, x)
				end
			end,

			drawThumbnail = function(self, sprite, x)
				local sX = math.min(1.5, 48 / sprite:getW())
				local sY = math.min(1.5, 48 / sprite:getH())
				sprite:drawThumbnail(self.graphics, x + 25, 750, math.min(sX, sY), math.min(sX, sY))
			end,

			drawSpriteID = function(self, sprite, x)
				self.graphics:setFontSize(24)
				self.graphics:printf("" .. sprite:getID(), x, 735, 50, "center")
			end,

			drawArrows = function(self, x)
				self.graphics:setColor(1, 1, 1, 0.9)
				self.graphics:setLineWidth(1)
				self.graphics:line(x + 50, 744, x + 100, 744)
				self.graphics:line(x + 50, 756, x + 100, 756)
				self:drawArrowHeads(x)
			end,

			drawArrowHeads = function(self, x)
				self.graphics:setLineWidth(2)
				self.graphics:line(x + 90, 739, x + 100, 744)
				self.graphics:line(x + 90, 749, x + 100, 744)
				self.graphics:line(x + 60, 751, x +  50, 756)
				self.graphics:line(x + 60, 761, x +  50, 756)
			end,

		}
	end,
}
