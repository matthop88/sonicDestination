--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800
local TAB_PANEL = require("tools/constructionSet/tabPanel"):create { TABS = { "Chunks", "Badniks", "Items" } }

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Construction Set")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    TAB_PANEL:draw()
end

function love.update(dt)
    TAB_PANEL:update(dt)
end

function love.mousepressed(mx, my, params)
    TAB_PANEL:handleMousepressed(mx, my, params)
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("doubleClick")
    
--        ...
--        ...

