local CHUNKS_IMG_NAME = 1
local CHUNK_ID        = 2

local CHUNK = require("tools/constructionSet/templates/chunk")

return {
	readMapIntoChunksList = function(self, map, chunksList)
		local chunkFactory = require("game/world/terrain/chunkFactory")

		local CHUNK_DATA_NAME = map.chunksDataName

		for _, row in ipairs(map) do
			local y = row.row
			for x, element in ipairs(row.data) do
				local CHUNKS = require("tools/lib/dataStructures/lazyVal"):create()
	        	local SOLIDS = require("tools/lib/dataStructures/lazyVal"):create()
				
				if type(element) == "table" then
					if element[CHUNKS_IMG_NAME] and element[CHUNK_ID] then
						CHUNKS:set(chunkFactory:getChunks(element[CHUNKS_IMG_NAME]))
						SOLIDS:set(chunkFactory:getSolids(element[CHUNKS_IMG_NAME]))

						local chunk = CHUNK:create(element[CHUNK_ID], CHUNKS, SOLIDS)
						if element.xFlip then chunk:flipX() end
						chunksList:add(chunk, x - 1, y - 1)
					end
				else
					CHUNKS:set(chunkFactory:getChunks(CHUNK_DATA_NAME))
					SOLIDS:set(chunkFactory:getSolids(CHUNK_DATA_NAME))

					local chunk = CHUNK:create(element, CHUNKS, SOLIDS)
					chunksList:add(chunk, x - 1, y - 1)
				end
			end
		end
	end,

	readObjectsIntoObjectsList = function(self, objects, objectsList)
		local objectFactory = require("tools/constructionSet/objectFactory")

		for _, object in ipairs(objects) do
			local newObject = objectFactory:createObject(object.obj, object.xFlip)
			objectsList:add(newObject, object.x, object.y)
		end
	end,
}
