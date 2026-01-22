return {
	stateDial     = require("plugins/libraries/tweenableValue"):create(0, { speed = 3 }),

	init = function(self, visualizer)
		self.visualizer = visualizer
		self.graphics   = visualizer.graphics
		return self
	end,

	show = function(self, params)
		self.stateDial:setDestination(200)
		self.element = params.element
		self.x       = params.x
	end,

	hide = function(self)
		self.stateDial:setDestination(0)
	end,

    isVisible = function(self)
        return self.stateDial:get() > 0
    end,
    
	draw = function(self)
		local xOffset  = self.visualizer.xOffset
		local topY     = self.visualizer.topY
		
		if self.stateDial:get() > 0 then
			self.graphics:setColor(0, 0, 0, 0.4)
			self.graphics:rectangle("fill", self:getLeft(), self:getTop(), self:getWidth(), self:getHeight())
			self.graphics:setColor(1, 1, 0.3, 0.6)
			self.graphics:rectangle("line", self:getLeft(), self:getTop(), self:getWidth(), self:getHeight())
		
			self.graphics:setColor(1, 1, 0.3, 0.6 * (self.stateDial:get() / 200))
			self.graphics:line(self.x + 25 + xOffset, topY + 25, self.graphics:getScreenWidth() / 2, self:getBottom() + 2)
		end

		if self.stateDial:get() >= 100 and self.element then
			self.graphics:setColor(1, 1, 1)
			self.graphics:setFontSize(24)
			local x = self:getLeft() + 50
			local y = self:getTop()  + 30

			for _, kv in ipairs(self.element:getPublicAttributes()) do
				for k, v in pairs(kv) do
					self:drawProperty(k, v, x, y)
					y = y + 30
				end
			end
		end
	end,

	drawProperty = function(self, k, v, x, y)
		self.graphics:printf(k .. ":", x, y, self:getWidth() - 100, "left")
		local value = v
		if     type(v) == "function" then value = v(self.element)
		elseif type(v) == "table"    then value = v.selected      end
		
		self.graphics:printf(value, x + 100, y, self:getWidth() - 200, "left")
	end,

	update = function(self, dt)
		self.stateDial:update(dt)
	end,

	getWidth = function(self)
		return math.min(500, self.stateDial:get() * 5)
	end,

	getHeight = function(self)
		return math.min(200, self.stateDial:get() * 2.5)
	end,

	getLeft = function(self)
		return (self.graphics:getScreenWidth() - self:getWidth()) / 2
	end,

	getTop = function(self)
		return self.visualizer.topY - 150 - (self:getHeight() / 2)
	end,

	getBottom = function(self)
		return self.visualizer.topY - 150 + (self:getHeight() / 2)
	end,

}
