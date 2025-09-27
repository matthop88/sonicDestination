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
        local width, height = chunkImg:getWidth(), chunkImg:getHeight()

        local chunkCount = math.floor(width / 256) * math.floor(height / 256)

        for i = 1, chunkCount do
            local chunkX = ((i - 1) % 9)           * 256
            local chunkY = math.floor((i - 1) / 9) * 256
            
            table.insert(self, love.graphics.newQuad(chunkX, chunkY, 256, 256, chunkImg:getWidth(), chunkImg:getHeight()))
        end

        return self
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
    GRAFX:setColor(1, 1, 1)
    for rowNum, row in ipairs(mapData) do
        local y = (rowNum - 1) * 256
        for colNum, chunkID in ipairs(row) do
            local x = (colNum - 1) * 256
            GRAFX:draw(chunkImg, chunks[chunkID], x, y, 0, 1, 1)
        end
    end
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
    :add("zooming",      { imageViewer = GRAFX,            })
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


