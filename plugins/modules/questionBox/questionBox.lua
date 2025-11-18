local QUESTION_FONT = love.graphics.newFont(32)
local DOCS_FONT     = love.graphics.newFont(24)

return {
	w = require("plugins/libraries/tweenableValue"):create(40,   { speed = 6 }),
	h = require("plugins/libraries/tweenableValue"):create(40,   { speed = 6 }),
		
	opened = false,

	init = function(self, params)
		self.origX = params.x or 800
		self.x = require("plugins/libraries/tweenableValue"):create(self.origX, { speed = 6 })
		self.y = params.y or 10
		self.maxW = params.w or 800
		self.destX = params.destX or 200
		self.lines = params.lines or {}
		self.maxH  = math.max(40, (#self.lines * 28) + 28)
		self.useDoubleClick   = params.useDoubleClick
		self.getDoubleClickFn = params.getDoubleClickFn
	end,

	draw = function(self)
		if self:isInside(love.mouse.getPosition()) or self.opened or self.h:inFlux() or self.x:inFlux() then
			if love.mouse.isDown(1) then self:drawClicked()
			else                         self:drawHighlighted() end
		else
			self:drawUnhighlighted()
		end
		self:drawText()
	end,

	isInside = function(self, px, py)
		return px >= self.x:get() and px < self.x:get() + self:getWidth() and py >= self.y and py < self.y + self.h:get()
	end,
					
	drawUnhighlighted = function(self)
		self:drawPanel        { 0.3, 0.3, 0.3, 0.1 }
    	self:drawBorder       { 0,   0,   0,   0.1 }
    	self:drawQuestionMark { 1,   1,   1,   0.1 }
	end,

	drawHighlighted = function(self)
		local alpha = 0.6
		if self.getDoubleClickFn and not self.opened and not self.getDoubleClickFn():withinThreshold() and not self.x:inFlux() then
			alpha = 0.2
		end
		self:drawPanel        { 0.3, 0.3, 0.3, alpha }
		self:drawBorder       { 1,   1,   0,   alpha }
		self:drawQuestionMark { 1,   1,   0,   (alpha + 0.2) * self:getQuestionMarkAlpha() }
	end,

	drawClicked = function(self)
		local alpha = 0.6
		if self.opened or self.x:inFlux() then self:drawPanel { 0.3, 0.3, 0.3, 0.1 }
		else                                   self:drawPanel { 1,   1,   1,   0.6 } end

		self:drawBorder       { 0,   0,   0,   0.6 }
    	self:drawQuestionMark { 0,   0,   0,   (alpha + 0.2) * self:getQuestionMarkAlpha() }
    end,
	
    drawPanel = function(self, color)
    	love.graphics.setColor(color)
    	love.graphics.rectangle("fill", self.x:get(), self.y, self:getWidth(), self.h:get())
    end,

    drawBorder = function(self, color)
    	love.graphics.setColor(color)
    	love.graphics.setLineWidth(3)
    	love.graphics.rectangle("line", self.x:get(), self.y, self:getWidth(), self.h:get())
    end,

    drawQuestionMark = function(self, color)
    	love.graphics.setColor(color)
    	love.graphics.setFont(QUESTION_FONT)
    	love.graphics.printf("?", self.x:get(), self.y + 2, self:getWidth(), "center")
	end,

	getWidth = function(self)
		return self.w:get()
	end,

	getQuestionMarkAlpha = function(self)
		return 1 - (self.w:get() - 40) / (self.maxW - 80)
	end,

	drawText = function(self)
		if self.h:inFlux() or self.opened then
			love.graphics.setColor(1, 1, 1)
			love.graphics.setFont(DOCS_FONT)
			local maxN = #self.lines * ((self.h:get() - 40) / (self.maxH - 40))
			for n, line in ipairs(self.lines) do
				local lineY = (self.y - 15) + (n * 28)
				if n <= maxN then
					if type(line) == "table" then
						local tx = self.x:get() + 20
						for c, text in ipairs(line) do
							love.graphics.printf(text, tx, lineY, self:getWidth() - 20, "left")
							tx = tx + (self.lines.tabSize or 100)
						end
					else
						love.graphics.printf(line, self.x:get() + 20, lineY, self:getWidth() - 20, "left")
					end
				end
			end
		end
	end,

	update = function(self, dt)
		if         self.opened and not self.x:inFlux() then self.h:setDestination(self.maxH)
		elseif not self.opened and not self.h:inFlux() then 
			self.x:setDestination(self.origX) 
			self.w:setDestination(40)
		end

		self.x:update(dt)
		self.w:update(dt)
		self.h:update(dt)
	end,

	handleKeypressed = function(self, key)
		if self:isInside(love.mouse.getPosition()) and not self.opened then
			if key == "return" then 
				self.opened = true
				self:setOpened() 
			end
			return true
		elseif self.opened then
			if key == "escape" then 
				self.opened = false
				self:setClosed()
			end
			return true
		end
	end,

	handleMousepressed = function(self, mx, my, params)
		if self:isInside(mx, my) or self.opened then
			if not self.useDoubleClick or (params and params.doubleClicked) then
				self.opened = not self.opened
			end

			if self.opened then self:setOpened()
			else                self:setClosed() end

			return true
		end
	end,

	setOpened = function(self) 
		self.x:setDestination(self.destX)
		self.w:setDestination(self.maxW)
	end,

	setClosed = function(self) 
		self.h:setDestination(40)
	end,
}
