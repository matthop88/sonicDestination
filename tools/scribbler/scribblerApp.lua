--------------------------------------------------------------
--                 Functional Specifications                --
--------------------------------------------------------------

--[[
    Short description:
        Can make simple, single-color drawings or "scribblings",
        with undo/redo functionality and saving and loading from disk.
        Straight line, rectangle and text support
        Basic colors are supported, as well as snapping to grid.
--]]

--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 768

local picture     = require("tools/scribbler/picture")
local toolManager = require("tools/scribbler/jotTools/manager"):init(picture)
local showGrid    = false

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    if showGrid then drawGrid() end
    picture:draw()
    toolManager:draw()
end

function love.update(dt)            toolManager:update(dt)            end
function love.mousepressed(mx, my)  toolManager:mousepressed(mx, my)  end
function love.mousereleased(mx, my) toolManager:mousereleased(mx, my) end

function love.keypressed(key)
    if     key == "s" and love.keyboard.isDown("lgui", "rgui") then picture:save()
    elseif key == "z" and love.keyboard.isDown("lgui", "rgui") then implementUndoOrRedo()
    elseif key == "g"                                          then showGrid = not showGrid
    else                                                            toolManager:keypressed(key) end
end

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function implementUndoOrRedo()
    if love.keyboard.isDown("lshift", "rshift") then picture:redo()
    else                                             picture:undo() end
end

function drawGrid()
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.setLineWidth(1)

    for x = 0, 1024, 32 do love.graphics.line(x, 0, x,  768) end
    for y = 0, 768,  32 do love.graphics.line(0, y, 1024, y) end
end

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

if __SCRIBBLER_FILE then picture:load(__SCRIBBLER_FILE) end
