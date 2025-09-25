local PIPELINE = require("tools/chunkalyzer/pipeline/pipeline"):create("Chunk Pipeline")
local FEEDER   = require("tools/chunkalyzer/pipeline/feeder")

local TASK_SLICE_TIME_IN_MS = 0.5

local chunkNum = 0

local processMapChunks = function(results, inData, outData)
	if results then
		if inData.MAP_CHUNKS:isComplete() then
			return { completed = true }
		end
	end
				
	outData.mapChunk = inData.MAP_CHUNKS:next()
end

local printChunk = function(results, inData, outData)
	chunkNum = chunkNum + 1
	print("Chunk # " .. chunkNum .. ": x = ", inData.mapChunk.x, "y = ", inData.mapChunk.y)

	return { printed = true }
end

return {
	setup = function(self, chunks)
		PIPELINE:add("Map Processor", processMapChunks)
		PIPELINE:add("Chunk Printer", printChunk)
		PIPELINE:push({ MAP_CHUNKS = FEEDER:create("Map Chunks", chunks) })
	end,

	execute = function(self)
		PIPELINE:execute(TASK_SLICE_TIME_IN_MS)
	end,

	isComplete = function(self)
		return PIPELINE:isComplete()
	end,
}
