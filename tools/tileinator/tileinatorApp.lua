--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX   = require("tools/lib/graphics"):create()

local chunkImg = love.graphics.newImage("resources/zones/chunks/" .. __PARAMS["chunkImageIn"] .. ".png")

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
    for i, chunk in ipairs(chunks) do
        local chunkX = ((i - 1) % 9)           
        local chunkY = math.floor((i - 1) / 9)
        
        GRAFX:setColor(1, 1, 1)
        GRAFX:draw(chunkImg, chunk, (chunkX * 256) + 8, (chunkY * 256) + 8, 0, 0.94, 0.94)
    end
end

function love.update(dt)
	-- Updating happens here
end

function love.keypressed(key)
    -- Keys pressed are processed here
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


