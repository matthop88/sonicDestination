local CHUNK_SIZE = 256

return {
	draw = function(self, GRAFX)
		local leftX, topY = GRAFX:screenToImageCoordinates(0, 0)
		local rightX, bottomY = GRAFX:screenToImageCoordinates(love.graphics:getWidth(), love.graphics:getHeight())
		
		GRAFX:setColor(1, 1, 1)
        GRAFX:setLineWidth(0.25)

        self:drawChunkGrid(GRAFX, leftX, topY, rightX, bottomY)
	end,

	drawChunkGrid = function(self, GRAFX, leftX, topY, rightX, bottomY)
		local offsetX = leftX % CHUNK_SIZE
        local startX  = leftX - offsetX
        
        local offsetY = topY  % CHUNK_SIZE
        local startY  = topY  - offsetY
        
        for i = startX, rightX + CHUNK_SIZE, CHUNK_SIZE do GRAFX:line(i, topY, i, bottomY) end
        for i = startY, rightX + CHUNK_SIZE, CHUNK_SIZE do GRAFX:line(leftX, i, rightX, i) end
	end,
}
