--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local RING_INFO     = require("tools/ringMaster/ringInfo")
local RING_SCANNER  = require("tools/ringMaster/pipelines/objectScanner")

local MAP_IMG_PATH  = "resources/zones/maps/" .. __PARAMS["mapIn"] .. ".png"
local MAP_SAVER     = require("tools/ringMaster/savableMap"):create(MAP_IMG_PATH, (__PARAMS["ringDataOut"] or "sampleRingData") .. ".lua")

local RING_PULSE       = 1
local TIME             = 0

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
    updateObjects(dt)
end

function love.keypressed(key)
    if key == "return" then
        MAP_SAVER:save(RING_SCANNER:getObjectsFound())
    end
end

function love.mousepressed(mx, my)
    scanForRings()
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
    for _, ring in ipairs(RING_SCANNER:getObjectsFound()) do
        drawRingHighlight(ring)
    end
end

function drawRingHighlight(ring)
    local IMAGE_VIEWER = getImageViewer()
    
    if ring.alpha ~= nil then
        local ringScale = math.max(1, (ring.alpha * ring.alpha * 400))
        local deltaX = ring.deltaX * (ringScale - 1)
        local deltaY = ring.deltaY * (ringScale - 1)

        local x, y = IMAGE_VIEWER:imageToScreenCoordinates(ring.x + 8 - (8 * ringScale) + deltaX, ring.y + 8 - (8 * ringScale) + deltaY)
        local scale = IMAGE_VIEWER:getScale() * ringScale
        RING_INFO:draw(x, y, scale, { 1, 0, 0, RING_PULSE * (1 - ring.alpha) *  (1 - ring.alpha) * 0.7})
        love.graphics.setColor(1, 1, 0, (1 - ring.alpha) * 0.7)
        love.graphics.setLineWidth(1 * IMAGE_VIEWER:getScale())
        love.graphics.rectangle("line", IMAGE_VIEWER:pageToScreenRect(ring.x, ring.y, 16, 16))
    end
end

function updateObjects(dt)
    for _, ring in ipairs(RING_SCANNER:getObjectsFound()) do
        if ring.alpha == nil then 
            ring.alpha  = 1
            ring.speed  = math.random(2, 6) / 3
            ring.deltaX = math.random(-20, 20)
            ring.deltaY = math.random(-6, 6)
        else           
            ring.alpha  = math.max(0, ring.alpha - (ring.speed * dt))
        end
    end

    if RING_SCANNER:isComplete() then
        RING_PULSE = 0.5 + math.sin(TIME * 5) * 0.5
        TIME = TIME + dt
    end
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
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
        message  = "Scanning for Rings...",
        callback = function() return RING_SCANNER:getProgress() end,
    })
    :add("readout",      { printFnName = "printToReadout" })
