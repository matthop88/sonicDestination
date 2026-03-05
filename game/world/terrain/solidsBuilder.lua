return {
	create = function(self, chunkData)
		local solids = {
			draw = function(self, graphics, rowNum, colNum, chunkID)
				local x = (colNum - 1) * 256
				local y = (rowNum - 1) * 256
        		
				self:drawAt(graphics, x, y, chunkID)
		    end,

		    xFlippedDraw = function(self, graphics, rowNum, colNum, chunkID)
		    	local x = (colNum - 1) * 256
				local y = (rowNum - 1) * 256
        		
				self:xFlippedDrawAt(graphics, x, y, chunkID)
			end,

		    drawAt = function(self, graphics, x, y, chunkID)
		    	local chunkSolids = self[chunkID]
		    	local rowY = y
				for n, rowOfSolids in ipairs(chunkSolids) do
					local rowX = x
					for _, solid in ipairs(rowOfSolids) do
						if solid == 1 then
							graphics:setLineWidth(2)
                			graphics:line(rowX, rowY, rowX + 16, rowY)
                		end
                		rowX = rowX + 16
                	end
                	rowY = rowY + 16
				end
			end,

			xFlippedDrawAt = function(self, graphics, x, y, chunkID)
		    	local chunkSolids = self[chunkID]
		    	local rowY = y
				for n, rowOfSolids in ipairs(chunkSolids) do
					local rowX = x + 240
					for _, solid in ipairs(rowOfSolids) do
						if solid == 1 then
							graphics:setLineWidth(2)
                			graphics:line(rowX, rowY, rowX + 16, rowY)
                		end
                		rowX = rowX - 16
                	end
                	rowY = rowY + 16
				end
			end,

		    getSolidAt = function(self, chunkID, xInChunk, yInChunk, xFlip)
		    	if xFlip then
		    		return self:getChunkSolidAt(chunkID, 17 - xInChunk, yInChunk)
		    	else
		    		return self:getChunkSolidAt(chunkID, xInChunk, yInChunk)
		    	end
		    end,

		    getChunkSolidAt = function(self, chunkID, xInChunk, yInChunk)
        		local chunkSolids = self[chunkID]
        		if    chunkSolids == nil then return nil
        		else                          return chunkSolids[yInChunk][xInChunk] end
        	end,
    	}

		for n, chunk in ipairs(chunkData) do
			local chunkSolids = {}
			for _, row in ipairs(chunk) do
				if row.S == nil then row.S = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, } end
				table.insert(chunkSolids, row.S)
			end
			table.insert(solids, chunkSolids)
		end

		return solids
	end,
}
