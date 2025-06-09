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

local WIDGETS        = ({
    "standing",
    "running",

    currentWidgetList = { },
    currentIndex      = 1,

    init = function(self)
        self:refresh()
        return self
    end,

    get         = function(self) return self.currentWidgetList                                     end,
    getDataName = function(self) return self[self.currentIndex]                                    end,
    getFileName = function(self) return "tools/stateMachine/data/" .. self:getDataName() .. ".lua" end,

    next = function(self)
        self.currentIndex = self.currentIndex + 1
        if self.currentIndex > #self then
            self.currentIndex = 1
        end
        self:refresh()
    end,

    prev = function(self)
        self.currentIndex = self.currentIndex - 1
        if self.currentIndex < 1 then
            self.currentIndex = #self
        end
        self:refresh()
    end,

    refresh = function(self)
        self.currentWidgetList = WIDGET_FACTORY:createWidgets(dofile(self:getFileName()))
    end,

}):init()  
       

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.draw()
-- Called By:     LOVE2D application, every single frame
--------------------------------------------------------------
function love.draw()
    PEGBOARD:draw()

    for _, widget in ipairs(WIDGETS:get()) do
        widget:draw()
    end
end

function love.keypressed(key)
    if     key == "return" then
        WIDGETS:refresh()
    elseif key == "shiftleft" then
        WIDGETS:prev()
    elseif key == "shiftright" then
        WIDGETS:next()
    end
end

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
    :add("modKeyEnabler")
    :add("scrolling", { imageViewer = GRAFX })
    :add("zooming",   { imageViewer = GRAFX })
    
-- ...
-- ...

--------------------------------------------------------------
--               Static code - is executed last             --
--------------------------------------------------------------

love.window.setTitle("State Machine Viewer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

