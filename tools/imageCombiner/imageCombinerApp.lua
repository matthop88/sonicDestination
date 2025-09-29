--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local img1Path = "resources/" .. __IMAGE_1_PATH .. ".png"
local img2Path = "resources/" .. __IMAGE_2_PATH .. ".png"

local img1Data = love.image.newImageData(img1Path)
local image1   = love.graphics.newImage(img1Data)

local img2Data = love.image.newImageData(img2Path)
local image2   = love.graphics.newImage(img2Data)

local COMBINER = ({
    image1 = image1,
    image2 = image2,

    init = function(self)
        self.width  = math.max(self.image1:getWidth(),  self.image2:getWidth())
        self.height = self.image1:getHeight() + self.image2:getHeight()

        self.GRAFX = require("tools/lib/bufferedGraphics"):create(require("tools/lib/graphics"):create(), self.width, self.height)
    
        return self
    end,

    draw = function(self)
        self:renderImages()
        self.GRAFX:blitToScreen()
    end,

    renderImages = function(self)
        self.GRAFX:setColor(0, 0, 0)
        self.GRAFX:rectangle("fill", 0, 0, self.width, self.height)
        self.GRAFX:rectangle("fill", self.GRAFX:calculateViewport())

        self.GRAFX:setColor(1, 1, 1)
        self.GRAFX:draw(self.image1, 0, 0)
        self.GRAFX:draw(self.image2, 0, self.image1:getHeight())
    end,

    save = function(self)
        self.GRAFX:setScale(1, 1)
        self.GRAFX:setX(0)
        self.GRAFX:setY(0)
        self:renderImages()
        local fileData = self.GRAFX:saveImage("sampleCombinedImage")

        printToReadout("Changes have been saved (" .. fileData:getSize() .. " bytes.)")
        print("Saved to " .. love.filesystem.getSaveDirectory())
    end,

    keepImageInBounds = function(self)
        -- do nothing
    end,

    moveImage = function(self, deltaX, deltaY)
        self.GRAFX:moveImage(deltaX, deltaY)
    end,

    screenToImageCoordinates = function(self, screenX, screenY)
        return self.GRAFX:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        self.GRAFX:adjustScaleGeometrically(deltaScale)
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        self.GRAFX:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,
}):init()
  
--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Image Combiner")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

image1:setFilter("nearest", "nearest")
image2:setFilter("nearest", "nearest")

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    COMBINER:draw()
end

function love.keypressed(key)
    if key == "return" then
        COMBINER:save()
    end
end

-- ...

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
    :add("zooming",      { imageViewer = COMBINER,            })
    :add("scrolling",    
    { 
        imageViewer = COMBINER,
        scrollSpeed = 2400,          
    })
    :add("pause")
    :add("readout",      
    { 
        printFnName    = "printToReadout", 
        accessorFnName = "getReadout",
    })
    :add("timedFunctions",
    {
        {   secondsWait = 1, 
            callback = function() 
                getReadout():setSustain(180) 
                printToReadout("Press 'return' to save a combined image.") 
            end,
        },
    })


