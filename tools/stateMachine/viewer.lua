--------------------------------------------------------------
--                 Functional Specifications                --
--------------------------------------------------------------

--[[
    Short description:
        State Machine components are drawn on a pegboard.
        Mousing over the components cause them to light up.
        Scrolling and zoom are also implemented

        For the simplest type of interaction, the state machine
        diagram will look as follows:

        *-------------*         *-------------*
        |             |   R On  |             |
        |             |-------->|             |
        |  Stand Left |         | Stand Right |
        |             |   L On  |             |
        |             |<--------|             |
        *-------------*         *-------------*

    Features:
        * Can scroll using arrow keys
        * Can zoom using 'z' and 'a' keys
        * Mousing over boxes  causes outline and text to light up
        * Mousing over arrows causes arrow   and text to light up
--]]

--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 768

local LABEL_FONT_SIZE             = 32
local GRID_SIZE                   = 32
local GRAFX                       = require "tools/lib/graphics"

local PEGBOARD       = require("tools/stateMachine/pegboard"):init(GRID_SIZE, GRAFX)
local WIDGET_FACTORY = require("tools/stateMachine/widgetFactory"):init(GRID_SIZE, LABEL_FONT_SIZE, GRAFX)

local WIDGETS        = require("tools/stateMachine/widgets"):init(WIDGET_FACTORY)

local targetBox      = nil

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.draw()
-- Called By:     LOVE2D application, every single frame
--------------------------------------------------------------
function love.draw()
    PEGBOARD:draw()
    WIDGETS:draw()
end

function love.keypressed(key)
    if key == "return" or key == "shifttab" or key == "tab" then
        processRefreshKeyEvent(key)
    else
        processKeypressedEvent(key) 
    end
end

function love.keyreleased(key)
    processKeyreleasedEvent(key)
end

function love.mousepressed(mx, my)
    WIDGETS:deselectAll()
    WIDGETS:mousepressed(mx, my)
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function processRefreshKeyEvent(key)
    if     key == "return"   then WIDGETS:refresh()
    elseif key == "shifttab" then WIDGETS:prev()
    elseif key == "tab"      then WIDGETS:next()  end
    
    refreshTargetBox()
end

function processKeypressedEvent(key)
    WIDGETS:deselectAll()
    for _, widget in ipairs(WIDGETS:get()) do
        if widget.keypressed == key and widget.from == targetBox then
            targetBox = widget.to
            targetBox:select()
        end
    end
end

function refreshTargetBox()
    targetBox = WIDGETS:getFirstBox()
    targetBox:select()
end

function processKeyreleasedEvent(key)
    WIDGETS:deselectAll()
    for _, widget in ipairs(WIDGETS:get()) do
        if widget.keyreleased == key and widsget.from == targetBox then
            targetBox = widget.to
            targetBox:select()
        end
    end
end

--------------------------------------------------------------
--                        Plugins                           --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("scrolling", { 
        imageViewer = GRAFX,
        leftKey     = "shiftleft",
        rightKey    = "shiftright",
        upKey       = "shiftup",
        downKey     = "shiftdown",
    })
    :add("zooming",   { imageViewer = GRAFX })
    
-- ...
-- ...

--------------------------------------------------------------
--               Static code - is executed last             --
--------------------------------------------------------------

love.window.setTitle("State Machine Viewer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

refreshTargetBox()
