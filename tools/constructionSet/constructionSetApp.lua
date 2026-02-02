--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800
local FONT_SIZE      = 24
local FONT           = love.graphics.newFont(FONT_SIZE)
local TABS           = { "Chunks", "Badniks", "Items" }
local TAB_INDEX      = 1
local TAB_MARGIN     = 15
local TAB_SPACING    = 40

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
    love.graphics.line(  5,  795, 1195, 795)
    love.graphics.line(1195, 795, 1195, 500)
    love.graphics.line(  5,  500,    5, 795)
    love.graphics.line(  5,  500,  100 - TAB_MARGIN, 500)

    love.graphics.setFont(FONT)
    local x = 100
    local index = 1
    for _, t in ipairs(TABS) do
        local w = FONT:getWidth(t)
        love.graphics.line(x - TAB_MARGIN,     470, x + w + TAB_MARGIN, 470)
        love.graphics.line(x - TAB_MARGIN,     470, x - TAB_MARGIN,     499)
        love.graphics.line(x + w + TAB_MARGIN, 470, x + w + TAB_MARGIN, 499)
        if index ~= TAB_INDEX then
            love.graphics.line(x - TAB_MARGIN + 1, 500, x + w + TAB_MARGIN - 1, 500)
        end
        love.graphics.line(x + w + TAB_MARGIN, 500, x + w + TAB_SPACING - TAB_MARGIN, 500)
        index = index + 1
        love.graphics.printf(t, x, 470, 500, "left")
        x = x + w + TAB_SPACING
    end
    love.graphics.line(x - TAB_MARGIN + 1, 500, 1195, 500)
end

function love.keypressed(key)
    TAB_INDEX = TAB_INDEX + 1
    if TAB_INDEX > #TABS then TAB_INDEX = 1 end
end

-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
--        ...
--        ...
--        ...

    
