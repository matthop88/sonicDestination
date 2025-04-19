--------------------------------------------------------------
--                 Functional Specifications                --
--------------------------------------------------------------

--[[
     Short description:
        An image of choice is drawn to the screen.
        Can click on any pixel and set the pixel color to be
        transparent throughout the image.
        Changes can be saved or reverted.
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
--                        Plugins                           --
--------------------------------------------------------------

-- ...
-- ...
-- ...

--------------------------------------------------------------
--               Static code - is executed last             --
--------------------------------------------------------------

love.window.setTitle("Transparency Editor")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })
