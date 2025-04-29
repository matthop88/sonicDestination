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
        [ ] Arrows are drawn connecting boxes, with labels
        [ ] Can scroll using arrow keys
        [ ] Can zoom using 'z' and 'a' keys
        [ ] Mousing over boxes  causes outline and text to light up
        [ ] Mousing over arrows causes arrow   and text to light up
--]]

--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 768
local COLOR_JET_BLACK             = { 0, 0,   0   }
local COLOR_PURE_WHITE            = { 1, 1,   1         }
local COLOR_LIGHT_YELLOW          = { 1, 1,   0.75      }
local COLOR_MEDIUM_YELLOW         = { 1, 0.8, 0.5       }
local COLOR_PEGBOARD_GREEN        = { 0, 0.3, 0.3 }
local COLOR_PEGHOLES              = { 1, 1,   1,  0.5 }

local LABEL_FONT                  = love.graphics.newFont(32)
local GRID_SIZE                   = 32

local PEGBOARD = {
    draw = function(self)
        self:drawBackground()
        self:drawHoles()
    end,

    drawBackground = function(self)
        love.graphics.setColor(COLOR_PEGBOARD_GREEN)
        love.graphics.rectangle("fill", 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    end,

    drawHoles = function(self)
        for y = 0, WINDOW_HEIGHT, 32 do
            for x = 0, WINDOW_WIDTH, 32 do
                self:drawHole(x, y)
            end
        end
    end,

    drawHole = function(self, x, y)
        love.graphics.setColor(COLOR_PEGHOLES)
        love.graphics.rectangle("fill", x - 1, y - 1, 3, 3)
    end,
}

local BOX = {
    draw = function(self, label, x, y, w, h)
        self:drawComponents(label, x * GRID_SIZE, y * GRID_SIZE, w * GRID_SIZE, h * GRID_SIZE)
    end,

    drawComponents = function(self, label, x, y, w, h)
        self:drawShape(       x, y, w, h)
        self:drawLabel(label, x, y, w, h)
    end,

    drawShape = function(self, x, y, w, h)
        love.graphics.setColor(COLOR_LIGHT_YELLOW)
        love.graphics.rectangle("fill", x, y, w, h)
        love.graphics.setColor(COLOR_JET_BLACK)
        love.graphics.setLineWidth(5)
        love.graphics.rectangle("line", x, y, w, h)
    end,

    drawLabel = function(self, label, x, y, w, h)
        love.graphics.setFont(LABEL_FONT) 
        love.graphics.setColor(COLOR_JET_BLACK)
        love.graphics.printf(label, x, y + (h - LABEL_FONT:getHeight()) / 2, w, "center")
    end,
}

local ARROW = {
    draw = function(self, label, x1, y1, x2, y2)
        love.graphics.setColor(COLOR_MEDIUM_YELLOW)
        love.graphics.setLineWidth(4)
        self:drawComponents(label, x1 * GRID_SIZE, y1 * GRID_SIZE, x2 * GRID_SIZE, y2 * GRID_SIZE)
    end,

    drawComponents = function(self, label, x1, y1, x2, y2)
        self:drawBody(x1, y1, x2, y2)
        self:drawHead(x1, y1, x2, y2)
        self:drawLabel(label, x1, y1, x2, y2)
    end,
   
    drawBody = function(self, x1, y1, x2, y2)
        love.graphics.line(x1, y1, x2, y2)
    end,

    drawHead = function(self, x1, y1, x2, y2)
        if x2 > x1 then
            self:drawHeadRight(x1, y1, x2, y2)
        else
            self:drawHeadLeft( x1, y1, x2, y2)
        end
    end,

    drawHeadRight = function(self, x1, y1, x2, y2)
        love.graphics.line(x2, y2, x2 - 24, y2 - 16)
        love.graphics.line(x2, y2, x2 - 24, y2 + 16)
    end,

    drawHeadLeft = function(self, x1, y1, x2, y2)
        love.graphics.line(x2, y2, x2 + 24, y2 - 16)
        love.graphics.line(x2, y2, x2 + 24, y2 + 16)
    end,

    drawLabel = function(self, label, x1, y1, x2, y2)
        love.graphics.setColor(COLOR_PURE_WHITE)
        love.graphics.printf(label, math.min(x1,  x2), y1 - LABEL_FONT:getHeight(), 
                                    math.abs(x2 - x1), "center")
    end,

}

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.draw()
-- Called By:     LOVE2D application, every single frame
--------------------------------------------------------------
function love.draw()
    PEGBOARD:draw()

    BOX:draw("Stand Left",   3, 7, 9, 7)
    BOX:draw("Stand Right", 20, 7, 9, 7)

    ARROW:draw("L On", 20,  9, 12,  9)
    ARROW:draw("R On", 12, 12, 20, 12)
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

-- ...
-- ...
-- ...

--------------------------------------------------------------
--               Static code - is executed last             --
--------------------------------------------------------------

love.window.setTitle("State Machine Viewer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

