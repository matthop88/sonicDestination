--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local graphics        = require("tools/lib/graphics"):create()

local SHOW_DATA       = __PARAMS["showData"]
local DATA_IN         = __PARAMS["dataIn"]  or "sample"
local DATA_OUT        = __PARAMS["dataOut"] or DATA_IN
local MAP             = require("tools/constructionSet/engine/map"):create { graphics = graphics }
local STICKY_MOUSE    = require("tools/constructionSet/stickyMouse"):create(MAP)
local CHUNKS_PANEL    = require("tools/constructionSet/panels/chunksPanel"):create(STICKY_MOUSE, { 10, 19, 34, 37, 7, 20, 17 })
local CHUNKS_2_PANEL  = require("tools/constructionSet/panels/chunksPanel"):create(STICKY_MOUSE, { 1, 2, 3, 4, 5, 6, 7 })
local BADNIKS_PANEL   = require("tools/constructionSet/panels/badniksPanel"):create( { "motobug" },              STICKY_MOUSE)
local BADNIKS_2_PANEL = require("tools/constructionSet/panels/badniksPanel"):create( { "patabata", "tamabboh" }, STICKY_MOUSE)

local ITEMS_PANEL     = require("tools/constructionSet/panels/itemsPanel"):create(STICKY_MOUSE)

local PLAYER_PANEL    = require("tools/constructionSet/panels/playerPanel"):create( { "sonic1" }, STICKY_MOUSE)
local PLAYER_2_PANEL  = require("tools/constructionSet/panels/playerPanel"):create( { "sonic2" }, STICKY_MOUSE)
--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Construction Set")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    MAP:draw()
end

function love.update(dt)
    STICKY_MOUSE:update(dt)
    MAP:update(dt)
end

function love.keypressed(key)
    STICKY_MOUSE:handleKeypressed(key)
    if key == "S" then
        MAP:saveMap(DATA_OUT)
        MAP:saveObjects(DATA_OUT)
        printToReadout("Map saved: " .. DATA_OUT)
        print("Saved to " .. love.filesystem.getSaveDirectory())
    else        
        MAP:handleKeypressed(key)
    end
end

function love.mousepressed(mx, my)
    STICKY_MOUSE:handleMousepressed(graphics, mx, my)
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function drawMouse()
    local mx, my = love.mouse.getPosition()
    STICKY_MOUSE:draw(graphics, mx, my)
end

function drawCoordinates()
    MAP:drawCoordinates()
end

function showData()
    local STRING_UTIL = require("tools/lib/stringUtil")
    print("\nData Names:\n-----------")
    local dataFilenames = love.filesystem.getDirectoryItems("game/resources/zones/maps")
    for _, dataFilename in ipairs(dataFilenames) do
        if STRING_UTIL:endsWith(dataFilename, ".lua") then
            print(string.sub(dataFilename, 1, string.len(dataFilename) - 7))
        end
    end
    print()
end    

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("doubleClick")
    :add("timedFunctions",
    {
        {   secondsWait = 0.25, 
            callback = function() 
                CHUNKS_PANEL:initChunkInfo("ghzChunks")
                CHUNKS_2_PANEL:initChunkInfo("scdPtpChunks")
                
                if SHOW_DATA then
                    showData()
                    love.event.quit()
                elseif DATA_IN then
                    local mapPath = "game/resources/zones/maps/" .. DATA_IN .. "Map"
                    local objPath = "game/resources/zones/objects/" .. DATA_IN .. "Objects"
                    if love.filesystem.getInfo(mapPath .. ".lua") then
                        require("tools/constructionSet/mapReader"):readMapIntoChunksList(require(mapPath), MAP.chunks)
                    end
                    if love.filesystem.getInfo(objPath .. ".lua") then
                        local objectsData = require(objPath)
                        require("tools/constructionSet/mapReader"):readObjectsIntoObjectsList(objectsData, MAP.objects)
                        require("tools/constructionSet/mapReader"):readPlayerFromObjects(objectsData, MAP.player)
                    end
                end
            end,
        },
    }) 
    :add("zooming",        { imageViewer = MAP })    
    :add("grid2d",         { 
        graphics    = graphics,
        bounds      = { x = 0, y = 0, w = 256, h = 256 },
    }) 
    :add("drawingLayer", { drawingFn = drawCoordinates })
    :add("drawingLayer", { drawingFn = drawMouse })
    :add("tabbedPane",
    { 
        TABS = { 
             { label = "Chunks",  panel = require("tools/constructionSet/panels/multiPanel"):create { CHUNKS_PANEL,  CHUNKS_2_PANEL  }, },
             { label = "Badniks", panel = require("tools/constructionSet/panels/multiPanel"):create { BADNIKS_PANEL, BADNIKS_2_PANEL }, },
             { label = "Items",   panel = ITEMS_PANEL, },
             { label = "Player",  panel = require("tools/constructionSet/panels/multiPanel"):create { PLAYER_PANEL, PLAYER_2_PANEL }, },
        },
        accessorFnName = "getTabbedPane",
    })
    :add("scrolling",      { imageViewer = MAP })
    :add("readout",        { printFnName = "printToReadout" })
    
