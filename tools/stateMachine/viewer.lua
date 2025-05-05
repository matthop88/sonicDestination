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
        [X] Pegboard is drawn in background
        [X] Boxes are drawn with labels in the center
        [X] Arrows are drawn connecting boxes, with labels
        [X] Can scroll using arrow keys
        [X] Can zoom using 'z' and 'a' keys
        [X] Mousing over boxes  causes outline and text to light up
        [X] Mousing over arrows causes arrow   and text to light up
--]]

--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 768

local LABEL_FONT_SIZE             = 32
local GRID_SIZE                   = 32
local GRAFX                       = require "tools/lib/graphics"

local PEGBOARD    = require("tools/stateMachine/pegboard"):init(GRID_SIZE, GRAFX)
local BOX         = require("tools/stateMachine/box"):init(GRID_SIZE, LABEL_FONT_SIZE, GRAFX)
local ARROW       = require("tools/stateMachine/arrow"):init(GRID_SIZE, LABEL_FONT_SIZE, GRAFX)

local LEFT_BOX    = BOX:create("Stand Left",   3,  7,  9,  7)
local RIGHT_BOX   = BOX:create("Stand Right", 20,  7,  9,  7)
local LEFT_ARROW  = ARROW:create("L On",      20,  9, 12,  9)
local RIGHT_ARROW = ARROW:create("R On",      12, 12, 20, 12)

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.draw()
-- Called By:     LOVE2D application, every single frame
--------------------------------------------------------------
function love.draw()
    PEGBOARD:draw()

    LEFT_BOX:draw()
    RIGHT_BOX:draw()
    LEFT_ARROW:draw()
    RIGHT_ARROW:draw()
end

-- ...
-- ...

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

-- ...
-- ...
-- ...

--------------------------------------------------------------
--                        Plugins                           --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("scrolling", { imageViewer = GRAFX })
    :add("zooming",   { imageViewer = GRAFX })
    
-- ...
-- ...

--------------------------------------------------------------
--               Static code - is executed last             --
--------------------------------------------------------------

love.window.setTitle("State Machine Viewer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

