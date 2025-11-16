local QUESTION_FONT = love.graphics.newFont(64)

return {
	create = function(self, x, y)
		local origX = x
		local x     = require("tools/lib/tweenableValue"):create(origX, { speed = 3 })
		local h     = 80
		local mousePressed = false
		local opened       = false
		
		return {
			draw = function(self)
				if self:isInside(love.mouse.getPosition()) then
					if love.mouse.isDown(1) then self:drawClicked()
					else                         self:drawHighlighted() end
				else
					self:drawUnhighlighted()
				end
			end,

			setOpened = function(self) 
				x:setDestination(10)
			end,

			setClosed = function(self) 
				x:setDestination(origX)  
			end,

			getWidth  = function(self)
				return 1190 - x:get()
			end,

			isInside = function(self, px, py)
				return px >= x:get() and px < x:get() + self:getWidth() and py >= y and py < y + h
			end,
				
			drawClicked     = function(self)
				self:drawPanel        { 1,   1,   1,   0.6 }
    			self:drawBorder       { 0,   0,   0,   0.6 }
    			self:drawQuestionMark { 0,   0,   0,   0.9 }
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
    			love.graphics.rectangle("fill", x:get(), y, self:getWidth(), h)
    		end,

    		drawBorder = function(self, color)
    			love.graphics.setColor(color)
    			love.graphics.setLineWidth(3)
    			love.graphics.rectangle("line", x:get(), y, self:getWidth(), h)
    		end,

    		drawQuestionMark = function(self, color)
    			love.graphics.setColor(color)
    			love.graphics.setFont(QUESTION_FONT)
    			love.graphics.printf("?", x:get(), y + 5, 80, "center")
			end,

			update = function(self, dt)
				x:update(dt)
			end,

			handleMousepressed = function(self, mx, my)
				if self:isInside(mx, my) then
					mousePressed = true
				end
			end,

			handleMousereleased = function(self, mx, my)
				if mousePressed then
					mousePressed = false
					opened = not opened
					if opened then self:setOpened()
					else           self:setClosed() end
				end
			end,
		}
	end,
}
