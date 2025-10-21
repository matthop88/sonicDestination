--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local CHUNKS_DATA_PATH = "resources/zones/chunks/" .. __PARAMS["chunkDataIn"] .. ".lua"
local CHUNKS_OUT_NAME  = __PARAMS["chunkDataOut"] or __PARAMS["chunkDataIn"]
local CHUNK_ARTIST     = require("tools/chunkDoctor/chunkArtist"):create(CHUNKS_DATA_PATH)

local STICKY_MOUSE     = require("tools/chunkDoctor/stickyMouse"):init(CHUNK_ARTIST)
local SIDEBAR_PANEL    = require("tools/chunkDoctor/sidebar/sidebarPanel"):init(CHUNK_ARTIST, STICKY_MOUSE)
local MAIN_PANEL       = require("tools/chunkDoctor/mainPanel/mainPanel"):init(CHUNK_ARTIST, STICKY_MOUSE, SIDEBAR_PANEL)

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Chunk Doctor")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    MAIN_PANEL:draw()
    SIDEBAR_PANEL:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)
    love.graphics.line(700, 0, 700, 800)
end

function love.update(dt)
    MAIN_PANEL:update(dt)
    SIDEBAR_PANEL:update(dt)
end

function love.keypressed(key)
    local mx, _ = love.mouse.getPosition()
    if     key == "commandz"   then undo()
    elseif key == "commandZ"   then redo()
    elseif key == "shiftright" then SIDEBAR_PANEL:walkSelectedTile( 1,  0)
    elseif key == "shiftleft"  then SIDEBAR_PANEL:walkSelectedTile(-1,  0)
    elseif key == "shiftup"    then SIDEBAR_PANEL:walkSelectedTile( 0, -1)
    elseif key == "shiftdown"  then SIDEBAR_PANEL:walkSelectedTile( 0,  1)
    elseif key == "s"          then
        MAIN_PANEL:toggleSolidsMode()
        SIDEBAR_PANEL:toggleSolidsMode()
    elseif mx <= 700           then MAIN_PANEL:handleKeypressed(key)
    else                            SIDEBAR_PANEL:handleKeypressed(key) end
end

function love.keyreleased(key)
    MAIN_PANEL:handleKeyreleased(key)
    SIDEBAR_PANEL:handleKeyreleased(key)
end

function love.mousepressed(mx, my)
    if mx <= 700 then MAIN_PANEL:handleMousepressed(mx, my)
    else              SIDEBAR_PANEL:handleMousepressed(mx, my) end
    CHUNK_ARTIST:saveChunkData(CHUNKS_OUT_NAME)
end

function love.mousereleased(mx, my)
    MAIN_PANEL:handleMousereleased(mx, my)
end

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function undo()
    MAIN_PANEL:undo()
    CHUNK_ARTIST:saveChunkData(CHUNKS_OUT_NAME)
end

function redo()
    MAIN_PANEL:redo()
    CHUNK_ARTIST:saveChunkData(CHUNKS_OUT_NAME)
end

-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("keyRepeat", {
        interval    = 0.1,
        delay       = 0.5,
        onKeyRepeat = function() 
            MAIN_PANEL:onKeyRepeat() 
            SIDEBAR_PANEL:onKeyRepeat()
        end,
    })

