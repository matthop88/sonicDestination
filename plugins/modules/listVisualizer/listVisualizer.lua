return {
	init = function(self, params)
		self.list = params.list
		self.graphics = require("tools/lib/graphics"):create()
	end,

	draw = function(self)
		if self.list:size() > 0 then
			self:drawBackground()
			self:drawList()
		end
	end,

	drawBackground = function(self)
		self.graphics:setColor(0.5, 0.5, 0.5, 0.8)
		self.graphics:rectangle("fill", 0, 700, 1200, 100)
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
		local element = self.list:get()
		self:checkMousedOver(element, x)

		self:drawCellID(x)
		self:drawCell(element, x)

		if n < self.list:size() then self:drawArrows(x) end
	end,

	checkMousedOver = function(self, element, x)
		local mx, my = love.mouse.getPosition()
		element.mousedOverInVisualizer = (mx >= x and mx < x + 50 and my >= 725 and my < 775)
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

	drawCell = function(self, element, x)
		if element.selected then 
			self.graphics:setColor(1, 1, 0.3, 0.9)
		else                    
			if element.mousedOver then self.graphics:setColor(0, 1, 1, 0.7)
			else                       self.graphics:setColor(1, 1, 1, 0.9) end
		end
		
		self.graphics:setLineWidth(3)
		self.graphics:rectangle("line", x, 725, 50, 50)
		
		if element.selected then
			self.graphics:setColor(1, 1, 1, 0.4)
			self:drawThumbnail(element, x)
			self.graphics:setColor(1, 1, 1)
			self:drawElementID(element, x)
		else
			self.graphics:setColor(1, 1, 1)
			self:drawThumbnail(element, x)
		end
	end,

	drawThumbnail = function(self, element, x)
		local sX = math.min(1.5, 48 / element:getW())
		local sY = math.min(1.5, 48 / element:getH())
		element:drawThumbnail(self.graphics, x + 25, 750, math.min(sX, sY), math.min(sX, sY))
	end,

	drawElementID = function(self, element, x)
		self.graphics:setFontSize(24)
		self.graphics:printf("" .. element:getID(), x, 735, 50, "center")
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
