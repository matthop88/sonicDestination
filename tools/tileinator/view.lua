local CHUNK_IMG_DATA = love.image.newImageData("resources/zones/chunks/" .. __PARAMS["chunkImageIn"] .. ".png")
local CHUNK_IMG      = love.graphics.newImage(CHUNK_IMG_DATA)

local GRAVITY_FORCE  = 787.5

CHUNK_IMG:setFilter("nearest", "nearest")

local GRAFX   = require("tools/lib/graphics"):create()

local tileinationDone = false

local TILE = {
    create = function(self, img, imgData, x, y, posX, posY)
        return {
            IMG_DATA = imgData,
            IMG      = img,

            x        = x,
            y        = y,

            posX     = posX,
            posY     = posY,

            quad     = love.graphics.newQuad(x, y, 16, 16, imgData:getWidth(), imgData:getHeight()),
        
            draw     = function(self)
                GRAFX:setColor(1, 1, 1, self.alpha or 1)
                GRAFX:draw(self.IMG, self.quad, self.posX + 1, self.posY + 1, 0, 0.875, 0.875)
            end,
        }
    end,
}

local CHUNK = {
    create = function(self, img, chunkX, chunkY)
        return ({
            chunkImg = img,
            
            quad = love.graphics.newQuad(chunkX * 256, chunkY * 256, 256, 256, img:getWidth(), img:getHeight()),

            tiles = { },

            init = function(self)
                local n = 0
                for y = chunkY * 256, (chunkY * 256) + 240, 16 do
                    for x = chunkX * 256, (chunkX * 256) + 240, 16 do
                        n = n + 1
                        local posX = ((chunkX * 256) +   8) +           (((n - 1) % 16) * (16 * 0.94))
                        local posY = ((chunkY * 256) +   8) + (math.floor((n - 1) / 16) * (16 * 0.94))
                     
                        table.insert(self.tiles, TILE:create(CHUNK_IMG, CHUNK_IMG_DATA, x, y, posX, posY))
                    end
                end

                return self
            end,

            draw = function(self, tileMode)
                if self:isOnScreen() then
                    if tileMode then self:drawTiles()
                    else             self:drawChunk() end
                end
            end,

            drawTiles = function(self)
                for n, tile in ipairs(self.tiles) do
                    if not tile.garbage and not tile.tileID then
                        tile:draw()
                    end
                end
            end,

            drawChunk = function(self)
                GRAFX:setColor(1, 1, 1)
                GRAFX:draw(self.chunkImg, self.quad, (chunkX * 256) + 8, (chunkY * 256) + 8, 0, 0.94, 0.94)
            end,

            isOnScreen = function(self, cX, cY)
                local leftX, topY     = GRAFX:screenToImageCoordinates(0, 0)
                local rightX, bottomY = GRAFX:screenToImageCoordinates(love.graphics:getWidth(), love.graphics:getHeight())

                return chunkX * 256 < rightX and (chunkX * 256) + 256 > leftX and chunkY * 256 < bottomY and (chunkY * 256) + 256 > topY
            end,

        }):init()
    end,
}

return {
	TILE_REPO      = {
	    draw = function(self)
	        for _, tile in ipairs(self) do
	            tile:draw()
	        end
	    end,

	    update = function(self, dt)
	        for n, tile in ipairs(self) do
	            if tile.targetX == nil then
	                tile.delay = math.random(25) + 50
	                local chunkID = math.floor((tile.tileID - 1) / 256)
	                local x = (tile.tileID - 1) % 16
	                local y = math.floor(((tile.tileID - 1) % 256) / 16)

	                tile.origX   = tile.posX
	                tile.origY   = tile.posY

	                tile.targetX = (chunkID * 350) + (x * 20) + 8
	                tile.targetY = (y * 20) + 8
	            end

	            tile.delay = math.max(0, tile.delay - 1)
	            if tile.delay == 0 then
	                if not tile.reachedX then
	                    tile.posX = tile.posX + (tile.targetX - tile.origX) * dt
	                    if math.abs(tile.origX - tile.posX) > math.abs(tile.origX - tile.targetX) then
	                        tile.posX = tile.targetX
	                        tile.reachedX = true
	                    end
	                end
	                if not tile.reachedY then
	                    tile.posY = tile.posY + (tile.targetY - tile.origY) * dt
	                    if math.abs(tile.origY - tile.posY) > math.abs(tile.origY - tile.targetY) then
	                        tile.posY = tile.targetY
	                        tile.reachedY = true
	                    end
	                end
	            end

	            if n == #self and tile.reachedX and tile.reachedY and tileinationDone == false then
	                tileinationDone = true
	                printToReadout("Press 'return' to save the tiles to disk.")
	            end
	        end
	    end,

	    getWidth  = function(self) return ((math.floor((#self - 1) / 256) + 1) * 350 ) + 8  end,
	    getHeight = function(self) return 272 end,
	},

	GARBAGE_HEAP   = {
	    draw = function(self)
	        for _, tile in ipairs(self) do
	            tile:draw()
	        end
	    end,

	    update = function(self, dt)
	        for _, tile in ipairs(self) do
	            if tile.velocity == nil then 
	                tile.delay = math.random(50)
	                tile.velocity = 0
	                tile.alpha = 1
	            end
	            
	            tile.delay = math.max(0, tile.delay - 1)
	            if tile.delay == 0 then
	                tile.velocity = tile.velocity + (GRAVITY_FORCE * dt)
	                tile.posY     = tile.posY     + (tile.velocity * dt)
	                tile.alpha    = tile.alpha - (0.333 * dt)
	            end
	        end
	    end,
	},

	CHUNKS = ({
	    tileMode = false,
	    chunkImg = nil,

	    init = function(self, img)
	        self.chunkImg = img

	        local chunkCount = self:calculateChunkCount()

	        for i = 1, chunkCount do
	            local chunkX = ((i - 1) % 9)         
	            local chunkY = math.floor((i - 1) / 9)
	            
	            table.insert(self, CHUNK:create(self.chunkImg, chunkX, chunkY))
	        end

	        return self
	    end,

	    draw = function(self)
	        for i, chunk in ipairs(self) do
	            GRAFX:setColor(1, 1, 1)
	            chunk:draw(self.tileMode)
	        end
	    end,

	    calculateChunkCount = function(self)
	        local width, height = self:getWidth(), self:getHeight()

	        return math.floor(width / 256) * math.floor(height / 256)
	    end,

	    getWidth       = function(self) return self.chunkImg:getWidth()   end,
	    getHeight      = function(self) return self.chunkImg:getHeight()  end,

	    toggleTileMode = function(self) self.tileMode = not self.tileMode end,

	}):init(CHUNK_IMG),

	setTileMode = function(self, tileMode)
		self.CHUNKS.tileMode = tileMode
	end,

	draw = function(self)
	    self.CHUNKS:draw()
	    if self.CHUNKS.tileMode then
	    	self.TILE_REPO:draw()
	    	self.GARBAGE_HEAP:draw()
	    end
	end,

	update = function(self, dt)
		self.GARBAGE_HEAP:update(dt)
    	self.TILE_REPO:update(dt)
	end,

	handleKeypressed = function(self, key)
	    if     key == "t"     then self.CHUNKS:toggleTileMode() end
	end,

	getPageWidth = function(self)
		if   self.CHUNKS.tileMode then return self.TILE_REPO:getWidth()
		else                           return self.CHUNKS:getWidth()    end
	end,

	getPageHeight = function(self)
		if   self.CHUNKS.tileMode then return self.TILE_REPO:getHeight() 
		else                           return self.CHUNKS:getHeight()   end
	end,

	keepImageInBounds = function(self)
        GRAFX:setX(math.min(0, math.max(GRAFX:getX(), (love.graphics:getWidth()  / GRAFX:getScale()) - self:getPageWidth())))
        GRAFX:setY(math.min(0, math.max(GRAFX:getY(), (love.graphics:getHeight() / GRAFX:getScale()) - self:getPageHeight())))
    end,

    moveImage = function(self, deltaX, deltaY)
	    if self.CHUNKS.tileMode then
	    	GRAFX:moveImage(deltaX / 2, deltaY / 2)
	    else
	    	GRAFX:moveImage(deltaX, deltaY)
	    end
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return GRAFX:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
    	if (deltaScale < 0 and GRAFX:getScale() >= 0.5) or (deltaScale > 0 and GRAFX:getScale() <= 5.0) then
			GRAFX:adjustScaleGeometrically(deltaScale)
		end
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        GRAFX:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,
}
