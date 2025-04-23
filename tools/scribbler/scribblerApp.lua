--------------------------------------------------------------
--                 Functional Specifications                --
--------------------------------------------------------------

--[[
    Short description:
        Can make simple, single-color drawings or "scribblings",
        with undo/redo functionality and saving and loading from disk.
        Stretch goal: straight line, rectangle and text support

    Features:
        [X] Mouse-down draws lines between mouse position and previous mouse position
        [X] Mouse-up allows movement without drawing
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

local picture      = require("tools/scribbler/picture")
local scribbleTool = require("tools/scribbler/jotTools/scribble"):init(picture)
local lineTool     = require("tools/scribbler/jotTools/line"    ):init(picture)
local rectTool     = require("tools/scribbler/jotTools/rect"    ):init(picture)

local currentTool = scribbleTool

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    picture:draw()
    currentTool:draw(mousePosition:get())
end

function love.update(dt)
    mousePosition:update()
    
    if mousePosition:isChanged() then
        if love.mouse.isDown(1) then
            currentTool:penDragged(mousePosition:get())
        else
            currentTool:penMoved(mousePosition:get())
        end
     end
end

function love.mousepressed(mx, my)
    currentTool:penDown(mx, my)
end

function love.mousereleased(mx, my)
    currentTool:penUp(mx, my)
end

function love.keypressed(key)
    if     key == "l" then
        currentTool = lineTool
    elseif key == "r" then
        currentTool = rectTool
    elseif key == "s" then
        currentTool = scribbleTool
    elseif key == "z" and love.keyboard.isDown("lgui", "rgui") then
        if love.keyboard.isDown("lshift", "rshift") then
            picture:redo()
        else
            picture:undo()
        end
    end
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

