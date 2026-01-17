return {
	topY                = 700,
	xSpeed              = 0,
	xOffset             = 0,
	active              = true,
	propertyBox         = false,
	
	init = function(self, params)
		self.listFn   = params.listFn
		self.list     = self.listFn()
		self.graphics = require("tools/lib/graphics"):create()
		if params.active ~= nil then self.active = params.active end
	end,

	toggleActive = function(self)
		self.active = not self.active
	end,

	draw = function(self)
		if self.list:size() > 0 and self.active then
			self:drawBackground()
			self:drawList()
			self:drawPropertyBox()
		end
	end,

	update = function(self, dt)
		if self.active then
			self.list    = self.listFn()
			self.xOffset = self.xOffset + (self.xSpeed * dt)
			local coordinatesOfLast = ((self.list:size()) * 100) + 50
			local minXOffset = -coordinatesOfLast + self.graphics:getScreenWidth()
			self.xOffset = math.min(0, math.max(minXOffset, self.xOffset))
			self.selected   = self.list:getSelected()
			self.considered = self.list:getConsidered()

			local n, x = 1, 50 + self.xOffset
			self.list:forEach(function(elem)
				if self:checkMousedOver(elem, x) then
					return true
				end
				n, x = n + 1, x + 100
			end)
			self.list:setConsidered(self.considered)

		end
	end,

	handleKeypressed = function(self, key)
		if self.active then
			if     key == "escape"      then self.selected = nil
			elseif key == "backspace"   then self:deleteSelected()
			elseif key == "optionright" then self.xSpeed = -2000
			elseif key == "optionleft"  then self.xSpeed =  2000 end
		end
	end,

	handleKeyreleased = function(self, key)
		if     key == "optionright" and self.xSpeed < 0 then self.xSpeed = 0
		elseif key == "optionleft"  and self.xSpeed > 0 then self.xSpeed = 0 end
	end,

	handleMousepressed = function(self, mx, my, params)
		if self.active then
			self.selected = nil
			local n, x = 1, 50 + self.xOffset
			self.list:forEach(function(elem)
				if self:isInside(mx, my, x) then
					if self.list.setSelected then self.list:setSelected(elem) end
					self.selected = elem
					if elem.locateVisually and (elem.isOnScreen == nil or not elem:isOnScreen()) then elem:locateVisually() end
					return true
				end
				n, x = n + 1, x + 100
			end)

			if params and params.doubleClicked then self:handleDoubleClicked() end

			if self.selected then return true end
		end
	end,

	handleDoubleClicked = function(self)
		if self.selected and self.selected.getPublicAttributes then
			self.propertyBox = true
		end
	end,

	deleteSelected = function(self)
		self.list:forEach(function(elem)
			if self.selected == elem then 
				self.list:remove()
				return true
			end
		end)
	end,

	drawBackground = function(self)
		self.topY = self.graphics:getScreenHeight() - 100
		self.graphics:setColor(0.5, 0.5, 0.5, 0.8)
		self.graphics:rectangle("fill", 0, self.topY, 1200, 100)
	end,

	drawList = function(self)
		local n, x = 1, 50 + self.xOffset
		self.list:forEach(function(elem, cellID)
			if x > -100 and x < self.graphics:getScreenWidth() then
				self:drawListElement(elem, cellID, n, x)
			end
			n, x = n + 1, x + 100
		end)
	end,

	drawListElement = function(self, element, cellID, n, x)
		self:drawCellID(cellID, x)
		self:drawCell(element, x)

		if n < self.list:size() then self:drawArrows(x) end
	end,

	drawPropertyBox = function(self)
		if self.propertyBox and self.selected then
			self.graphics:setColor(0, 0, 0, 0.7)
			self.graphics:rectangle("fill", (self.graphics:getScreenWidth() - 500) / 2, self.topY - 250, 500, 200)
			self.graphics:setColor(1, 1, 1)
			self.graphics:rectangle("line", (self.graphics:getScreenWidth() - 500) / 2, self.topY - 250, 500, 200)
		end
	end,

	isInside = function(self, mx, my, x)
		return (mx >= x and mx < x + 50 and my >= self.topY + 25 and my < self.topY + 75)
	end,

	checkMousedOver = function(self, element, x)
		local mx, my = love.mouse.getPosition()
		if self:isInside(mx, my, x) then
			self.considered = element
			return true
		end
	end,

	drawCellID = function(self, cellID, x)
		if cellID then
			self.graphics:setColor(0.5, 0.5, 0.5)
			self.graphics:rectangle("fill", x + 5, self.topY + 75, 40, 18)
			self.graphics:setColor(1, 1, 1)
			self.graphics:setLineWidth(2)
			self.graphics:rectangle("line", x + 5, self.topY + 75, 40, 18)
			self.graphics:setFontSize(12)
			self.graphics:printf("" .. cellID, x + 5, self.topY + 77, 40, "center")
		end
	end,

	drawCell = function(self, element, x)
		if     element == self.selected   then self.graphics:setColor(1, 1, 0.3, 0.9)
		elseif element == self.considered then self.graphics:setColor(0, 1, 1,   0.7)
		else                                   self.graphics:setColor(1, 1, 1, 0.9)   end
		
		self.graphics:setLineWidth(3)
		self.graphics:rectangle("line", x, self.topY + 25, 50, 50)
		
		if element == self.selected then
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
		element:drawThumbnail(self.graphics, x + 25, self.topY + 50, math.min(sX, sY), math.min(sX, sY))
	end,

	drawElementID = function(self, element, x)
		self.graphics:setFontSize(24)
		self.graphics:printf("" .. element:getID(), x, self.topY + 35, 50, "center")
	end,

	drawArrows = function(self, x)
		self.graphics:setColor(1, 1, 1, 0.9)
		self.graphics:setLineWidth(1)
		self.graphics:line(x + 50, self.topY + 44, x + 100, self.topY + 44)
		self.graphics:line(x + 50, self.topY + 56, x + 100, self.topY + 56)
		self:drawArrowHeads(x)
	end,

	drawArrowHeads = function(self, x)
		self.graphics:setLineWidth(2)
		self.graphics:line(x + 90, self.topY + 39, x + 100, self.topY + 44)
		self.graphics:line(x + 90, self.topY + 49, x + 100, self.topY + 44)
		self.graphics:line(x + 60, self.topY + 51, x +  50, self.topY + 56)
		self.graphics:line(x + 60, self.topY + 61, x +  50, self.topY + 56)
	end,

}
