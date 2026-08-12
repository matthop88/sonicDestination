
--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 600

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Image Capture Tool")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

local subImages = {
    { name = "clouds1",       x = 24, y = 181, w = 3840, h = 32,  },
    { name = "clouds2",       x = 24, y = 221, w = 3840, h = 16,  },
    { name = "clouds3",       x = 24, y = 245, w = 3840, h = 16,  },
    { name = "mountainPeaks", x = 24, y = 269, w = 8192, h = 48,  },
    { name = "mountains",     x = 24, y = 325, w = 8192, h = 40,  },
    { name = "ocean",         x = 24, y = 373, w = 3840, h = 104, },
}


local imgPath = "game/resources/images/backgrounds/ghzBG.png"

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.mousepressed(mx, my)
    local imageViewer = getImageViewer()
    createBackgroundFile()
end

-- ...
-- ...

--------------------------------------------------------------
--                   Specialized Functions                  --
--------------------------------------------------------------

function drawOverlays()
    local imageViewer = getImageViewer()
    for _, subImg in ipairs(subImages) do
        local x, y, w, h = imageViewer:imageToScreenRect(subImg.x, subImg.y, subImg.w, subImg.h)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", x, y, w, h)
    end
end

function createBackgroundFile()
    local w = 8192
    local h = 256 * 6
    local GRAFX = require("tools/lib/bufferedGraphics"):create(require("tools/lib/graphics"):create(), w, h)
        
    for n, subImg in ipairs(subImages) do
        drawSubImage(GRAFX, n)
    end
    love.filesystem.createDirectory("resources/images/backgrounds")
    local savedImage = GRAFX:saveImage("resources/images/backgrounds/ghzBGImg")    
    printToReadout("Changes have been saved (" .. savedImage:getSize() .. " bytes.)")
    print("Saved to " .. love.filesystem.getSaveDirectory())
end

function drawSubImage(GRAFX, n)
    local mpRect = subImages[n]
    local imageW, imageH = getImageViewer():getImageSize()
    local quad = love.graphics.newQuad(mpRect.x, mpRect.y, mpRect.w, mpRect.h, imageW, imageH)
    GRAFX:setColor(1, 1, 1)
    GRAFX:draw(getImageViewer():getImage(), quad, 0, (n - 1) * 256, 0, 1, 1)
end

    
-- ...

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("modKeyEnabler")
    :add("imageViewer", 
    { 
        imagePath         = imgPath,
        accessorFnName    = "getImageViewer"
    })
    :add("drawingLayer", { drawingFn      = drawOverlays     })
    :add("readout",      { printFnName    = "printToReadout" })
    :add("zooming",      { imageViewer    = getImageViewer() })
    :add("scrolling",    { imageViewer    = getImageViewer() })
