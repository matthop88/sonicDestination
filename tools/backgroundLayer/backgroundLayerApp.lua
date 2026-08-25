
--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Background Layer Tool")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

if __PARAMS["backgroundTestData"] then
    require "tools/backgroundLayer/backgroundTester"
else
    require "tools/backgroundLayer/backgroundSlicer"
end
