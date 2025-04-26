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
        [X] Command Z undoes one action at a time
        [X] Shift Command Z redoes one action at a time
        [X] 'G' shows a grid
        [X] Shift allows snapping to grid
        [X] Command-S saves to disk
        [X] File name entered as command-line parameter loads from file

        ------------------------------ STRETCH GOALS -------------------------------

        [X] 'L' draws a line from pt 1 to pt 2
        [X] 'R' draws a rect with upper-left corner at pt 1, lower left at pt 2
        [ ] 'T' allows typing of text at mouse position. Left-justified
        [X] Allow cycling through various colors

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

local mousePosition = require("tools/scribbler/mousePosition")
local picture       = require("tools/scribbler/picture")
local scribbleTool  = require("tools/scribbler/jotTools/scribble"):init(picture)
local lineTool      = require("tools/scribbler/jotTools/line"    ):init(picture)
local rectTool      = require("tools/scribbler/jotTools/rect"    ):init(picture)
local textTool      = require("tools/scribbler/jotTools/text"    ):init(picture)

local currentTool   = scribbleTool

local showGrid      = false

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    if showGrid then drawGrid() end
    picture:draw()
    currentTool:draw(mousePosition:get())
end

function love.update(dt)
    mousePosition:update()
    if mousePosition:isChanged() then
        if love.mouse.isDown(1) then currentTool:penDragged(mousePosition:get())
        else                         currentTool:penMoved(mousePosition:get())
        end
     end
end

function love.mousepressed(mx, my)
    currentTool:penDown(mousePosition:get())
end

function love.mousereleased(mx, my)
    currentTool:penUp(mousePosition:get())
end

function love.keypressed(key)
    if     key == "l" then currentTool = lineTool
    elseif key == "r" then currentTool = rectTool
    elseif key == "s" and love.keyboard.isDown("lgui", "rgui") then
        picture:save()
    elseif key == "s" then currentTool = scribbleTool
    elseif key == "t" then currentTool = textTool
    elseif key == "g" then showGrid    = not showGrid
    elseif key == "z" and love.keyboard.isDown("lgui", "rgui") then
        implementUndoOrRedo()
    elseif currentTool.keypressed then currentTool:keypressed(key)
    end
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function implementUndoOrRedo()
    if love.keyboard.isDown("lshift", "rshift") then picture:redo()
    else                                             picture:undo()
    end
end

function drawGrid()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.setLineWidth(1)

    for x = 0, 1024, 32 do
        love.graphics.line(x, 0, x,  768)
    end

    for y = 0, 768,  32 do
        love.graphics.line(0, y, 1024, y)
    end
end

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

if __SCRIBBLER_FILE then
    picture:load(__SCRIBBLER_FILE)
end

