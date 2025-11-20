local CHUNK_SIZE = 256
local TILE_SIZE  = 16

return {
	draw = function(self, GRAFX)
		local leftX, topY = GRAFX:screenToImageCoordinates(0, 0)
		local rightX, bottomY = GRAFX:screenToImageCoordinates(love.graphics:getWidth(), love.graphics:getHeight())
		
		if (rightX - leftX) <= 512 then
			self:drawTileGrid(GRAFX, leftX, topY, rightX, bottomY)
		end

		self:drawChunkGrid(GRAFX, leftX, topY, rightX, bottomY)
	end,

	drawTileGrid  = function(self, GRAFX, leftX, topY, rightX, bottomY)
		GRAFX:setColor(0.5, 0.5, 0.5, (512 - (rightX - leftX)) / 512)
		GRAFX:setLineWidth(0.25)

		self:drawGrid(GRAFX, leftX, topY, rightX, bottomY, TILE_SIZE)
	end,

	drawChunkGrid = function(self, GRAFX, leftX, topY, rightX, bottomY)
		GRAFX:setColor(1, 1, 1)
        GRAFX:setLineWidth(0.25)

        self:drawGrid(GRAFX, leftX, topY, rightX, bottomY, CHUNK_SIZE)
	end,
	
	drawGrid = function(self, GRAFX, leftX, topY, rightX, bottomY, gridSize)
		local offsetX = leftX % gridSize
        local startX  = leftX - offsetX
        
        local offsetY = topY  % gridSize
        local startY  = topY  - offsetY
        
        for i = startX, rightX + gridSize, gridSize do GRAFX:line(i, topY, i, bottomY) end
        for i = startY, rightX + gridSize, gridSize do GRAFX:line(leftX, i, rightX, i) end
	end,
}
