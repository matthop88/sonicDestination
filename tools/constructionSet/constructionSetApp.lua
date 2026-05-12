--------------------------------------------------------------
--                    Global Variables                      --
--------------------------------------------------------------

MUSIC_MANAGER = require("game/music/musicManager"):create()
SOUND_MANAGER = require("game/sound/soundManager")

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
local CHUNKS_PANEL    = require("tools/constructionSet/panels/chunksPanel"):create(STICKY_MOUSE, { 10, 19, 20, 4, 13, 23, 25, 24, 39, 35, 34, 37, 7, 27, 28, 17 })
local CHUNKS_2_PANEL  = require("tools/constructionSet/panels/chunksPanel"):create(STICKY_MOUSE, { 98, 99, 30, 31, 100, 63, 101, 102, 30, })
local CHUNKS_3_PANEL  = require("tools/constructionSet/panels/chunksPanel"):create(STICKY_MOUSE, { 74, 75, 72, 80, 47, })
local CHUNKS_4_PANEL  = require("tools/constructionSet/panels/chunksPanel"):create(STICKY_MOUSE, { 4, 5 })
local BADNIKS_PANEL   = require("tools/constructionSet/panels/badniksPanel"):create( { "motobug" },              STICKY_MOUSE)
local BADNIKS_2_PANEL = require("tools/constructionSet/panels/badniksPanel"):create( { "patabata", "tamabboh" }, STICKY_MOUSE)

local ITEMS_PANEL     = require("tools/constructionSet/panels/itemsPanel"):create( { "ring", "giantRing", "lampPost", }, STICKY_MOUSE)
local ITEMS_2_PANEL   = require("tools/constructionSet/panels/itemsPanel"):create( { "bigBall", }, STICKY_MOUSE)

local MISCELLANEOUS_PANEL = require("tools/constructionSet/panels/miscellaneousPanel"):create()

local PLAYER_PANEL    = require("tools/constructionSet/panels/playerPanel"):create( { "sonic1" }, STICKY_MOUSE)
local PLAYER_2_PANEL  = require("tools/constructionSet/panels/playerPanel"):create( { "sonic2" }, STICKY_MOUSE)
--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Construction Set")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

local PROPERTIES    = {
    encode = function(self)
        local encoded = "  properties = {\n"
        if self.music then
            encoded = encoded .. "      music = \"" .. self.music .. "\",\n"
        end
        if self.musicVolume then
            encoded = encoded .. "      musicVolume = " .. self.musicVolume .. ",\n"
        end
        if self.musicPitch then
            encoded = encoded .. "      musicPitch = " .. self.musicPitch .. ",\n"
        end
        if self.musicEffect then
            encoded = encoded .. "      musicEffect = \"" .. self.musicEffect .. "\",\n"
        end
        if self.musicDelay then
            encoded = encoded .. "      musicDelay = " .. self.musicDelay .. ",\n"
        end
        if self.musicStrength then
            encoded = encoded .. "      musicStrength = " .. self.musicStrength .. ",\n"
        end
        if self.musicEchoCount then
            encoded = encoded .. "      musicEchoCount = " .. self.musicEchoCount .. ",\n"
        end
        encoded = encoded .. self:encodeSounds()
        encoded = encoded .. self:encodeTime()
        encoded = encoded .. "  },\n"

        return encoded
    end,

    encodeSounds = function(self)
        local encoded = ""
        if self.sounds then
            encoded = encoded .. "      sounds = {\n"
            for k, v in pairs(self.sounds) do
                encoded = encoded .. self:generateKV(10, k, v)
            end
            encoded = encoded .. "      },\n"
        end
        return encoded
    end,

    generateKV = function(self, padding, key, value)
        if type(value) == "table" then
            return self:generateKVTable(padding, key, value)
        else
            local myValue = value
            if     type(myValue) == "string"  then myValue = "\"" .. myValue .. "\""
            elseif type(myValue) == "boolean" then
                if myValue then myValue = "true"
                else            myValue = "false" end
            end
            return string.rep(" ", padding) .. key .. " = " .. myValue .. ",\n"
        end
    end,

    generateKVTable = function(self, padding, key, value)
        local result = string.rep(" ", padding) .. key .. " = {\n"
        for k,v in pairs(value) do
            result = result .. self:generateKV(padding + 4, k, v)
        end
        return result .. string.rep(" ", padding) .. "},\n"
    end,

    encodeTime = function(self)
        local encoded = ""
        if self.time then
            encoded = encoded .. "      time = {\n"
            for k, v in pairs(self.time) do
                encoded = encoded .. self:generateKV(10, k, v)
            end
            encoded = encoded .. "      },\n"
        end
        return encoded
    end,
       
}
--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    MAP:draw()
end

function love.update(dt)
    STICKY_MOUSE:update(dt)
    MAP:update(dt)
    MUSIC_MANAGER:update(dt)
    SOUND_MANAGER:update(dt)
end

function love.keypressed(key)
    STICKY_MOUSE:handleKeypressed(key)
    if key == "S" then
        MAP:saveMap(DATA_OUT)
        MAP:saveObjects(DATA_OUT)
        printToReadout("Map saved: " .. DATA_OUT)
        print("Saved to " .. love.filesystem.getSaveDirectory())
    elseif key == "R" then
        refreshFromFile()
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

function refreshFromFile()
    MAP:clear()
    
    -- Reload from files
    if DATA_IN then
        local mapPath = "game/resources/zones/maps/" .. DATA_IN .. "Map"
        local objPath = "game/resources/zones/objects/" .. DATA_IN .. "Objects"
        
        if love.filesystem.getInfo(mapPath .. ".lua") then
            package.loaded[mapPath] = nil
            require("tools/constructionSet/mapReader"):readMapIntoChunksList(require(mapPath), MAP.chunks)
        end
        
        if love.filesystem.getInfo(objPath .. ".lua") then
            package.loaded[objPath] = nil
            local objectsData = require(objPath)
            require("tools/constructionSet/mapReader"):readObjectsIntoObjectsList(objectsData, MAP.objects)
            require("tools/constructionSet/mapReader"):readPlayerFromObjects(objectsData, MAP.player)
        end
        
        printToReadout("Map refreshed: " .. DATA_IN)
    end
end   

function getProperties()
    return PROPERTIES
end 

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("doubleClick")
    :add("inputLayer", {
        accessorFnName = "getInputLayer",
        keypressedFn = function(key)
            if _G.getModals then
                return getModals():handleKeypressedFromInputLayer(key)
            end
        end,
    })
    :add("timedFunctions",
    {
        {   secondsWait = 0.25, 
            callback = function() 
                CHUNKS_PANEL:initChunkInfo("ghzChunks")
                CHUNKS_2_PANEL:initChunkInfo("scdPtpChunksOrig")
                CHUNKS_3_PANEL:initChunkInfo("scdPtpGF1Chunks")
                CHUNKS_4_PANEL:initChunkInfo("scdCCPastChunksOrig")
                
                MUSIC_MANAGER:newTrack("constructionSet")
                MUSIC_MANAGER:play()

                if SHOW_DATA then
                    showData()
                    love.event.quit()
                elseif DATA_IN then
                    local mapPath = "game/resources/zones/maps/" .. DATA_IN .. "Map"
                    local objPath = "game/resources/zones/objects/" .. DATA_IN .. "Objects"
                    if love.filesystem.getInfo(mapPath .. ".lua") then
                        local mapData = require(mapPath)
                        require("tools/constructionSet/mapReader"):readMapIntoChunksList(mapData, MAP.chunks)
                        require("tools/constructionSet/mapReader"):readMusicFromMap(mapData)
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
             { label = "Chunks",  panel = require("tools/constructionSet/panels/multiPanel"):create { CHUNKS_PANEL,  CHUNKS_2_PANEL, CHUNKS_3_PANEL, CHUNKS_4_PANEL,  }, },
             { label = "Badniks", panel = require("tools/constructionSet/panels/multiPanel"):create { BADNIKS_PANEL, BADNIKS_2_PANEL }, },
             { label = "Items",   panel = require("tools/constructionSet/panels/multiPanel"):create { ITEMS_PANEL, ITEMS_2_PANEL }, },
             { label = "Player",  panel = require("tools/constructionSet/panels/multiPanel"):create { PLAYER_PANEL, PLAYER_2_PANEL }, },
             { label = "Miscellaneous", panel = MISCELLANEOUS_PANEL, },
        },
        accessorFnName = "getTabbedPane",
    })
    :add("scrolling",      { imageViewer = MAP })
    :add("readout",        { printFnName = "printToReadout" })
    :add("questionBox",
    {   x = 1150,
        useDoubleClick = true,
        getDoubleClickFn = getDoubleClick,
        lines = {
            tabSize = 200,
            "Navigation_",
            { "Arrow Keys", "- Scroll Map View", },
            { "z/a keys", "- Zoom in/out on map", },
            "",
            "Tab Panel Interface_",
            { "Double-click", },
            { "   (or space)", "- Toggle opening tab pane", },
            { "option-tab", "- Move to next page in current tab", },
            { "shift-option-tab", "- Move to previous page in current tab", },
            "",
            "Placement Mode_",
            { "tab", "- Select next entry in current tab panel", },
            { "shift-tab", "- Select previous entry in current tab panel", },
            { "Click", "- Places held entity", },
            { "escape", "- Exits placement mode", },
            "",
            "Selection Mode_",
            { "Click",  "- Selects chunk, badnik, item or player",  },
            { "Delete", "- Deletes selected entity", },
            { "Shift-arrow", "- Nudges selected badnik, item or player", },
            { "x", "- Flips selected entity horizontally", },
            { "space", "- Picks up entity; enters placement mode", },
            "",
            "Miscellaneous_",
            { "S", "- Save to file", },
            { "R", "- Refresh from file", },
        },
    })
    :add("modals", { accessorFnName = "getModals" })
    
