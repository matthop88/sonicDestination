--------------------------------------------------------------
--                 Functional Specifications                --
--------------------------------------------------------------

--[[
    Short description:
        Can make simple, single-color drawings or "scribblings",
        with undo/redo functionality and saving and loading from disk.
        Stretch goal: straight line, rectangle and text support

    Features:
        [ ] Mouse-down draws lines between mouse position and previous mouse position
        [ ] Mouse-up allows movement without drawing
        [ ] Command Z undoes one action at a time
        [ ] Shift Command Z redoes one action at a time
        [ ] 'G' shows a grid
        [ ] Shift allows snapping to grid
        [ ] Command-S saves to disk
        [ ] File name entered as command-line parameter loads from file

        ------------------------------ STRETCH GOALS -------------------------------

        [ ] 'L' draws a line from pt 1 to pt 2
        [ ] 'R' draws a rect with upper-left corner at pt 1, lower left at pt 2
        [ ] 'T' allows typing of text at mouse position. Left-justified
        [ ] 'C' allows cycling through various colors

    Basic Design:
        The single object that we are building is the PICTURE.
        The Picture is comprised of a series of JOTS.
        Each JOT may either be:
        1. A Scribble
        2. A Polygon (comprised of straight lines)
        3. A Rectangle
        4. A Text Field

--]]

--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 768

local prevMousePosition = ({
    x, y = nil, nil,
        
    init = function(self)
        self.x, self.y = love.mouse.getPosition()
        return self
    end,
        
}):init()

local scribbleJot = { 
    
    draw = function(self)
        -- ...
    end,

    penUp = function(self, mx, my)
        printToReadout("Pen up at x = " .. mx .. ", y = " .. my)
    end,

    penDown = function(self, mx, my)
        printToReadout("Pen down at x = " .. mx .. ", y = " .. my)
    end,

    penMoved = function(self, mx, my)
        printToReadout("Pen moved to x = " .. mx .. ", y = " .. my)
    end,

    penDragged = function(self, mx, my)
        printToReadout("Pen dragged to x = " .. mx .. ", y = " .. my)
    end,

}
--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    scribbleJot:draw()
end

function love.update(dt)
    local mx, my = love.mouse.getPosition()
    if mx ~= prevMousePosition.x or my ~= prevMousePosition.y then
        if love.mouse.isDown(1) then
            scribbleJot:penDragged(mx, my)
        else
            scribbleJot:penMoved(mx, my)
        end
        
        prevMousePosition.x, prevMousePosition.y = mx, my
     end
end

function love.mousepressed(mx, my)
    scribbleJot:penDown(mx, my)
end

function love.mousereleased(mx, my)
    scribbleJot:penUp(mx, my)
end

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
    :add("readout", { printFnName = "printToReadout" } )

--------------------------------------------------------------
--               Static code - is executed last             --
--------------------------------------------------------------

love.window.setTitle("Scribbler Drawing Application")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

