--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX   = require("tools/lib/graphics"):create()

local RESOURCE_MANAGER = require("tools/mapViewer/resourceManager")

local mapData  = RESOURCE_MANAGER:getMapData()
local chunkImg = RESOURCE_MANAGER:getChunkImage()

local mapImageNameToRewrite = __PARAMS["mapOut"] or "sampleRewrittenMapImage"

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

    draw = function(self, chunkID, x, y, scale)
        GRAFX:setColor(1, 1, 1)
        GRAFX:draw(chunkImg, self[chunkID], x, y, 0, scale, scale)
    end,

}):init()

local map = ({
    chunkMode = false,

    init = function(self)
        self.pageWidth  = #mapData[1] * 256
        self.pageHeight = #mapData    * 256

        return self
    end,

    draw = function(self)
        for rowNum, row in ipairs(mapData) do
            local y = (rowNum - 1) * 256
            for colNum, chunkID in ipairs(row) do
                local x = (colNum - 1) * 256
                GRAFX:setColor(1, 1, 1)
                local scale, xMod, yMod = 1, 0, 0
                if self.chunkMode then scale, xMod, yMod = 0.94, 8, 8 end
                chunks:draw(chunkID, x + xMod, y + yMod, scale)
                if self.chunkMode then
                    GRAFX:setFontSize(96)
                    GRAFX:printf("" .. chunkID, x + xMod, y + yMod + 64, 256, "center")
                end
                    
            end
        end

    end,

    handleKeypressed = function(self, key)
        if     key == "c"      then self.chunkMode = not self.chunkMode 
        elseif key == "return" then self:saveMapImage()             end
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

    saveMapImage = function(self)
        local savableMap = require("tools/mapViewer/savableMap"):create(mapData, chunkImg, chunks)
        local fileData = savableMap:save(mapImageNameToRewrite)

        printToReadout("Changes have been saved (" .. fileData:getSize() .. " bytes.)")
        print("Saved to " .. love.filesystem.getSaveDirectory())
    end,
}):init()

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Map Viewer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    map:draw()
end

function love.update(dt)
	-- Updating happens here
end

function love.keypressed(key)
    if   key == "space" then refreshMap()
    else                     map:handleKeypressed(key) end
end

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function refreshMap()
    RESOURCE_MANAGER:refresh()
    mapData  = RESOURCE_MANAGER:getMapData()
    chunkImg = RESOURCE_MANAGER:getChunkImage()
end

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
    :add("timedFunctions",
    {
        {   secondsWait = 1, 
            callback = function() 
                refreshMap()
            end,
        },
    }) 
