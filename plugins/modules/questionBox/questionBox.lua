local QUESTION_FONT = love.graphics.newFont(32)

return {
	x = 1150,
	y = 10,
	w = 40,
	h = 40,

	opened = false,

	draw = function(self)
		if self:isInside(love.mouse.getPosition()) or self.opened then
			if love.mouse.isDown(1) then self:drawClicked()
			else                         self:drawHighlighted() end
		else
			self:drawUnhighlighted()
		end
	end,

	isInside = function(self, px, py)
		return px >= self.x and px < self.x + self.w and py >= self.y and py < self.y + self.h
	end,
					
	drawUnhighlighted = function(self)
		self:drawPanel        { 0.3, 0.3, 0.3, 0.1 }
    	self:drawBorder       { 0,   0,   0,   0.1 }
    	self:drawQuestionMark { 1,   1,   1,   0.1 }
	end,

	drawHighlighted = function(self)
		local alpha = 0.6
		self:drawPanel        { 0.3, 0.3, 0.3, alpha }
		self:drawBorder       { 1,   1,   0,   alpha }
		self:drawQuestionMark { 1,   1,   0,   alpha + 0.2 }
	end,

	drawClicked = function(self)
		if self.opened then self:drawPanel { 0.3, 0.3, 0.3, 0.1 }
		else                self:drawPanel { 1,   1,   1,   0.6 } end

		self:drawBorder       { 0,   0,   0,   0.6 }
    	self:drawQuestionMark { 0,   0,   0,   0.9 }
    end,
	
    drawPanel = function(self, color)
    	love.graphics.setColor(color)
    	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end,

    drawBorder = function(self, color)
    	love.graphics.setColor(color)
    	love.graphics.setLineWidth(3)
    	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    end,

    drawQuestionMark = function(self, color)
    	love.graphics.setColor(color)
    	love.graphics.setFont(QUESTION_FONT)
    	love.graphics.printf("?", self.x, self.y + 2, self.w, "center")
	end,

	handleMousepressed = function(self, mx, my, params)
		self.opened = not self.opened

		if self.opened then self:setOpened()
		else                self:setClosed() end
	end,

	setOpened = function(self) 
		self.x = 200
		self.w = 800
	end,

	setClosed = function(self) 
		self.x = 1150
		self.w = 40
	end,
}
