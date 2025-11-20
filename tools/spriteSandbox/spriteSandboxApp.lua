--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local SANDBOX = require("tools/spriteSandbox/sandbox")

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Sprite Sandbox")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    SANDBOX:draw()
end

function love.update(dt)
    SANDBOX:update(dt)
end

function love.keypressed(key)
    SANDBOX:handleKeypressed(key)
end

function love.mousepressed(mx, my)
    SANDBOX:handleMousepressed(mx, my)
end

function love.mousereleased(mx, my)
    SANDBOX:handleMousereleased(mx, my)
end

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

-- ...
-- ...
-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("doubleClick",
    {
        accessorFnName = "getDoubleClick",
    })
    :add("keyRepeat", {
        interval    = 0.05,
        delay       = 0.5,
    })
    :add("scrolling",    { imageViewer = SANDBOX })
    :add("zooming",      { imageViewer = SANDBOX })    
    :add("questionBox",
    {   x = 1150,
        useDoubleClick = true,
        getDoubleClickFn = getDoubleClick,
        lines = {
            tabSize = 200,
            { "Arrow Keys",   "- Scroll Sandbox"      },
            { "z/a",          "- Zoom in/out"     },
            { "s",            "- Toggle Sprite Placement Mode" },
            "",
            "Sprite Placement Mode_",
            { "Mouse Press",  "- Place new sprite on screen"    },
            { "Option",       "- Stay in Sprite Placement Mode when clicking" },
            { "Escape",       "- Exit Sprite Placement Mode"    },
        },
    })
