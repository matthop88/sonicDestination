local CHUNK_ARTIST

local MOUSE_GRAFX = require("tools/lib/graphics"):create()

return {
	tileBeingHeld = nil,
	chunkID       = nil,
	transparency  = 0.9,

	init = function(self, chunkArtist)
		CHUNK_ARTIST = chunkArtist
		return self
	end,
	
	holdTile = function(self, chunkID, tile)
		self.chunkID       = chunkID
		self.tileBeingHeld = tile
	end,

	releaseTile = function(self)
		self.chunkID       = nil
		self.tileBeingHeld = nil
	end,

	isHoldingTile = function(self)
		return self.tileBeingHeld ~= nil
	end,

	getTileID = function(self)
		if self.tileBeingHeld then
			return CHUNK_ARTIST:getTileID(self.chunkID, self.tileBeingHeld.x, self.tileBeingHeld.y)
		end
	end,

	setTransparency = function(self, transparency)
		self.transparency = transparency
	end,

	getTransparency = function(self)
		return self.transparency
	end,

	draw = function(self)
		local mX, mY = love.mouse.getPosition()

		if self.tileBeingHeld ~= nil then
			local tileID = self:getTileID()
			CHUNK_ARTIST:drawTileAt(tileID, mX - 32, mY - 32, MOUSE_GRAFX, 4, { 1, 1, 1, self.transparency })
			MOUSE_GRAFX:setColor(1, 1, 1)
			MOUSE_GRAFX:setLineWidth(3)
			MOUSE_GRAFX:rectangle("line", mX - 33, mY - 33, 66, 66)
        end
	end,

	setVisible = function(self, visibility)
		love.mouse.setVisible(visibility or (self.tileBeingHeld ~= nil))
	end,
}
