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

local mousePosition = ({
    x,     y     = nil, nil,
    prevX, prevY = nil, nil,
        
    init = function(self)
        self.x,     self.y     = love.mouse.getPosition()
        self.prevX, self.prevY = self.x, self.y
        return self
    end,
        
    isChanged = function(self)
        return self.x ~= self.prevX or self.y ~= self.prevY
    end,

    update = function(self)
        self.prevX, self.prevY = self.x, self.y
        self.x,     self.y     = love.mouse.getPosition()
    end,

    get = function(self)
        return self.x, self.y
    end,
        
}):init()

local lineJot = { 

    data = { },
    
    draw = function(self, mx, my)
        love.graphics.setColor(1, 1, 1)

        local prevX, prevY = nil, nil
        
        for n, pt in ipairs(self.data) do
            if n == 1 then
                love.graphics.rectangle("fill", pt.x - 2, pt.y - 2, 5, 5)
            else
                love.graphics.line(prevX, prevY, pt.x, pt.y)
            end
            prevX, prevY = pt.x, pt.y
        end
        
        love.mouse.setVisible(false)
        love.graphics.rectangle("fill", mx - 2, my - 2, 5, 5)
    end,

    penUp = function(self, mx, my)
        printToReadout("Pen up at x = " .. mx .. ", y = " .. my)
    end,

    penDown = function(self, mx, my)
        printToReadout("Pen down at x = " .. mx .. ", y = " .. my)
        table.insert(self.data, { x = mx, y = my })
    end,

    penMoved = function(self, mx, my)
        printToReadout("Pen moved to x = " .. mx .. ", y = " .. my)
    end,

    penDragged = function(self, mx, my)
        printToReadout("Pen dragged to x = " .. mx .. ", y = " .. my)
    end,

}

local scribbleJot = { 

    data = { },
    
    draw = function(self, mx, my)
        love.graphics.setColor(1, 1, 1)

        local prevX, prevY = nil, nil
        
        for n, pt in ipairs(self.data) do
            if n == 1 then
                love.graphics.rectangle("fill", pt.x - 2, pt.y - 2, 5, 5)
            else
                love.graphics.line(prevX, prevY, pt.x, pt.y)
            end
            prevX, prevY = pt.x, pt.y
        end
        
        love.mouse.setVisible(false)
        love.graphics.rectangle("fill", mx - 2, my - 2, 5, 5)
    end,

    penUp = function(self, mx, my)
        printToReadout("Pen up at x = " .. mx .. ", y = " .. my)
    end,

    penDown = function(self, mx, my)
        printToReadout("Pen down at x = " .. mx .. ", y = " .. my)
        self.data = {
            { x = mx, y = my }
        }
    end,

    penMoved = function(self, mx, my)
        printToReadout("Pen moved to x = " .. mx .. ", y = " .. my)
    end,

    penDragged = function(self, mx, my)
        printToReadout("Pen dragged to x = " .. mx .. ", y = " .. my)
        table.insert(self.data, { x = mx, y = my })
    end,

}

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    scribbleJot:draw(mousePosition:get())
end

function love.update(dt)
    if mousePosition:isChanged() then
        if love.mouse.isDown(1) then
            scribbleJot:penDragged(mousePosition:get())
        else
            scribbleJot:penMoved(mousePosition:get())
        end
     end
    mousePosition:update()
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

