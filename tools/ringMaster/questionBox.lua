local QUESTION_FONT = love.graphics.newFont(32)
local DOCS_FONT     = love.graphics.newFont(24)
local clickedAt     = love.timer.getTime()

return {
	create = function(self, x, y, lines)
		local origX = x
		local x     = require("tools/lib/tweenableValue"):create(origX, { speed = 9 })
		local h     = require("tools/lib/tweenableValue"):create(40,    { speed = 6 })
		local mousePressed = false
		local opened       = false
		
		return {
			draw = function(self)
				if self:isInside(love.mouse.getPosition()) then
					if love.mouse.isDown(1) then self:drawClicked()
					else                         self:drawHighlighted() end
				elseif x:get() ~= origX then self:drawHighlighted()
				else                         self:drawUnhighlighted() end
				self:drawText()
			end,

			drawText = function(self)
				if not x:inFlux() and x:get() ~= origX then
					love.graphics.setColor(1, 1, 1)
					love.graphics.setFont(DOCS_FONT)
					local lineY
					local maxN = #lines * ((h:get() - 40) / 240)
					for n, line in ipairs(lines) do
						lineY = (y + 5) + (n * 24)
						if n <= maxN then
							love.graphics.printf(line, x:get() + 20, lineY, self:getWidth() - 20, "left")
						end
					end
				end
			end,

			setOpened = function(self) 
				x:setDestination(200)
			end,

			setClosed = function(self) 
				h:setDestination(40)
			end,

			getWidth  = function(self)
				return math.min(800, 1190 - x:get())
			end,

			isInside = function(self, px, py)
				return px >= x:get() and px < 1190 and py >= y and py < y + h:get()
			end,
				
			drawClicked     = function(self)
				if opened then
					self:drawPanel { 0.3, 0.3, 0.3, 0.6 }
				else
					self:drawPanel { 1,   1,   1,   0.6 }
				end
    			self:drawBorder       { 0,   0,   0,   0.6 }
    			self:drawQuestionMark { 0,   0,   0,   0.9 * ((1 - (self:getWidth() - 80) / 720)) }
    		end,

			drawHighlighted = function(self)
				local alpha = 0.2
				if self:withinDoubleClickMargin() then
					alpha = 0.6
				end
    			self:drawPanel        { 0.3, 0.3, 0.3, alpha }
    			self:drawBorder       { 1,   1,   0,   alpha }
    			self:drawQuestionMark { 1,   1,   0,   (alpha + 0.2) * ((1 - (self:getWidth() - 40) / 720)) }
    		end,

    		drawUnhighlighted = function(self)
    			self:drawPanel        { 0.3, 0.3, 0.3, 0.1 }
    			self:drawBorder       { 0,   0,   0,   0.1 }
    			self:drawQuestionMark { 1,   1,   1,   0.1 * ((1 - (self:getWidth() - 40) / 720)) }
    		end,

    		drawPanel = function(self, color)
    			love.graphics.setColor(color)
    			love.graphics.rectangle("fill", x:get(), y, self:getWidth(), h:get())
    		end,

    		drawBorder = function(self, color)
    			love.graphics.setColor(color)
    			love.graphics.setLineWidth(3)
    			love.graphics.rectangle("line", x:get(), y, self:getWidth(), h:get())
    		end,

    		drawQuestionMark = function(self, color)
    			love.graphics.setColor(color)
    			love.graphics.setFont(QUESTION_FONT)
    			love.graphics.printf("?", x:get(), y + 2, 40, "center")
			end,

			update = function(self, dt)
				x:update(dt)
				h:update(dt)
				if opened and not x:inFlux() then
					h:setDestination(320)
				elseif not opened and not h:inFlux() then
					x:setDestination(origX)
				end
			end,

			handleMousepressed = function(self, mx, my)
				if self:isInside(mx, my) then
					if self:withinDoubleClickMargin() then
						mousePressed = true
					end
					clickedAt = love.timer.getTime()
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

			withinDoubleClickMargin = function(self)
				return love.timer.getTime() - clickedAt < 0.3
			end,
		}
	end,
}
