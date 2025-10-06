local PIPELINE   = require("tools/lib/pipeline/pipeline"):create("Tile Pipeline")
local FEEDER     = require("tools/lib/pipeline/feeder")

local PIXEL_UTIL = require("tools/lib/pixelUtil")

local TASK_SLICE_TIME_IN_MS = 12

local CHUNKS, TILE_REPO, GARBAGE_HEAP

local comparePixelsOfTiles = function(tile1, tile2)
    local x1, y1, x2, y2 = tile1.x, tile1.y, tile2.x, tile2.y

    for i = 0, 15 do
    	for j = 0, 15 do
    		if not PIXEL_UTIL:pixelsMatch(tile1.IMG_DATA, x1 + j, y1 + i, tile2.IMG_DATA, x2 + j, y2 + i) then
        		return false
        	end
        end
    end

    return true
end

local processChunks = function(params, nextParams)
	if params.ALL_CHUNKS:isComplete() then
		print("Tileination complete in " .. PIPELINE:getTotalElapsedTime() .. " seconds.")
		print("Number of tiles in repo: " .. #TILE_REPO)
		return true
	end
				
	nextParams:init {
		chunk = params.ALL_CHUNKS:next(),
	}
	
end

local processChunk = function(params, nextParams)
	
	nextParams:init {
		CHUNK_TILES = FEEDER:create("Chunk Tiles", params.chunk.tiles),
	}

	return true
end

local processTiles = function(params, nextParams)
	if params.CHUNK_TILES:isComplete() then
		return true
	end

	nextParams:init {
		tile      = params.CHUNK_TILES:next(),
		TILE_REPO = FEEDER:create("Tile Repo", TILE_REPO),
	}

end

local addTileToRepo = function(params, nextParams)
	if params.tile.garbage then
		table.insert(GARBAGE_HEAP, params.tile)
		return true
	elseif params.TILE_REPO:isComplete() then
		table.insert(TILE_REPO, params.tile)
		params.tile.tileID = #TILE_REPO
		return true
	end		
	
	nextParams:init {
		repoTile = params.TILE_REPO:next(),
	}

end

local compareTiles = function(params, nextParams)
	local tilesAreEqual = comparePixelsOfTiles(params.tile, params.repoTile)
	if tilesAreEqual then params.tile.garbage = true end

	return true
end

return {
	setup = function(self, chunks, tileRepo, garbageHeap)
		CHUNKS       = chunks
		TILE_REPO    = tileRepo
		GARBAGE_HEAP = garbageHeap
		
		PIPELINE:add("Chunks Processor",      processChunks)
		PIPELINE:add("Process Chunk",         processChunk)
		PIPELINE:add("Process Tiles",         processTiles)
		PIPELINE:add("Add Tile to Repo",      addTileToRepo)
		PIPELINE:add("Compare Tiles",         compareTiles)
		PIPELINE:push({ ALL_CHUNKS = FEEDER:create("All Chunks", CHUNKS) })
	end,

	execute = function(self)
		PIPELINE:execute(TASK_SLICE_TIME_IN_MS)
	end,

	isComplete = function(self)
		return PIPELINE:isComplete()
	end,
}
