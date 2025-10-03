--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX   = require("tools/lib/graphics"):create()

local CHUNK_IMG_DATA = love.image.newImageData("resources/zones/chunks/" .. __PARAMS["chunkImageIn"] .. ".png")
local CHUNK_IMG      = love.graphics.newImage(CHUNK_IMG_DATA)

local GRAVITY_FORCE  = 787.5

local GARBAGE_HEAP   = {
    draw = function(self)
        for _, tile in ipairs(self) do
            tile:draw()
        end
    end,

    update = function(self, dt)
        for _, tile in ipairs(self) do
            if tile.velocity == nil then tile.velocity = 0 end
            
            tile.velocity = tile.velocity + (GRAVITY_FORCE * dt)
            tile.posY     = tile.posY     + (tile.velocity * dt)
        end
    end,
}

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
                GRAFX:setColor(1, 1, 1)
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
                local tempTiles = {}

                for y = chunkY * 256, (chunkY * 256) + 240, 16 do
                    for x = chunkX * 256, (chunkX * 256) + 240, 16 do
                        n = n + 1
                        local posX = ((chunkX * 256) +   8) +           (((n - 1) % 16) * (16 * 0.94))
                        local posY = ((chunkY * 256) +   8) + (math.floor((n - 1) / 16) * (16 * 0.94))
                     
                        table.insert(tempTiles, TILE:create(CHUNK_IMG, CHUNK_IMG_DATA, x, y, posX, posY))
                    end
                end

                for i = #tempTiles, 1, -1 do
                    table.insert(self.tiles, tempTiles[i])
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
                    if not tile.garbage then
                        tile:draw()
                    end
                end
            end,

            drawChunk = function(self)
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

local chunks = ({
    tileMode = false,
    chunkImg = nil,

    init = function(self, img)
        self.chunkImg = img

        local chunkCount = self:calculateChunkCount()
        for i = 1, chunkCount do
            local chunkX = (i - 1) % 9          
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
        local width, height = self.chunkImg:getWidth(), self.chunkImg:getHeight()

        return math.floor(width / 256) * math.floor(height / 256)
    end,

    toggleTileMode = function(self)
        self.tileMode = not self.tileMode
    end,


}):init(CHUNK_IMG)

local TILE_PIPELINE = require("tools/tileinator/tilePipeline")
local okayToTileinate = false

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Tileinator")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

CHUNK_IMG:setFilter("nearest", "nearest")

TILE_PIPELINE:setup(chunks, GARBAGE_HEAP)

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    chunks:draw()
    GARBAGE_HEAP:draw()
end

function love.update(dt)
	if not TILE_PIPELINE:isComplete() and okayToTileinate then
        TILE_PIPELINE:execute()
    end
    GARBAGE_HEAP:update(dt)
end

function love.keypressed(key)
    if     key == "t"     then chunks:toggleTileMode() 
    elseif key == "space" then okayToTileinate = true end
end

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

-- ...
-- ...
-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("zooming",      { imageViewer = GRAFX, })
    :add("scrolling",    
    { 
    	imageViewer = GRAFX,
    	scrollSpeed = 2400,          
    })
	:add("readout",      
    { 
    	printFnName    = "printToReadout", 
    	accessorFnName = "getReadout",
    }) 
    :add("timedFunctions",
    {
        {   secondsWait = 1, 
            callback = function() 
                getReadout():setSustain(180) 
                printToReadout("Press 'space' to begin tileinating.") 
            end,
        },
    })    


