local PIPELINE = require("tools/chunkalyzer/pipeline/pipeline"):create("Chunk Pipeline")
local FEEDER   = require("tools/chunkalyzer/pipeline/feeder")

local TASK_SLICE_TIME_IN_MS = 0.5

local chunkNum = 0

local CHUNK_REPO = {
	add = function(self, chunk)
		table.insert(self, chunk)
		return #self
	end,
}

local processMapChunks = function(results, inData, outData)
	if results then
		if inData.MAP_CHUNKS:isComplete() then
			return { completed = true }
		end
	end
				
	outData.mapChunk = inData.MAP_CHUNKS:next()
end

local processMapChunks = function(results, dataIn, dataOut)
	if results then
		-- Do something with repoChunkID here

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
			return { repoChunkID = repoChunkID, chunk = results.chunk, wasAdded = true }
		else
			if dataIn.CHUNK_REPO:isComplete() then
				repoChunkID = dataIn.CHUNK_REPO:get():add(results.chunk)
				return { repoChunkID = repoChunkID, chunk = results.chunk, wasAdded = false }
			end
		end
	end
			
	dataOut.mapChunk    = dataIn.mapChunk
	dataOut.repoChunkID = dataIn.CHUNK_REPO:getIndex()
	dataOut.repoChunk   = dataIn.CHUNK_REPO:next()
end

local compareChunks = function(results, dataIn, dataOut)
	chunkNum = chunkNum + 1
	local areChunksTheSame = (math.random(2) == 2)
	print("Comparing Map Chunk #" .. chunkNum .. " with Repo Chunk #" .. dataIn.repoChunkID .. "... SAME = ", areChunksTheSame)

	return { chunkIsUnique = areChunksTheSame, chunk = dataIn.mapChunk, repoChunkID = dataIn.repoChunkID }
end

return {
	setup = function(self, chunks)
		PIPELINE:add("Map Processor", processMapChunks)
		PIPELINE:add("Add Map Chunk to Repo", addMapChunkToRepo)
		PIPELINE:add("Compare Chunks", compareChunks)
		PIPELINE:push({ MAP_CHUNKS = FEEDER:create("Map Chunks", chunks) })
	end,

	execute = function(self)
		PIPELINE:execute(TASK_SLICE_TIME_IN_MS)
	end,

	isComplete = function(self)
		return PIPELINE:isComplete()
	end,
}
