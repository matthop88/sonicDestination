--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800
local FONT_SIZE      = 24
local FONT           = love.graphics.newFont(FONT_SIZE)
local TABS           = { "Chunks", "Badniks", "Items" }

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Construction Set")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", 5, 500, 1190, 295)
    love.graphics.setFont(FONT)
    local x = 100
    for _, t in ipairs(TABS) do
        love.graphics.printf(t, x, 470, 500, "left")
        local w = FONT:getWidth(t)
        love.graphics.rectangle("line", x - 10, 470, w + 20, 29)
        x = x + w + 32
    end
end

-- ...
-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
--        ...
--        ...
--        ...

    
