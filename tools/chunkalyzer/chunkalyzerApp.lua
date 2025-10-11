--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local imgPath

imgPath = "resources/zones/maps/" .. __PARAMS["mapImageIn"] .. ".png"

local imgData = love.image.newImageData(imgPath)
local img     = love.graphics.newImage(imgData)

local chunksImageNameToWrite = __PARAMS["chunkImageOut"] or "sampleChunksImage"
local mapFileNameToWrite     = __PARAMS["mapFileOut"]    or "sampleMapFile"
		
local CHUNKALYZER_MODEL = require("tools/chunkalyzer/model"):init(img)
local CHUNKALYZER_VIEW  = require("tools/chunkalyzer/view"):init(img, CHUNKALYZER_MODEL)

local CHUNK_PIPELINE    = require("tools/chunkalyzer/chunkPipeline")

CHUNKALYZER_VIEW:setPipeline(CHUNK_PIPELINE)

local okayToChunkalyze  = false

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Chunkalyzer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

img:setFilter("nearest", "nearest")

CHUNK_PIPELINE:setup(CHUNKALYZER_MODEL:getChunks(), imgData, CHUNKALYZER_VIEW, CHUNKALYZER_VIEW:getChunkRepo())

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    CHUNKALYZER_VIEW:draw()
end

function love.update(dt)
	if not CHUNK_PIPELINE:isComplete() and okayToChunkalyze then
		CHUNK_PIPELINE:execute()
	end

	CHUNKALYZER_VIEW:update(dt)
end

-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function love.keypressed(key)
	if     key == "m"      then CHUNKALYZER_VIEW:toggleMapMode() 
	elseif key == "space"  then okayToChunkalyze = true
	elseif key == "return" then CHUNKALYZER_VIEW:save(chunksImageNameToWrite, mapFileNameToWrite)
	else                        CHUNKALYZER_VIEW:handleKeypressed(key) end
end

function love.mousepressed(mx, my)
	CHUNKALYZER_VIEW:handleMousepressed(mx, my)
end

-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("zooming",      { imageViewer = CHUNKALYZER_VIEW,            })
    :add("scrolling",    
    { 
    	imageViewer = CHUNKALYZER_VIEW,
    	scrollSpeed = 2400,          
    })
	:add("pause")
    :add("readout",      
    { 
    	printFnName    = "printToReadout", 
    	accessorFnName = "getReadout",
    })  
    :add("timedFunctions",
	{
		{	secondsWait = 1, 
			callback = function() 
				getReadout():setSustain(180) 
				printToReadout("Press 'space' to begin chunkalyzing.") 
			end,
		},
	})    
