--------------------------------------------------------------
--                 Functional Specifications                --
--------------------------------------------------------------

--[[
     Short description:
        An image of choice is drawn to the screen.
        Can click on any pixel and set the pixel color to be
        transparent throughout the image.
        Changes can be saved or reverted.

     Features:
        [X] Image can be scrolled using the up, down,
            left and right arrow keys.
        [X] Image can be zoomed in using the 'z' key
            and zoomed out using the 'a' key
        [X] Clicking on any pixel of the image shows
            a filled-in rectangle of the color for verification purposes.
        [ ] Once a color is selected, pressing 'space' will
            turn the selected color transparent.
        [ ] Pressing 'escape' will revert the transparency.
        [ ] Pressing 'return' will save the edited image to disk.
--]]

--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- ...
-- ...
-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

onColorSelected = function(color)
    printToReadout("Press 'space' to make the selected color transparent.")
end

--------------------------------------------------------------
--                        Plugins                           --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("imageViewer",
    {
        imagePath       = "resources/images/spriteSheets/sonic1.png",
        accessorFnName  = "getImageViewer"
    })
    :add("zooming",      { imageViewer = getImageViewer() })
    :add("scrolling",    { imageViewer = getImageViewer() })
    :add("selectColor", 
    {
        imageViewer     = getImageViewer(),
        onColorSelected = onColorSelected,
    })
    :add("readout",
    {
        printFnName     = "printToReadout",
        echoToConsole   = true,
    })

--------------------------------------------------------------
--               Static code - is executed last             --
--------------------------------------------------------------

love.window.setTitle("Transparency Editor")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })
