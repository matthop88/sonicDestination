--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX   = require("tools/lib/graphics"):create()

local chunkImgPath

if __CHUNK_FILE ~= nil then
    chunkImgPath = "resources/zones/chunks/" .. __CHUNK_FILE .. ".png"
end


local chunkImgData = love.image.newImageData(chunkImgPath)
local chunkImg     = love.graphics.newImage(chunkImgData)


local mapData
if __MAP_FILE ~= nil then
    mapData = require("resources/zones/maps/" .. __MAP_FILE)
end

local chunks = ({
    init = function(self)
        local chunkCount = self:calculateChunkCount()
        for i = 1, chunkCount do
            local chunkX = ((i - 1) % 9)           * 256
            local chunkY = math.floor((i - 1) / 9) * 256
            
            table.insert(self, love.graphics.newQuad(chunkX, chunkY, 256, 256, chunkImg:getWidth(), chunkImg:getHeight()))
        end

        return self
    end,

    calculateChunkCount = function(self)
        local width, height = chunkImg:getWidth(), chunkImg:getHeight()

        return math.floor(width / 256) * math.floor(height / 256)
    end,

    draw = function(self, chunkID, x, y)
        GRAFX:draw(chunkImg, self[chunkID], x, y, 0, 1, 1)
    end,

}):init()

local map = ({
    init = function(self)
        self.pageWidth  = #mapData[1] * 256
        self.pageHeight = #mapData    * 256

        return self
    end,

    draw = function(self)
        GRAFX:setColor(1, 1, 1)
        for rowNum, row in ipairs(mapData) do
            local y = (rowNum - 1) * 256
            for colNum, chunkID in ipairs(row) do
                local x = (colNum - 1) * 256
                chunks:draw(chunkID, x, y)
            end
        end
    end,

    getPageWidth  = function(self) return self.pageWidth  end,

    getPageHeight = function(self) return self.pageHeight end,
    
    keepImageInBounds = function(self)
        GRAFX:setX(math.min(0, math.max(GRAFX:getX(), (love.graphics:getWidth()  / GRAFX:getScale()) - self:getPageWidth())))
        GRAFX:setY(math.min(0, math.max(GRAFX:getY(), (love.graphics:getHeight() / GRAFX:getScale()) - self:getPageHeight())))
    end,

    moveImage = function(self, deltaX, deltaY)
        GRAFX:moveImage(deltaX, deltaY)
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return GRAFX:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        GRAFX:adjustScaleGeometrically(deltaScale)
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        GRAFX:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,
}):init()

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Map Viewer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

chunkImg:setFilter("nearest", "nearest")

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    map:draw()
end

function love.update(dt)
	-- Updating happens here
end

-- ...

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
    :add("zooming",      { imageViewer = map,            })
    :add("scrolling",    
    { 
    	imageViewer = map,
    	scrollSpeed = 2400,          
    })
	:add("readout",      
    { 
    	printFnName    = "printToReadout", 
    	accessorFnName = "getReadout",
    })    


