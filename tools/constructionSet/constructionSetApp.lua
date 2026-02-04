--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local CHUNKS_PANEL = require("tools/constructionSet/chunksPanel"):create()
local TABBED_PANE  = require("tools/constructionSet/tabbedPane"):create 
{ 
    TABS = { 
             { label = "Chunks",  panel = CHUNKS_PANEL, },
             { label = "Badniks", panel = nil, },
             { label = "Items",   panel = nil, },
    }
}

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Construction Set")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    TABBED_PANE:draw()
end

function love.update(dt)
    TABBED_PANE:update(dt)
end

function love.mousepressed(mx, my, params)
    TABBED_PANE:handleMousepressed(mx, my, params)
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("doubleClick")
    
--        ...
--        ...

