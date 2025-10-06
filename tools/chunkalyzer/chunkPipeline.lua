local PIPELINE   = require("tools/lib/pipeline/pipeline"):create("Chunk Pipeline")
local FEEDER     = require("tools/lib/pipeline/feeder")
local PIXEL_UTIL = require("tools/lib/pixelUtil")

local TASK_SLICE_TIME_IN_MS = 12

local TALLY_SOUND = require("tools/chunkalyzer/sounds/tally")

local chunkNum = 0
local IMAGE_DATA, CHUNK_VIEW, CHUNK_REPO

local comparePixelsInChunkRow = function(c1X, c1Y, c2X, c2Y)
    local x1, y1, x2, y2 = c1X, c1Y, c2X, c2Y

    for i = 0, 255 do
        if not PIXEL_UTIL:pixelsMatch(IMAGE_DATA, x1, y1, IMAGE_DATA, x2, y2) then
            return false
        end
        x1 = x1 + 1
        x2 = x2 + 1
    end

    return true
end

local sliceChunkIntoRows = function(chunk)
	local rows = {}

	for y = chunk.y + 255, chunk.y, -1 do
		table.insert(rows, { x = chunk.x, y = y} )
	end

	return rows
end

local onChunkalyzationComplete = function()
	print("Chunkalyzation complete in " .. PIPELINE:getTotalElapsedTime() .. " seconds.")
	printToReadout("Press 'return' to save to file.")
	TALLY_SOUND:play()
	CHUNK_VIEW:setRepoMode()
end

local processMapChunks = function(params, nextParams)
	if params.MAP_CHUNKS:isComplete() then
		onChunkalyzationComplete()
		return { completed = true }
	end

	nextParams:init {
		mapChunk   = params.MAP_CHUNKS:next(),
		CHUNK_REPO = FEEDER:create("Chunk Repo", CHUNK_REPO)
	}

end

local addMapChunkToRepo = function(params, nextParams)
	if     params.mapChunk.isDuplicate == true then
		CHUNK_VIEW:tagChunk(params.mapChunk)
		return { completed = true }
	elseif params.CHUNK_REPO:isComplete() then
		params.mapChunk.isDuplicate = false
		params.mapChunk.repoChunkID = CHUNK_REPO:add(params.mapChunk)
		CHUNK_VIEW:tagChunk(params.mapChunk)
		return { completed = true }
	end

	nextParams:init {
		repoChunkID = params.CHUNK_REPO:getIndex(),
		repoChunk   = params.CHUNK_REPO:next()
	}

end

local compareChunks = function(params, nextParams)
	if params.mapChunk.isDuplicate ~= nil then
		params.mapChunk.repoChunkID = params.repoChunkID
		return { completed = true }
	end		
		
	nextParams:init {
		repoChunkRows = FEEDER:create("Repo Chunk Row", sliceChunkIntoRows(params.repoChunk)),
		mapChunkRows  = FEEDER:create("Map Chunk Row",  sliceChunkIntoRows(params.mapChunk)),
	}

end

local compareChunkRows = function(params, nextParams)
	if params.mapChunkRow and params.mapChunkRow.isEqual == false then
		params.mapChunk.isDuplicate = false
		return { completed = true }
	elseif params.mapChunkRows:isComplete() then
		params.mapChunk.isDuplicate = true
		return { completed = true }
	end
	
	nextParams:init {
		mapChunkRow  = params.mapChunkRows:next(),
		repoChunkRow = params.repoChunkRows:next() 
	}
	
end

local compareChunkRow = function(params, nextParams)
	local rowsAreEqual = comparePixelsInChunkRow(params.mapChunkRow.x, params.mapChunkRow.y, params.repoChunkRow.x, params.repoChunkRow.y)
	params.mapChunkRow.isEqual = rowsAreEqual

	return { completed = true }
end

return {
	setup = function(self, chunks, imageData, chunkalyzerView, chunkRepo)
		IMAGE_DATA = imageData
		CHUNK_VIEW = chunkalyzerView
		CHUNK_REPO = chunkRepo
		
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
