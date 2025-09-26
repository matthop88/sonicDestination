return {
	chunkMode = true,

	init = function(self, img, model)
		self.img   = img
		self.model = model

		self:initViewModel()

		self.GRAFX = require("tools/lib/graphics"):create()

		self.pageWidth  = ((self.img:getWidth()  / 256) * 272) + 32
		self.pageHeight = ((self.img:getHeight() / 256) * 272) + 32

		return self
	end,

	initViewModel = function(self)
		self.viewModel = {}

		local cX, cY = 0, 0

		for _, c in ipairs(self.model:getChunks()) do
			local quad = love.graphics.newQuad(c.x, c.y, 256, 256, self.img:getWidth(), self.img:getHeight())
			local cX, cY = math.floor(c.x / 256), math.floor(c.y / 256)
			table.insert(self.viewModel, { alpha = 1, mapX = c.x, mapY = c.y, x = (cX * 272) + 16, origX = (cX * 272) + 16, y = (cY * 272) + 16, origY = (cY * 272) + 16, quad = quad })
		end
	end,

	draw = function(self)
		self.GRAFX:setColor(1, 1, 1)
		if self.chunkMode then self:drawChunks()
		else                   self.GRAFX:draw(self.img, 0, 0) end
	end,

	drawChunks = function(self)
		for _, c in ipairs(self.viewModel) do
			if not c.id or (c.id and not c.isUnique) then
				self.GRAFX:setColor(1, 1, 1, c.alpha)
				self.GRAFX:draw(self.img, c.quad, c.x, c.y, 0, 1, 1)
			end
		end

		for _, c in ipairs(self.viewModel) do
			if c.id and c.isUnique then
				self.GRAFX:setColor(1, 1, 1, c.alpha)
				self.GRAFX:draw(self.img, c.quad, c.x, c.y, 0, 1, 1)
				self.GRAFX:setColor(1, 1, 1, c.highlightAlpha)
				self.GRAFX:rectangle("fill", c.x, c.y, 256, 256)
				self.GRAFX:setFontSize(96)
				self.GRAFX:setColor(0, 0, 0, 0.4)
				local numberWidth = self.GRAFX:getFontWidth("" .. c.id) + 8
				self.GRAFX:rectangle("fill", c.x + 134 - (numberWidth / 2), c.y + 86, numberWidth, 96)
				self.GRAFX:setColor(1, 1, 1)
				self.GRAFX:printf("" .. c.id, c.x + 6, c.y + 84, 256, "center")
			end
		end
	end,

	update = function(self, dt)
		for _, c in ipairs(self.viewModel) do
			if c.id then
				if c.isUnique then
					if not c.targetChunk or c.targetChunk.isMoved then
						c.x = c.x + (c.targetX - c.origX) * (2 * dt)
						if math.abs(c.origX - c.x) > math.abs(c.origX - c.targetX) then
							c.x = c.targetX
						end
						c.y = c.y + (c.targetY - c.origY) * (2 * dt)
						if math.abs(c.origY - c.y) > math.abs(c.origY - c.targetY) then
							c.y = c.targetY
						end
						c.isMoved = true
					end
					if c.x == c.targetX and c.y == c.targetY then
						c.highlightAlpha = math.max(0, c.highlightAlpha - (0.5 * dt))
					else
						c.highlightAlpha = math.min(0.5, c.highlightAlpha + (0.5 * dt))
					end
				else
					c.alpha = math.max(0, c.alpha - (1 * dt))
					if c.alpha == 0 then
						c.isMoved = true
					end
				end
			end
		end
	end,

	tagChunk = function(self, x, y, cID, isUnique)
		for _, c in ipairs(self.viewModel) do
			if c.mapX == x and c.mapY == y then 
				c.id = cID
				c.targetX = (((cID - 1) % 9) * 272) + 16
				c.targetY = (math.floor((cID - 1) / 9) * 272) + 16
				c.isUnique = isUnique 
				c.highlightAlpha = 0

				for _, k in ipairs(self.viewModel) do
					if k.origX == c.targetX and k.origY == c.targetY then
						c.targetChunk = k
					end
				end
			end
		end

		self:updatePageWidthAndHeight()
	end,

	updatePageWidthAndHeight = function(self)
		local width, height = 0, 0
		for _, c in ipairs(self.viewModel) do
			if c.targetX and c.targetY then
				width  = math.max(width,  c.targetX + 304)
				height = math.max(height, c.targetY + 304)
			else
				width  = math.max(width,  c.x + 304)
				height = math.max(height, c.y + 304)
			end
		end

		self.pageWidth  = width
		self.pageHeight = height
	end,
	
	toggleChunkMode = function(self)
		self.chunkMode = not self.chunkMode
	end,

	getPageWidth = function(self)
		if self.chunkMode then return self.pageWidth
		else                   return self.img:getWidth() end
	end,

	getPageHeight = function(self)
		if self.chunkMode then return self.pageHeight
		else                   return self.img:getHeight() end
	end,

    keepImageInBounds = function(self)
        self.GRAFX:setX(math.min(0, math.max(self.GRAFX:getX(), (love.graphics:getWidth()  / self.GRAFX:getScale()) - self:getPageWidth())))
        self.GRAFX:setY(math.min(0, math.max(self.GRAFX:getY(), (love.graphics:getHeight() / self.GRAFX:getScale()) - self:getPageHeight())))
    end,

    moveImage = function(self, deltaX, deltaY)
	    self.GRAFX:moveImage(deltaX, deltaY)
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return self.GRAFX:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        self.GRAFX:adjustScaleGeometrically(deltaScale)
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        self.GRAFX:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,

}
