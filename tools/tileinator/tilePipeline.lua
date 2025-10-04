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

local processChunks = function(results, dataIn, dataOut)
	if dataIn.ALL_CHUNKS:isComplete() then
		print("Tileination complete in " .. PIPELINE:getTotalElapsedTime() .. " seconds.")
		print("Number of tiles in repo: " .. #TILE_REPO)
		return { completed = true }
	end
				
	dataOut.chunkID = dataIn.ALL_CHUNKS:getIndex()
	dataOut.chunk   = dataIn.ALL_CHUNKS:next()
	
end

--[[
local processChunks = function(params, nextParams)
	if params.ALL_CHUNKS:isComplete() then
		print("Tileination complete in " .. PIPELINE:getTotalElapsedTime() .. " seconds.")
		print("Number of tiles in repo: " .. #TILE_REPO)
		return true
	end
	nextParams.chunk = params.ALL_CHUNKS:next()
--]]

local processChunk = function(results, dataIn, dataOut)
	if results then
		return { completed = true }
	end

	dataOut.CHUNK_TILES = FEEDER:create("Chunk Tiles", dataIn.chunk.tiles)
end

--[[
local processChunk = function(params, nextParams)
	nextParams.CHUNK_TILES = FEEDER:create("Chunk Tiles", params.chunk.tiles)
	return true
--]]

local processTiles = function(results, dataIn, dataOut)
	if dataIn.CHUNK_TILES:isComplete() then
		return { completed = true }
	end

	dataOut.tileID = dataIn.CHUNK_TILES:getIndex()
	dataOut.tile   = dataIn.CHUNK_TILES:next()
	dataOut.TILE_REPO = FEEDER:create("Tile Repo", TILE_REPO)
end

--[[
local processTiles = function(params, nextParams)
	if params.CHUNK_TILES:isComplete() then
		return true
	end
	nextParams.chunkTile = params.CHUNK_TILES:next()
	nextParams.TILE_REPO = FEEDER:create("Tile Repo", TILE_REPO)
--]]

local addTileToRepo = function(results, dataIn, dataOut)
	if results then
		if not results.tilesAreEqual then
			if dataIn.TILE_REPO:isComplete() then
				table.insert(TILE_REPO, dataIn.tile)
				dataIn.tile.tileID = #TILE_REPO
				return { wasAdded = true }
			end
		else
			dataIn.tile.garbage = true
			table.insert(GARBAGE_HEAP, dataIn.tile)
			return { wasAdded = false }
		end
	end		
	
	dataOut.tile       = dataIn.tile
	dataOut.repoTileID = dataIn.TILE_REPO:getIndex()
	dataOut.repoTile   = dataIn.TILE_REPO:next()
end

--[[
local addTileToRepo = function(params, nextParams)
	if params.chunkTile.isDuplicate then
		table.insert(GARBAGE_HEAP, params.chunkTile)
		return true
	elseif params.TILE_REPO:isComplete() then
		table.insert(TILE_REPO, params.chunkTile)
		params.chunkTile.tileID = #TILE_REPO
		return true
	end

	nextParams.repoTile = params.TILE_REPO:next()
end

--]]

local compareTiles = function(results, dataIn, dataOut)
	if dataIn.repoTile ~= nil then
		local tilesAreEqual = comparePixelsOfTiles(dataIn.tile, dataIn.repoTile)
		return { tilesAreEqual = tilesAreEqual }
	end

	return { tilesAreEqual = false }
end

--[[
local compareTiles = function(params, nextParams)
	if comparePixelsOfTiles(params.chunkTile, params.repoTile) then
		params.chunkTile.isDuplicate = true
	end

	return true
end
--]]

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
