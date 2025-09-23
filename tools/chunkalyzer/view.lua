return {
	chunkMode = true,

	init = function(self, imgPath)
		self.imgData = love.image.newImageData(imgPath)
		self.img     = love.graphics.newImage(self.imgData)
		self.img:setFilter("nearest", "nearest")
		
		self.GRAFX = require("tools/lib/graphics"):create()

		self:initQuads()

		return self
	end,

	initQuads = function(self)
		self.chunks = {}

		for y = 0, math.floor(self.img:getHeight() / 256) - 1 do
			for x = 0, math.floor(self.img:getWidth() / 256) - 1 do
				table.insert(self.chunks, { x = (x * 272) + 16, y = (y * 272) + 16, quad = love.graphics.newQuad(x * 256, y * 256, 256, 256, self.img:getWidth(), self.img:getHeight()) })
			end
		end
	end,

	draw = function(self)
		self.GRAFX:setColor(1, 1, 1)
		if self.chunkMode then
			for _, c in ipairs(self.chunks) do self.GRAFX:draw(self.img, c.quad, c.x, c.y, 0, 1, 1) end
		else
			self.GRAFX:draw(self.img, 0, 0)
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
