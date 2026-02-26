local CHUNKS_IMG_NAME = 1
local CHUNK_ID        = 2

local CHUNK = require("tools/constructionSet/templates/chunk")

return {
	readMapIntoChunksList = function(self, map, chunksList)
		local chunkFactory = require("tools/constructionSet/chunkFactory")

		for _, row in ipairs(map) do
			local y = row.row
			for x, element in ipairs(row.data) do
				if element[CHUNKS_IMG_NAME] and element[CHUNK_ID] then
					local CHUNKS = require("tools/lib/dataStructures/lazyVal"):create()
        			local SOLIDS = require("tools/lib/dataStructures/lazyVal"):create()
					
					CHUNKS:set(chunkFactory:getChunks(element[CHUNKS_IMG_NAME]))
					SOLIDS:set(chunkFactory:getSolids(element[CHUNKS_IMG_NAME]))

					local chunk = CHUNK:create(element[CHUNK_ID], CHUNKS, SOLIDS)
					if element.xFlip then chunk:flipX() end
					chunksList:add(chunk, x - 1, y - 1)
				end
			end
		end
	end,
}
