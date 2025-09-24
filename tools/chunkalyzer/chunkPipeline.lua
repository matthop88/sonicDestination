local PIPELINE = require("tools/chunkalyzer/pipeline/pipeline"):create("Chunk Pipeline")

local TASK_SLICE_TIME_IN_MS = 0.5

local chunkNum = 0

local processMapChunks = function(chunks, printStage)
	local myChunk = chunks:next()

	if myChunk ~= nil then
		printStage:push(myChunk)
	end
end

local printChunk = function(chunk)
	local myChunk = chunk:next()

	if myChunk ~= nil then
		chunkNum = chunkNum + 1
		print("Chunk # " .. chunkNum .. ": x = ", myChunk.x, "y = ", myChunk.y)
	end
end

return {
	setup = function(self, chunks)
		PIPELINE:add("Map Processor", processMapChunks)
		PIPELINE:add("Chunk Printer", printChunk)
		PIPELINE:push(chunks)
	end,

	execute = function(self)
		PIPELINE:execute(TASK_SLICE_TIME_IN_MS)
	end,

	isComplete = function(self)
		return PIPELINE:isComplete()
	end,
}
