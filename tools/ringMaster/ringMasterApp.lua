--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local RING_INFO     = require("tools/ringMaster/ringInfo")
local RING_SCANNER  = require("tools/ringMaster/objectScanner")

local MAP_IMG_PATH  = "resources/zones/maps/" .. __PARAMS["mapIn"] .. ".png"

local HOTCOLD_ALPHA    = 1
local DEBUG_MODE       = false
local RING_PULSE       = 0
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
    if key == "d" then DEBUG_MODE = not DEBUG_MODE end
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
    if RING_SCANNER:getColdList() then
        for _, block in ipairs(RING_SCANNER:getColdList()) do
            love.graphics.setColor(0, 0, 0, 0.5 * (block.alpha or 0) * HOTCOLD_ALPHA)
            local x, y, w, h = getImageViewer():imageToScreenRect(block.offset, 0, block.size, RING_SCANNER:getMapData():getHeight())
            love.graphics.rectangle("fill", x, y, w, h)
        end
    end

    if RING_SCANNER:getHotList() then
        for _, block in ipairs(RING_SCANNER:getHotList()) do
            if block.coldList then
                for _, blockH in ipairs(block.coldList) do
                    love.graphics.setColor(0, 0, 0, 0.5 * (blockH.alpha or 1) * HOTCOLD_ALPHA)
                    local x, y, w, h = getImageViewer():imageToScreenRect(block.offset, blockH.offset, block.size, blockH.size)
                    love.graphics.rectangle("fill", x, y, w, h)
                end
            end
        end
    end

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

        love.graphics.setColor(0, 0, 0, RING_PULSE)
        love.graphics.rectangle("fill", IMAGE_VIEWER:pageToScreenRect(ring.x, ring.y, 16, 16))
        
        local x, y = IMAGE_VIEWER:imageToScreenCoordinates(ring.x + 8 - (8 * ringScale) + deltaX, ring.y + 8 - (8 * ringScale) + deltaY)
        local scale = IMAGE_VIEWER:getScale() * ringScale
        RING_INFO:draw(x, y, scale, { 1, 1, 1, (1 - ring.alpha) *  (1 - ring.alpha) * 0.7})
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

    if RING_SCANNER:getColdList() then
        for _, block in ipairs(RING_SCANNER:getColdList()) do
            if block.alpha == nil then block.alpha = 0
            else                       block.alpha = math.min(1, block.alpha + (0.5 * dt)) end
        end
    end

    if RING_SCANNER:getHotList() then
        for _, block in ipairs(RING_SCANNER:getHotList()) do
            if block.coldList then
                for _, blockH in ipairs(block.coldList) do
                    if blockH.alpha == nil then blockH.alpha = 0
                    else                        blockH.alpha = math.min(1, blockH.alpha + (1 * dt)) end
                end
            end
        end
    end
    if RING_SCANNER:isComplete() then
        if DEBUG_MODE then
            HOTCOLD_ALPHA = math.max(0.5, HOTCOLD_ALPHA - (1 * dt))
        else
            HOTCOLD_ALPHA  = math.max(0, HOTCOLD_ALPHA  - (1 * dt))
        end
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
