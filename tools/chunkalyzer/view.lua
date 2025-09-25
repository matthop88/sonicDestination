return {
	chunkMode = true,

	init = function(self, img, model)
		self.img   = img
		self.model = model

		self:initViewModel()

		self.GRAFX = require("tools/lib/graphics"):create()

		return self
	end,

	initViewModel = function(self)
		self.viewModel = {}

		local cX, cY = 0, 0

		for _, c in ipairs(self.model:getChunks()) do
			local quad = love.graphics.newQuad(c.x, c.y, 256, 256, self.img:getWidth(), self.img:getHeight())
			local cX, cY = math.floor(c.x / 256), math.floor(c.y / 256)
			table.insert(self.viewModel, { mapX = c.x, mapY = c.y, x = (cX * 272) + 16, y = (cY * 272) + 16, quad = quad })
		end
	end,

	draw = function(self)
		self.GRAFX:setColor(1, 1, 1)
		if self.chunkMode then self:drawChunks()
		else                   self.GRAFX:draw(self.img, 0, 0) end
	end,

	drawChunks = function(self)
		for _, c in ipairs(self.viewModel) do
			self.GRAFX:setColor(1, 1, 1)
			self.GRAFX:draw(self.img, c.quad, c.x, c.y, 0, 1, 1)
			if c.id ~= nil then
				self.GRAFX:setColor(1, 1, 1, 0.5)
				self.GRAFX:rectangle("fill", c.x, c.y, 256, 256)
				self.GRAFX:setFontSize(32)
				self.GRAFX:setColor(0, 0, 0, 0.4)
				local numberWidth = self.GRAFX:getFontWidth("" .. c.id) + 8
				self.GRAFX:rectangle("fill", c.x + 134 - (numberWidth / 2), c.y + 118, numberWidth, 32)
				self.GRAFX:setColor(1, 1, 1)
				self.GRAFX:printf("" .. c.id, c.x + 6, c.y + 116, 256, "center")
			end
		end
	end,

	tagChunk = function(self, x, y, cID)
		for _, c in ipairs(self.viewModel) do
			if c.mapX == x and c.mapY == y then c.id = cID end
		end
	end,

	toggleChunkMode = function(self)
		self.chunkMode = not self.chunkMode
	end,

	getPageWidth = function(self)
		if self.chunkMode then return ((self.img:getWidth()  / 256) * 272) + 32
		else                   return   self.img:getWidth()                 end
	end,

	getPageHeight = function(self)
		if self.chunkMode then return ((self.img:getHeight() / 256) * 272) + 32
		else                   return   self.img:getHeight()                end
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
