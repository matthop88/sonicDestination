--[[

--------------------------------------------------------------
--                  Functional Specifications               --
--------------------------------------------------------------

[ ] 1. Program "automagically" finds borders of all sprites in image
[ ] 2. Border is drawn when mouse moves over a sprite
[ ] 3. When a sprite is clicked on, x, y, width and height are
       displayed on screen.

                    Border Finding Algorithm
                    ------------------------
       Scan each line of image.
       Look for edges of borders.

       Left edge:  Transition from Margin Background color
                                to Sprite Background color.

       Right edge: Transition from Sprite Background color
                                to Margin Background color.

       Same transition applies to top and bottom edges.

       Border information is captured in a data structure.

--]]

--------------------------------------------------------------
--                      Global Variables                    --
--------------------------------------------------------------

MARGIN_BACKGROUND_COLOR = { r = 0.05, g = 0.28, b = 0.03 }
SPRITE_BACKGROUND_COLOR = { r = 0.26, g = 0.60, b = 0.19 }

WINDOW_WIDTH, WINDOW_HEIGHT = 1024, 768

--------------------------------------------------------------
--                      Local Variables                     --
--------------------------------------------------------------

local scanner = {
    y              = 0,
    nextY          = 0,
    imageViewer    = nil,
    widthInPixels  = nil,
    heightInPixels = nil,
    linesPerSecond = 500,
    running        = false,
    matchesFound   = 0,

    start = function(self)
        self.imageViewer = getImageViewer()
        self.widthInPixels, self.heightInPixels = self.imageViewer:getImageSize()
        self.running = true
    end,
    
    update = function(self, dt)
        -- Scan all pixels in image pixel row in a systematic way
        -- Print out the coordinates of every pixel
        -- that matches MARGIN_BACKGROUND_COLOR
        
        if self.running then
            self.nextY = self.y + (self.linesPerSecond * dt)
            for y = self.y, math.floor(self.nextY - 1) do
                if y < self.heightInPixels then
                    for x = 0, self.widthInPixels - 1 do
                        self:findMatchAt(x, y)
                    end
                self.y = math.floor(self.nextY)
                else
                    self:stopScanning()
                    break
                end
            end
        end
    end,

    findMatchAt = function(self, x, y)
        local pixelColor = self:rgbToColor(self.imageViewer:getImagePixelAt(x, y))
        if self:colorsMatch(pixelColor, MARGIN_BACKGROUND_COLOR) then
            print("Found MARGIN_BACKGROUND_COLOR at x = " .. x .. ", y = " .. y)
            self.matchesFound = self.matchesFound + 1
        end
    end,

    rgbToColor  = function(self, r, g, b)
        return { r = r, g = g, b = b }
    end,

    colorsMatch = function(self, c1, c2)
        return math.abs(c1.r - c2.r) < 0.005
           and math.abs(c1.g - c2.g) < 0.005 
           and math.abs(c1.b - c2.b) < 0.005
    end,

    stopScanning = function(self)
        self.running = false
        love.window.setTitle("Sprite Sheet Slicer")
        print("Matches Found: " .. self.matchesFound)
    end,
}

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Sprite Sheet Slicer - SLICING...")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })
-- ...

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

-- Function Name: love.draw()
-- Called By:	  LOVE2D application, every single frame
--------------------------------------------------------------
function love.draw()
    -- All drawing code goes here
end

function love.update(dt)
    scanner:update(dt)
end

-- ...

--------------------------------------------------------------
--                  Specialized Functions                   --
--------------------------------------------------------------

function getImageViewer()
    -- Overridden by imageViewer plugin
end

--------------------------------------------------------------
--                          Plugins                         --
--------------------------------------------------------------

PLUGINS = require("plugins/engine")
    :add("imageViewer",
    {
        imagePath      = "resources/images/spriteSheets/sonic1.png",
        accessorFnName = "getImageViewer"
    })
    :add("zooming",   { imageViewer = getImageViewer() })
    :add("scrolling", { imageViewer = getImageViewer() })

--------------------------------------------------------------
--             Static code - is executed last               --
--------------------------------------------------------------

scanner:start()
