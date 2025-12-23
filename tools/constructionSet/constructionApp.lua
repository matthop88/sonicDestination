--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local GRAFX = require("tools/lib/graphics"):create()

GRAFX.moveImageOld = GRAFX.moveImage
GRAFX.moveImage = function(self, deltaX, deltaY)
    self:moveImageOld(deltaX / self:getScale(), deltaY / self:getScale())
end

local CHUNKS

local CHUNK_MAP
local MODE
local mode
    
--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Construction Set")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    if CHUNK_MAP then 
        CHUNK_MAP:draw(GRAFX)
        if mode then 
            mode:draw(GRAFX)
        end
    end
end

function love.keypressed(key)
    if mode then
        if mode:isModeKey(key) then
            mode = MODE.EDIT
        else
            for k, v in pairs(MODE) do
                if v:isModeKey(key) then mode = v end
            end
        end

        mode:handleKeypressed(key)
    end
end

function love.mousepressed(mx, my)
    if mode then mode:handleMousepressed(GRAFX, mx, my) end
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
    :add("doubleClick",
    {
        accessorFnName = "getDoubleClick",
    })
    :add("keyRepeat", {
        interval    = 0.05,
        delay       = 0.5,
    })
    :add("scrolling",      { imageViewer = GRAFX })
    :add("zooming",        { imageViewer = GRAFX })    
    :add("grid2d",         { 
        graphics    = GRAFX,
        bounds      = { x = 0, y = 0, w = 256, h = 256 },
    })
    :add("timedFunctions",
    {
        {   secondsWait = 0.25, 
            callback = function() 
                CHUNKS_MANAGER = require("tools/constructionSet/terrain/chunksManager"):register("ghzChunks_2"):register("scdPtpChunks") 
                CHUNK_MAP      = require("tools/constructionSet/map"):create { w = 256, h = 256, manager = CHUNKS_MANAGER, }
            
                MODE        = {
                    CHUNK  = require("tools/constructionSet/modes/chunkMode"):create(CHUNKS_MANAGER, CHUNK_MAP),
                    EDIT   = require("tools/constructionSet/modes/editMode"):create(CHUNK_MAP),
                }

                mode = MODE.EDIT
            end,
        },
    }) 
    
