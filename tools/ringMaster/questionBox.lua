local QUESTION_FONT = love.graphics.newFont(64)

return {
	create = function(self, x, y)
		return {
			draw = function(self)
				local mx, my = love.mouse.getPosition()
				if mx >= x and mx < x + 80 and my >= y and my < y + 80 then
					self:drawHighlighted()
				else
					self:drawUnhighlighted()
				end
			end,

			drawHighlighted = function(self)
    			self:drawPanel        { 0.3, 0.3, 0.3, 0.6 }
    			self:drawBorder       { 1,   1,   0,   0.6 }
    			self:drawQuestionMark { 1,   1,   0,   0.9 }
    		end,

    		drawUnhighlighted = function(self)
    			self:drawPanel        { 0.3, 0.3, 0.3, 0.2 }
    			self:drawBorder       { 0,   0,   0,   0.1 }
    			self:drawQuestionMark { 1,   1,   1,   0.2 }
    		end,

    		drawPanel = function(self, color)
    			love.graphics.setColor(color)
    			love.graphics.rectangle("fill", x, y, 80, 80)
    		end,

    		drawBorder = function(self, color)
    			love.graphics.setColor(color)
    			love.graphics.setLineWidth(3)
    			love.graphics.rectangle("line", x, y, 80, 80)
    		end,

    		drawQuestionMark = function(self, color)
    			love.graphics.setColor(color)
    			love.graphics.setFont(QUESTION_FONT)
    			love.graphics.printf("?", x, y + 5, 80, "center")
			end,
		}
	end,
}
