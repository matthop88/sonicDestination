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
        [ ] Boxes are drawn with labels in the center
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
local COLOR_MEDIUM_YELLOW         = { 1, 1,   0.5 }
local COLOR_PEGBOARD_GREEN        = { 0, 0.3, 0.3 }
local COLOR_PEGHOLES              = { 1, 1,   1,  0.5 }

local PEGBOARD_FONT               = love.graphics.newFont(32)

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

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.draw()
-- Called By:     LOVE2D application, every single frame
--------------------------------------------------------------
function love.draw()
    PEGBOARD:draw()

    drawBox("Stand Left",   3, 7, 9, 7)
    drawBox("Stand Right", 20, 7, 9, 7)
end

-- ...
-- ...

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function drawBox(label, x, y, w, h)
    drawBoxShape(x, y, w, h)
    drawBoxLabel(label, x, y, w, h)
end

function drawBoxShape(x, y, w, h)
    love.graphics.setColor(COLOR_MEDIUM_YELLOW)
    love.graphics.rectangle("fill", x * 32, y * 32, w * 32, h * 32)
    love.graphics.setColor(COLOR_JET_BLACK)
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line", x * 32, y * 32, w * 32, h * 32)
end

function drawBoxLabel(label, x, y, w, h)
    love.graphics.setFont(PEGBOARD_FONT) 
    love.graphics.setColor(COLOR_JET_BLACK)
    love.graphics.printf(label, x * 32, (y * 32) + (h * 16) - 16, w * 32, "center")
end

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

