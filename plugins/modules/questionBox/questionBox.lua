local QUESTION_FONT = love.graphics.newFont(32)

return {
	x = 1150,
	y = 10,
	w = 40,
	h = 40,

	draw = function(self)
		if self:isInside(love.mouse.getPosition()) then
			self:drawHighlighted()
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
}
