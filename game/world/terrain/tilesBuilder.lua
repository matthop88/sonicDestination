local TILES = {
    init = function(self, tilesImg)
    	if not self.tilesImg then
	    	self.tilesImg = tilesImg

	        local tileCount = self:calculateTileCount()
	        self:constructTiles(tileCount)
	    end

        return self
    end,

    calculateTileCount = function(self)
        local widthInTiles  = self.tilesImg:getWidth()  / 16
		local heightInTiles = self.tilesImg:getHeight() / 16

		return widthInTiles * heightInTiles
    end,

    constructTiles = function(self, tileCount)
    	local x, y, baseX = 0, 0, 0

		for i = 1, tileCount do
			local quad = love.graphics.newQuad(x, y, 16, 16, self.tilesImg:getWidth(), self.tilesImg:getHeight())
			table.insert(self, quad)
			
			x, y, baseX = self:moveTileCursor(x, y, baseX)
		end
	end,

	moveTileCursor = function(self, x, y, baseX)
		x = x + 16
		if x >= baseX + 256 then
			x, y = baseX, y + 16
			if y >= 256 then baseX, x, y = baseX + 256, baseX + 256, 0 end
		end
		return x, y, baseX
	end,

    get = function(self, tileID)
    	return self[tileID]
    end,

    draw = function(self, x, y, tileID)
    	love.graphics.setColor(1, 1, 1)
    	love.graphics.draw(self.tilesImg, self:get(tileID), x, y, 0, 1, 1)
	end,

}

return {
	create = function(self, tilesImgPath)
		local tilesImg = love.graphics.newImage(tilesImgPath)
		tilesImg:setFilter("nearest", "nearest")

		return TILES:init(tilesImg)
	end,
}
