--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.load()
-- Called By:     LOVE2D application, once during start
-- Parameters:    args - list of command-line arguments
--                       passed by user in console
--------------------------------------------------------------
function love.load(args)
    if args[1] == "inspector" then
        __INSPECTOR_FILE = args[2]
        require "tools/colorInspector/inspector"
    elseif args[1] == "slicer" then
        __SLICER_FILE = args[2]
        require "tools/spriteSheetSlicer/slicerApp"
    else
        PATH_PREFIX = "game/"
        require "game/main"
    end
end

