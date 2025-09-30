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
local GRAFX                       = require("tools/lib/graphics"):create()

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- ...

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

-- ...

--------------------------------------------------------------
--               Static code - is executed last             --
--------------------------------------------------------------

love.window.setTitle("State Machine Viewer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                        Plugins                           --
--------------------------------------------------------------

-- Overridden by readout plugin
function printMessage(msg)
    print(msg)
end

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
    :add("stateMachineViewer", {
        graphics = GRAFX,
        states   = { "standing", "running", "decelerating", "braking", "jumping", "runningBrakingJumping" },
        nextKey  = "tab",
        prevKey  = "shifttab",
    })
    :add("readout",   { printFnName = "printMessage" })
    
-- ...
-- ...
