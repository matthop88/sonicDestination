local TILES_BUILDER = {
	tiles = {
		offset = require("tools/lib/tweenableValue"):create(0, { speed = 4 }),
		img = nil,

		get = function(self, tileID)
    		return self[tileID]
    	end,

    	draw = function(self, x, y, tileID, graphics)
			graphics:setColor(1, 1, 1)
    		graphics:draw(self.img, self:get(tileID), x + (self.offset:get() * 0.01), y + (self.offset:get() * 0.01), 0, 1 - (self.offset:get() * 0.00125), 1 - (self.offset:get() * 0.00125))
		end,

		toggleMode = function(self)
			if self.offset:get() == 0 then self.offset:setDestination(200)
			else                           self.offset:setDestination(0)   end
		end,

		update = function(self, dt) 
			self.offset:update(dt)
		end,
    },

    init = function(self, tilesImg)
    	if not self.tilesImg then
	    	self.tilesImg  = tilesImg
	    	self.tiles.img = tilesImg

	        local tileCount = self:calculateTileCount()
	        self:constructTiles(tileCount)
	    end

        return self.tiles
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
			table.insert(self.tiles, quad)
			
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
}

return {
	create = function(self, tilesImgPath)
		local tilesImg = love.graphics.newImage(tilesImgPath)
		tilesImg:setFilter("nearest", "nearest")

		return TILES_BUILDER:init(tilesImg)
	end,
}
