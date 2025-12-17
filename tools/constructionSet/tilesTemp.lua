return {
	create = function(self, chunksPath)
		local chunksData = dofile(chunksPath)
		local tilesPath  = "game/resources/zones/tiles/" .. chunksData.tilesImageName .. ".png"
		local tilesImage  = love.graphics.newImage(tilesPath)

		tilesImage:setFilter("nearest", "nearest")

		return {
			image = tilesImage,
		}
	end,

}
