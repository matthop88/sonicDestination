local UBER_SUPER_CHUNK_SIZE = 65536
local SUPER_CHUNK_SIZE      = 4096
local CHUNK_SIZE            = 256
local TILE_SIZE             = 16
local PIXEL_SIZE            = 1

return {
	init = function(self, params)
		self.graphics = params.graphics
		self.bounds   = params.bounds

		return self
	end,

	draw = function(self)
		local leftX,  topY    = self.graphics:screenToImageCoordinates(0, 0)
		local rightX, bottomY = self.graphics:screenToImageCoordinates(love.graphics:getWidth(), love.graphics:getHeight())
		
		if (rightX - leftX) <= 192 then
			self:drawPixelGrid(leftX, topY, rightX, bottomY)
		end

		if (rightX - leftX) <= 1536 then
			self:drawTileGrid(leftX, topY, rightX, bottomY)
		end

		if (rightX - leftX) <= 24576 then
			self:drawChunkGrid(leftX, topY, rightX, bottomY)
		end

		self:drawSuperChunkGrid(leftX, topY, rightX, bottomY)

		self:drawUberSuperChunkGrid(leftX, topY, rightX, bottomY)
	end,

	drawPixelGrid  = function(self, leftX, topY, rightX, bottomY)
		self.graphics:setColor(0.5, 0.5, 0.3, (192 - (rightX - leftX)) / 192)
		self.graphics:setLineWidth(0.125)

		self:drawGrid(leftX, topY, rightX, bottomY, PIXEL_SIZE)
	end,

	drawTileGrid  = function(self, leftX, topY, rightX, bottomY)
		self.graphics:setColor(0.5, 0.5, 0.5, (1536 - (rightX - leftX)) / 1536)
		self.graphics:setLineWidth(0.25)

		self:drawGrid(leftX + 0.25, topY + 0.25, rightX + 0.25, bottomY + 0.25, TILE_SIZE)
	end,

	drawChunkGrid = function(self, leftX, topY, rightX, bottomY)
		self.graphics:setColor(0.8, 0.8, 0.8, (24576 - (rightX - leftX)) / 24576)
        self.graphics:setLineWidth(0.5)

        self:drawGrid(leftX, topY, rightX, bottomY, CHUNK_SIZE)
	end,

	drawSuperChunkGrid = function(self, leftX, topY, rightX, bottomY)
		self.graphics:setColor(0.9, 0.9, 0.9, (393216 - (rightX - leftX)) / 393216)
		self.graphics:setLineWidth(1)
		self:drawGrid(leftX, topY, rightX, bottomY, SUPER_CHUNK_SIZE)
	end,

	drawUberSuperChunkGrid = function(self, leftX, topY, rightX, bottomY)
		self.graphics:setColor(1, 1, 1)
		self.graphics:setLineWidth(1)
		self:drawGrid(leftX, topY, rightX, bottomY, UBER_SUPER_CHUNK_SIZE)
	end,
	
	drawGrid = function(self, leftX, topY, rightX, bottomY, gridSize)
		local offsetX = leftX % gridSize
        local startX  = leftX - offsetX
        
        local offsetY = topY  % gridSize
        local startY  = topY  - offsetY
        
        for i = startX, rightX  + gridSize, gridSize do self:drawLine(i, topY, i, bottomY) end
        for i = startY, bottomY + gridSize, gridSize do self:drawLine(leftX, i, rightX, i) end
	end,

	drawLine = function(self, x1, y1, x2, y2)
		if self.bounds == nil then
			self:drawUnboundedLine(x1, y1, x2, y2)
		else
			self:drawBoundedLine(x1, y1, x2, y2)
		end
	end,

	drawUnboundedLine = function(self, x1, y1, x2, y2)
		self.graphics:line(x1, y1, x2, y2)
	end,

	drawBoundedLine = function(self, x1, y1, x2, y2)
		if     x1 == x2 and (x1 >= (self.bounds.x * 256) and x1 <= ((self.bounds.x + self.bounds.w) * 256)) then
			self.graphics:line(x1, self.bounds.y * 256, x2, (self.bounds.y + self.bounds.h) * 256)
		elseif y1 == y2 and (y1 >= (self.bounds.y * 256) and y1 <= ((self.bounds.y + self.bounds.h) * 256)) then
	    	self.graphics:line(self.bounds.x * 256, y1, (self.bounds.x + self.bounds.w) * 256, y2)
	    end
	end,
}
