local PIPELINE = require("tools/lib/pipeline/pipeline"):create("Tile Pipeline")
local FEEDER   = require("tools/lib/pipeline/feeder")

local TASK_SLICE_TIME_IN_MS = 12

local CHUNKS, TILE_REPO

local processChunks = function(results, dataIn, dataOut)
	if dataIn.ALL_CHUNKS:isComplete() then
		print("Tileination complete in " .. PIPELINE:getTotalElapsedTime() .. " seconds.")
		return { completed = true }
	end
				
	dataOut.chunkID = dataIn.ALL_CHUNKS:getIndex()
	dataOut.chunk   = dataIn.ALL_CHUNKS:next()
	
end

local processChunk = function(results, dataIn, dataOut)
	if results then
		return { completed = true }
	end

	print("Processing Chunk #" .. dataIn.chunkID)

	dataOut.CHUNK_TILES = FEEDER:create("Chunk Tiles", dataIn.chunk.tiles)
end

local processTiles = function(results, dataIn, dataOut)
	if dataIn.CHUNK_TILES:isComplete() then
		return { completed = true }
	end

	dataOut.tileID = dataIn.CHUNK_TILES:getIndex()
	dataOut.tile   = dataIn.CHUNK_TILES:next()
end

local processTile = function(results, dataIn, dataOut)
	print("Processing Tile #" .. dataIn.tileID)

	return { completed = true }
end

return {
	setup = function(self, chunks)
		CHUNKS    = chunks
		TILE_REPO = {}
		
		PIPELINE:add("Chunks Processor",      processChunks)
		PIPELINE:add("Process Chunk",         processChunk)
		PIPELINE:add("Process Tiles",         processTiles)
		PIPELINE:add("Process Tile",          processTile)
		PIPELINE:push({ ALL_CHUNKS = FEEDER:create("All Chunks", CHUNKS) })
	end,

	execute = function(self)
		PIPELINE:execute(TASK_SLICE_TIME_IN_MS)
	end,

	isComplete = function(self)
		return PIPELINE:isComplete()
	end,
}
