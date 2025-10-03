--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX   = require("tools/lib/graphics"):create()

local chunkImg = love.graphics.newImage("resources/zones/chunks/" .. __PARAMS["chunkImageIn"] .. ".png")

local CHUNK = {
    create = function(self, chunkX, chunkY)
        return ({
            quad = love.graphics.newQuad(chunkX * 256, chunkY * 256, 256, 256, chunkImg:getWidth(), chunkImg:getHeight()),

            tiles = { },

            init = function(self)
                for y = chunkY * 256, (chunkY * 256) + 240, 16 do
                    for x = chunkX * 256, (chunkX * 256) + 240, 16 do
                        table.insert(self.tiles, love.graphics.newQuad(x, y, 16, 16, chunkImg:getWidth(), chunkImg:getHeight()))
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
                    local x = ((chunkX * 256) +   8) +           (((n - 1) % 16) * (16 * 0.94))
                    local y = ((chunkY * 256) +   8) + (math.floor((n - 1) / 16) * (16 * 0.94))
                    
                    GRAFX:draw(chunkImg, tile, x + 1, y + 1, 0, 0.875, 0.875)
                end
            end,

            drawChunk = function(self)
                GRAFX:draw(chunkImg, self.quad, (chunkX * 256) + 8, (chunkY * 256) + 8, 0, 0.94, 0.94)
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

    init = function(self)
        local chunkCount = self:calculateChunkCount()
        for i = 1, chunkCount do
            local chunkX = (i - 1) % 9          
            local chunkY = math.floor((i - 1) / 9)
            
            table.insert(self, CHUNK:create(chunkX, chunkY))
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
        local width, height = chunkImg:getWidth(), chunkImg:getHeight()

        return math.floor(width / 256) * math.floor(height / 256)
    end,

    toggleTileMode = function(self)
        self.tileMode = not self.tileMode
    end,


}):init()

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Tileinator")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

chunkImg:setFilter("nearest", "nearest")

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    chunks:draw()
end

function love.update(dt)
	-- Updating happens here
end

function love.keypressed(key)
    if key == "t" then chunks:toggleTileMode() end
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


