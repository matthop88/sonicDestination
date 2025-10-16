local SIDEBAR_GRAFX    
local CHUNK_ARTIST
local GRID_SIZE

return {
	create = function(self, chunkArtist, graphics, chunkID, gridSize)
		CHUNK_ARTIST  = chunkArtist
		SIDEBAR_GRAFX = graphics
		GRID_SIZE     = gridSize

		return ({
			highlighted = false,
			selected    = false,
			highlitTile = nil,

			init = function(self)
				self:setChunkID(chunkID)
				return self
			end,

			setChunkID     = function(self, chunkID)     
				self.chunkID = chunkID
				self:updateBounds()    
			end,

			setHighlighted = function(self, highlighted) self.highlighted = highlighted end,

			isOnScreen = function(self, y)
				if y == nil then return false end
				return y + SIDEBAR_GRAFX:getY() < 800 and y + SIDEBAR_GRAFX:getY() > - 256
			end,

			draw = function(self)
        		self:drawAt(self.y)
        		self:drawAt(self.alternateY)
    		end,

    		drawHighlitTile = function(self)
    			self:drawHighlitTileAt(self.y)
    			self:drawHighlitTileAt(self.alternateY)
    		end,

    		update = function(self, dt)
    			if not self:isOnScreen(self.y) and not self:isOnScreen(self.alternateY) then
    				self.selected = false
    			else
    				self.highlitTile = self:calculateHighlitTileAt(self.y) or self:calculateHighlitTileAt(self.alternateY)
    			end
    		end,

    		drawAt = function(self, y)
    			if y ~= nil and self:isOnScreen(y) then        
            		self:drawChunkAt(y)
            		self:drawHighlightAt(y)
            		self:drawSelectedAt(y)
        		end
    		end,

    		drawChunkAt = function(self, y)
    			SIDEBAR_GRAFX:setColor(1, 1, 1)
            	SIDEBAR_GRAFX:setFontSize(32)
            
            	if self.selected then CHUNK_ARTIST:draw(self.chunkID, 760, y, SIDEBAR_GRAFX, GRID_SIZE:get() / 100)
            	else                  CHUNK_ARTIST:draw(self.chunkID, 760, y, SIDEBAR_GRAFX, 0)                        end
            	SIDEBAR_GRAFX:printf("" .. self.chunkID, 710, y + 112, 50, "center")
            end,

			drawHighlightAt = function(self, y)
				if self.highlighted then
					SIDEBAR_GRAFX:setColor(1, 1, 0)
					SIDEBAR_GRAFX:setLineWidth(3)
					SIDEBAR_GRAFX:rectangle("line", 759, y - 1, 258, 258)
				end
			end,

			drawSelectedAt = function(self, y)
				if self.selected then
					SIDEBAR_GRAFX:setColor(1, 1, 1, 0.5)
            		SIDEBAR_GRAFX:rectangle("fill", 756, y - 4, 264, 264)
            		SIDEBAR_GRAFX:setColor(1, 1, 1)
            		SIDEBAR_GRAFX:setLineWidth(3)
            		SIDEBAR_GRAFX:rectangle("line", 759, y - 1, 258, 258)
        		end
    		end,

    		drawHighlitTileAt = function(self, y)
    			if y ~= nil and self.selected and self.highlitTile ~= nil then
            		SIDEBAR_GRAFX:setColor(1, 1, 0)
            		SIDEBAR_GRAFX:setLineWidth(3)
            		SIDEBAR_GRAFX:rectangle("line", (self.highlitTile.x * 16) + 751, (self.highlitTile.y * 16) + y - 9, 34, 34)
        
            		CHUNK_ARTIST:drawTile(chunkID, self.highlitTile.x, self.highlitTile.y, 752, y - 8, 2, SIDEBAR_GRAFX, { 1, 1, 1, 0.8 })
            	end
        	end,

    		calculateHighlitTileAt = function(self, y)
    			if y ~= nil and self.selected then
		            local sY     = y + SIDEBAR_GRAFX:getY()
		            local mx, my = love.mouse.getPosition()
		            if mx >= 760 and mx <= 1012 and my >= sY and my <= sY + 256 then
		                local tileX = math.floor((mx - 760) / 16)
		                local tileY = math.floor((my - sY)  / 16)
		                return { x = tileX, y = tileY }
		            end
		        end
		    end,

			updateBounds = function(self)
				self.y = ((self.chunkID - 1) * 264) + 272
			end,

		}):init()
	end,
}
