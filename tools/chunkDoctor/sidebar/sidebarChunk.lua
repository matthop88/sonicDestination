local SIDEBAR_GRAFX    
local CHUNK_ARTIST
local GRID_SIZE

local STICKY_MOUSE

return {
	init = function(self, chunkArtist, graphics, gridSize, stickyMouse)
		CHUNK_ARTIST  = chunkArtist
		SIDEBAR_GRAFX = graphics
		GRID_SIZE     = gridSize
		STICKY_MOUSE  = stickyMouse
		return self
	end,

	create = function(self, chunkID)
		return ({
			highlighted  = false,
			selected     = false,
			highlitTile  = nil,
			selectedTile = nil,

			init = function(self)
				self:setChunkID(chunkID)
				return self
			end,

			setChunkID     = function(self, chunkID)     
				self.chunkID = chunkID
				self:updateBounds()    
			end,

			select         = function(self, selected)
				if self.selected and not selected then
					STICKY_MOUSE:releaseTile()
				end
				self.selected = selected
				if not self.selected then self.selectedTile = nil end
			end,

			setHighlighted = function(self, highlighted) self.highlighted = highlighted end,

			isHighlightedTileSelected = function(self)
				return self.highlitTile  ~= nil 
				   and self.selectedTile ~= nil
				   and self.highlitTile.x == self.selectedTile.x
				   and self.highlitTile.y == self.selectedTile.y
			end,

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

    		drawHighlitTileAt = function(self, y)
    			if y ~= nil and self.selected and self.highlitTile ~= nil then
            		SIDEBAR_GRAFX:setColor(1, 1, 0)
            		SIDEBAR_GRAFX:setLineWidth(3)
            		SIDEBAR_GRAFX:rectangle("line", (self.highlitTile.x * 16) + 751, (self.highlitTile.y * 16) + y - 9, 34, 34)
        
            		CHUNK_ARTIST:drawTile(chunkID, self.highlitTile.x, self.highlitTile.y, 752, y - 8, 2, SIDEBAR_GRAFX, { 1, 1, 1, 0.8 })
            	end
        	end,

    		drawSelectedTile = function(self)
    			self:drawSelectedTileAt(self.y)
    			self:drawSelectedTileAt(self.alternateY)
    		end,

    		update = function(self, dt)
    			if not self:isOnScreen(self.y) and not self:isOnScreen(self.alternateY) then
    				self:select(false)
    			else
    				self.highlitTile = self:calculateHighlitTileAt(self.y) or self:calculateHighlitTileAt(self.alternateY)
    			end
    			if not STICKY_MOUSE:isHoldingTile() and self.selectedTile then
    				self:select(false)
    			end
    		end,

    		drawAt = function(self, y)
    			if y ~= nil and self:isOnScreen(y) then        
            		self:drawChunkAt(y)
            		self:drawHighlightAt(y)
            		self:drawSelectedAt(y)
            		self:drawSelectedTileAt(y)
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

		    drawSelectedTileAt = function(self, y)
		    	if y ~= nil and self.selectedTile then
		    		SIDEBAR_GRAFX:setColor(0, 0, 0, 0.5)
            		SIDEBAR_GRAFX:rectangle("fill", (self.selectedTile.x * 16) + 760, (self.selectedTile.y * 16) + y, 16, 16)
        		end
        	end,

			updateBounds = function(self)
				self.y = ((self.chunkID - 1) * 264) + 272
			end,

			walkSelectedTile = function(self, deltaX, deltaY)
				if self.selectedTile ~= nil then
					self.selectedTile.x = self.selectedTile.x + deltaX
					if     self.selectedTile.x > 15 then self.selectedTile.x = 0
					elseif self.selectedTile.x < 0  then self.selectedTile.x = 15 end

					self.selectedTile.y = self.selectedTile.y + deltaY
					if     self.selectedTile.y > 15 then self.selectedTile.y = 0
					elseif self.selectedTile.y < 0  then self.selectedTile.y = 15 end

					STICKY_MOUSE:holdTile(self.chunkID, self.selectedTile)
				end
			end,

			handleMousepressed = function(self, mx, my)
				self.selected = true
				if self.highlitTile ~= nil then
					self.selectedTile = self.highlitTile
					STICKY_MOUSE:holdTile(self.chunkID, self.selectedTile)
				else
					STICKY_MOUSE:releaseTile()
				end
			end,

		}):init()
	end,
}
