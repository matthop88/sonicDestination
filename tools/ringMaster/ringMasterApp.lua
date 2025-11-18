--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local RING_INFO     = require("tools/ringMaster/ringInfo")
local RING_SCANNER  = require("tools/ringMaster/pipelines/objectScanner")

local MAP_IMG_PATH  = "resources/zones/maps/" .. __PARAMS["mapIn"] .. ".png"
local MAP_IMG_OUT   = "resources/zones/maps/" .. (__PARAMS["mapOut"] or "sampleRingMapImage")
local MAP_SAVER     = require("tools/ringMaster/savableMap"):create(MAP_IMG_PATH, (__PARAMS["ringDataOut"] or "sampleRingData") .. ".lua")
local RING_MODE     = false

require("tools/ringMaster/ringSmarts"):upgradeRingList(RING_SCANNER:getObjectsFound())

local DOCS = {
    tabSize = 200,
    { "Arrow Keys",   "- Scroll map"      },
    { "z/a",          "- Zoom in/out"     },
    { "Space",        "- Scan for Rings"  },
    { "r",            "- Enter / Exit Ring Placement mode"    },
    { "x",            "- Erase ring (in ring placement mode)" },
    { "c",            "- Show number of rings found"          },
    "Shift-Left,",
    "Shift-Right,",
    "Shift-Up,",
    { "Shift-Down",   "- Move a selected ring one pixel"      },
    { "Return",       "- Save Ring placement data"            },
    { "Shift-Return", "- Save updated map image",             },
}

local QUESTION_BOX = require("tools/ringMaster/questionBox"):create(1150, 10, DOCS)

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("RingMaster")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.update(dt)
    if RING_SCANNER:isReady()    then RING_SCANNER:execute()               end
    RING_SCANNER:getObjectsFound():update(dt, getImageViewer(), RING_SCANNER:isComplete())
    if not RING_SCANNER:isComplete() then
        setProgressBarText("Scanning for Rings... (" .. #RING_SCANNER:getObjectsFound() .. " found)")
    end
    QUESTION_BOX:update(dt)
end

function love.keypressed(key)
    if     key == "space"       then scanForRings()
    elseif key == "return"      then 
        MAP_SAVER:save(RING_SCANNER:getObjectsFound()) 
        printToReadout("Ring Map Saved.")
    elseif key == "shiftreturn" then saveMapImage()
    elseif key == "r"           then RING_MODE = not RING_MODE
    elseif key == "c"           then printToReadout("Number of Rings: " .. #RING_SCANNER:getObjectsFound())
    elseif key == "shiftright"
        or key == "shiftleft"
        or key == "shiftup"
        or key == "shiftdown" 
        or key == "x" then
            local ring = RING_SCANNER:getObjectsFound():findSelected(getImageViewer())
            if ring then
                if     key == "shiftright" then ring.x = ring.x + 1
                elseif key == "shiftleft"  then ring.x = ring.x - 1
                elseif key == "shiftup"    then ring.y = ring.y - 1
                elseif key == "shiftdown"  then ring.y = ring.y + 1 
                elseif key == "x"          then 
                    RING_INFO:eraseRing(ring, RING_SCANNER:getMapData()) 
                    getImageViewer():refresh()
                end
            end
    end

end

function love.mousepressed(mx, my, p)
    if RING_MODE then
        local x, y = getImageViewer():screenToImageCoordinates(mx, my)
        table.insert(RING_SCANNER:getObjectsFound(), { x = math.floor(x), y = math.floor(y) })
        RING_MODE = false
    else
        QUESTION_BOX:handleMousepressed(mx, my, p)
    end
end

function love.mousereleased(mx, my)
    QUESTION_BOX:handleMousereleased(mx, my)
end

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function scanForRings()
    if not RING_SCANNER:isReady() and not RING_SCANNER:isComplete() then
        RING_SCANNER:setup(RING_INFO, getMapInfo())
        RING_SCANNER:execute()
    end
end

function getMapInfo()
    local img = getImageViewer()
    return { data = img:getImageData(), width = img:getImageWidth(), height = img:getImageHeight(), startX = 0, startY = 0 }
end

function drawObjects()
    RING_SCANNER:getObjectsFound():draw(getImageViewer(), RING_INFO)
    love.mouse.setVisible(not RING_MODE)
    if RING_MODE then
        local x, y = love.mouse.getPosition()
        local scale = getImageViewer():getScale()
        RING_INFO:draw(x, y, scale, { 1, 1, 1 })
    end
    QUESTION_BOX:draw()
end

function saveMapImage()
    local fileData = MAP_SAVER:saveImage(RING_SCANNER:getMapData(), MAP_IMG_OUT)
    printToReadout("Changes have been saved (" .. fileData:getSize() .. " bytes.)")
    print("Saved to " .. love.filesystem.getSaveDirectory())
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("doubleClick",
    {
        accessorFnName = "getDoubleClick",
    })
    :add("imageViewer",
    {
        imagePath       = MAP_IMG_PATH,
        accessorFnName  = "getImageViewer",
        pixelated       = true,
    })
    :add("zooming",      { imageViewer = getImageViewer() })
    :add("scrolling",    
    { 
        imageViewer = getImageViewer(),
        scrollSpeed = 2400,
    })
    :add("drawingLayer", { drawingFn   = drawObjects      })
    :add("progressBar",
    {
        message       = "Scanning for Rings...",
        callback      = function() return RING_SCANNER:getProgress() end,
        setTextFnName = "setProgressBarText",
    })
    :add("readout",      { printFnName = "printToReadout" })
