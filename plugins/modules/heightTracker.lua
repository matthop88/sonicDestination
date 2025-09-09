return {
    toggleShowKey = nil,
    showTracker   = false,
    graphics      = nil,
    posAndWidthFn = nil,

    leftX         = 0,
    topY          = 0,
    rightX        = 1000,

    colors        = { 
        { 1, 1, 0 }, 
        { 0, 1, 1 }, 
        { 1, 0, 1 }, 
        { 1, 0, 0 }, 
        { 0, 1, 0 }, 
        { 0, 0, 1 } 
    },

	heights       = { },
	
    init = function(self, params)
        self.toggleShowKey = params.toggleShowKey
        self.graphics      = params.graphics
        self.posAndWidthFn = params.posAndWidthFn
		self.mode          = params.mode
        return self
    end,
    
    draw = function(self)
        if self.showTracker then
            self:drawVerticalLine()
            self:drawHorizontalLineAboveSprite()
            self:drawHeights()
        end
    end,

	drawVerticalLine = function(self)
        self.graphics:setColor(1, 1, 1)
        self.graphics:setLineWidth(2)
        self.graphics:line(self.rightX, self.topY, self.rightX, love.graphics.getHeight() * 3/4)
    end,

    drawHorizontalLineAboveSprite = function(self)
        if self.posAndWidthFn then
            local x, y, w = self.posAndWidthFn()
            self.graphics:line(x, y, x + w, y)
        end
    end,

	drawHeights = function(self)
		for n, v in ipairs(self.heights) do
			local colorIndex = ((n - 1) % #self.heights) + 1
			self.graphics:setColor(self.colors[colorIndex])
			local y = 576 - (v.value * 12)
			self.graphics:line(self.rightX - 115, y, self.rightX + 15, y)
		end
	end,

	update = function(self, dt)
		if self.showTracker then
			self:updateWorldCoordinates()
			self:recordHeight()
		end
	end,

	updateWorldCoordinates = function(self)
        self.leftX,  self.topY    = self.graphics:screenToImageCoordinates(0, 0)
        self.rightX, _            = self.graphics:screenToImageCoordinates(love.graphics.getWidth() - 24, love.graphics.getHeight())
    end,
            
	recordHeight = function(self)
		if self.posAndWidthFn and self.mode then
			local x, y, w = self.posAndWidthFn()
			local heightInFeet = (576 - y) / 12
			self:setHeight(self.mode, heightInFeet)
		end
	end,

	setHeight = function(self, mode, height)
		local recordedHeight = self:getHeight(self.mode)
		if not recordedHeight then
			table.insert(self.heights, { mode = mode, value = height })
		elseif height > recordedHeight.value then
			recordedHeight.value = height
		end
	end,

	getHeight = function(self, mode)
		for _, v in ipairs(self.heights) do
			if v.mode == mode then return v end
		end
	end,

	handleKeypressed = function(self, key)
        if key == self.toggleShowKey then
            self.showTracker = not self.showTracker
        end
    end,

	setMode = function(self, mode)
		self.mode = mode
	end,
}
