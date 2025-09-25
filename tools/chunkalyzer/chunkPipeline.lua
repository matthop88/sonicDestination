local PIPELINE = require("tools/chunkalyzer/pipeline/pipeline"):create("Chunk Pipeline")
local FEEDER   = require("tools/chunkalyzer/pipeline/feeder")

local TASK_SLICE_TIME_IN_MS = 10

local chunkNum = 0
local IMAGE_DATA, CHUNK_VIEW

local getPixelColorAt = function(x, y)
    local r, g, b, a = IMAGE_DATA:getPixel(math.floor(x), math.floor(y))
    return { r = r, g = g, b = b, a = a }
end

local colorsMatch = function(c1, c2)
    return c1 ~= nil 
       and c2 ~= nil
       and math.abs(c1.r - c2.r) < 0.005
       and math.abs(c1.g - c2.g) < 0.005 
       and math.abs(c1.b - c2.b) < 0.005
       and math.abs(c1.a - c2.a) < 0.005
end

local comparePixelsInChunkRow = function(c1X, c1Y, c2X, c2Y)
    local x1, y1, x2, y2 = c1X, c1Y, c2X, c2Y

    for i = 0, 255 do
        if not colorsMatch(getPixelColorAt(x1, y1), getPixelColorAt(x2, y2)) then
            return false
        end
        x1 = x1 + 1
        x2 = x2 + 1
    end

    return true
end

local CHUNK_REPO = {
	add = function(self, chunk)
		table.insert(self, chunk)
		return #self
	end,
}

local sliceChunkIntoRows = function(chunk)
	local rows = {}

	for y = chunk.y, chunk.y + 255 do
		table.insert(rows, { x = chunk.x, y = y} )
	end

	return rows
end

local processMapChunks = function(results, dataIn, dataOut)
	if results then
		CHUNK_VIEW:tagChunk(results.chunk.x, results.chunk.y, results.repoChunkID, results.wasAdded)

		if dataIn.MAP_CHUNKS:isComplete() then
			return { completed = true }
		end
	end
				
	dataOut.mapChunk   = dataIn.MAP_CHUNKS:next()
	dataOut.CHUNK_REPO = FEEDER:create("Chunk Repo", CHUNK_REPO)
end

local addMapChunkToRepo = function(results, dataIn, dataOut)
	if results then
		local repoChunkID
					
		if not results.chunkIsUnique then
			repoChunkID = results.repoChunkID
			return { repoChunkID = repoChunkID, chunk = results.chunk, wasAdded = false }
		else
			if dataIn.CHUNK_REPO:isComplete() then
				repoChunkID = dataIn.CHUNK_REPO:get():add(results.chunk)
				return { repoChunkID = repoChunkID, chunk = results.chunk, wasAdded = true }
			end
		end
	end
			
	dataOut.mapChunk    = dataIn.mapChunk
	dataOut.repoChunkID = dataIn.CHUNK_REPO:getIndex()
	dataOut.repoChunk   = dataIn.CHUNK_REPO:next()
end

local compareChunks = function(results, dataIn, dataOut)
	if dataIn.repoChunk == nil then
		return { chunkIsUnique = true, chunk = dataIn.mapChunk }
	elseif results then
		return { chunkIsUnique = not results.chunksAreEqual, chunk = dataIn.mapChunk, repoChunkID = dataIn.repoChunkID }
	end		
		
	dataOut.mapChunkRows  = FEEDER:create("Map Chunk Row",  sliceChunkIntoRows(dataIn.mapChunk))
	dataOut.repoChunkRows = FEEDER:create("Repo Chunk Row", sliceChunkIntoRows(dataIn.repoChunk))
end

local compareChunkRows = function(results, dataIn, dataOut)
	if results then
		if not results.rowsAreEqual then
			return { chunksAreEqual = false }
		elseif dataIn.mapChunkRows:isComplete() then
			return { chunksAreEqual = true }
		end
	end

	dataOut.mapChunkRow  = dataIn.mapChunkRows:next()
	dataOut.repoChunkRow = dataIn.repoChunkRows:next() 
end

local compareChunkRow = function(results, dataIn, dataOut)
	local rowsAreEqual = comparePixelsInChunkRow(dataIn.mapChunkRow.x, dataIn.mapChunkRow.y, dataIn.repoChunkRow.x, dataIn.repoChunkRow.y)
			
	return { rowsAreEqual = rowsAreEqual }
end

return {
	setup = function(self, chunks, imageData, chunkalyzerView)
		IMAGE_DATA = imageData
		CHUNK_VIEW = chunkalyzerView
		PIPELINE:add("Map Processor",         processMapChunks)
		PIPELINE:add("Add Map Chunk to Repo", addMapChunkToRepo)
		PIPELINE:add("Compare Chunks",        compareChunks)
		PIPELINE:add("Compare Chunk Rows",    compareChunkRows)
		PIPELINE:add("Compare Chunk Row",     compareChunkRow)
		PIPELINE:push({ MAP_CHUNKS = FEEDER:create("Map Chunks", chunks) })
	end,

	execute = function(self)
		PIPELINE:execute(TASK_SLICE_TIME_IN_MS)
	end,

	isComplete = function(self)
		return PIPELINE:isComplete()
	end,
}
