local STRING_UTIL = require("tools/lib/stringUtil")

return {
	create = function(self, params)
		local widthInChunks  = params.w        or 256
		local heightInChunks = params.h        or 256
		local chunkWidth     = params.chunkW   or 256
		local chunkHeight    = params.chunkH   or 256
		local manager        = params.manager
		
		local chunkMap       = self:createChunkMap(widthInChunks, heightInChunks)

		return {
			width          = widthInChunks,
			height         = heightInChunks,
			chunkWidth     = chunkWidth,
			chunkHeight    = chunkHeight,
			CHUNKS_MANAGER = manager,
			chunkMap       = chunkMap,
			maxRow         = 0,

			draw = function(self, GRAFX)
				GRAFX:setColor(1, 1, 1)
    			for i = 1, self.height do
        			local c = self.chunkMap[i]
        			for j = 1, self.width do
            			if c[j] ~= 0 then
                			c[j]:draw(GRAFX, (j - 1) * self.chunkWidth, (i - 1) * self.chunkHeight)
                		end
                	end
                end
            end,

            drawMouseChunk = function(self, GRAFX)
        		local x, y = GRAFX:screenToImageCoordinates(love.mouse.getPosition())
        		GRAFX:rectangle("line", 
        			x - (self.chunkWidth / 2), y - (self.chunkHeight / 2), self.chunkWidth, self.chunkHeight)
        		GRAFX:setColor(1, 1, 1, 0.8)
        		self.CHUNKS_MANAGER:get():draw(GRAFX, x - (self.chunkWidth / 2), y - (self.chunkHeight / 2))
            		
    		end,

    		placeChunk = function(self, GRAFX, mx, my)
    			local x, y = GRAFX:screenToImageCoordinates(mx, my)
        		local j, i = math.floor(x / self.chunkWidth) + 1, math.floor(y / self.chunkHeight) + 1
        		self.chunkMap[i][j] = self.CHUNKS_MANAGER:get()
        		self.chunkMap[i].hasData = true
        		self.maxRow = math.max(self.maxRow, i)
        		self.chunkMap[i].maxCell = math.max(self.chunkMap[i].maxCell, j)
        	end,

        	printAsTable = function(self)
        		print("{")
        		for rowNum, chunkRow in ipairs(self.chunkMap) do
        			if rowNum <= self.maxRow then
        				if chunkRow.hasData then
	        				print("  { row = " .. rowNum .. ", data = " .. self:getRowData(chunkRow) .. " },")
	        			else
	        				print("  { row = " .. rowNum .. ", data = {} },")
	        			end
	        		end
        		end
        		print("}")
        	end,

        	getRowData = function(self, chunkRow)
        		local results = {}
        		for n, v in ipairs(chunkRow) do
        			if n <= chunkRow.maxCell then
        				if v == 0 then table.insert(results, "0")
        				else           table.insert(results, "{ \"" .. v.name .. "\", " .. v.id .. " }") end
        			end
        		end
        		return "{ " .. (STRING_UTIL:join(results, ", ") or "") .. " }"
        	end,
		}
	end,

	createChunkMap = function(self, widthInChunks, heightInChunks)
		local chunkMap = {}

		for i = 1, heightInChunks do
		    local c = { maxCell = 0, }
		    for j = 1, widthInChunks do table.insert(c, 0) end
		    table.insert(chunkMap, c)
		end

		return chunkMap
	end,
}
