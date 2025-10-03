local PIPELINE = require("tools/lib/pipeline/pipeline"):create("Tile Pipeline")
local FEEDER   = require("tools/lib/pipeline/feeder")

local TASK_SLICE_TIME_IN_MS = 12

local CHUNKS, TILE_REPO

local processChunks = function(results, dataIn, dataOut)
	if dataIn.ALL_CHUNKS:isComplete() then
		print("Tileination complete in " .. PIPELINE:getTotalElapsedTime() .. " seconds.")
		return { completed = true }
	end
				
	dataOut.chunk = dataIn.ALL_CHUNKS:next()
end

local processChunk = function(results, dataIn, dataOut)
	print("Processing Chunk #" .. dataIn.chunk.chunkID)

	return { completed = true }
end

return {
	setup = function(self, chunks)
		CHUNKS    = chunks
		TILE_REPO = {}
		
		PIPELINE:add("Chunks Processor",      processChunks)
		PIPELINE:add("Process Chunk",         processChunk)
		PIPELINE:push({ ALL_CHUNKS = FEEDER:create("All Chunks", CHUNKS) })
	end,

	execute = function(self)
		PIPELINE:execute(TASK_SLICE_TIME_IN_MS)
	end,

	isComplete = function(self)
		return PIPELINE:isComplete()
	end,
}
