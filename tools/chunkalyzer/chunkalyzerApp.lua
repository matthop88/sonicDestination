--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local WINDOW_WIDTH, WINDOW_HEIGHT = 1200, 800

local imgPath

if __WORLD_MAP_FILE ~= nil then
    imgPath = "tools/chunkalyzer/data/" .. __WORLD_MAP_FILE .. ".png"
end

local CHUNKALYZER_VIEW = ({
	init = function(self, imgPath)
		self.imgData = love.image.newImageData(imgPath)
		self.img     = love.graphics.newImage(self.imgData)
		self.img:setFilter("nearest", "nearest")
		
		self.GRAFX = require("tools/lib/graphics"):create()

		self:initQuads()

		return self
	end,

	initQuads = function(self)
		self.chunks = {}

		for y = 0, math.floor(self.img:getHeight() / 256) - 1 do
			for x = 0, math.floor(self.img:getWidth() / 256) - 1 do
				table.insert(self.chunks, { x = (x * 272) + 16, y = (y * 272) + 16, quad = love.graphics.newQuad(x * 256, y * 256, 256, 256, self.img:getWidth(), self.img:getHeight()) })
			end
		end
	end,

	draw = function(self)
		self.GRAFX:setColor(1, 1, 1)
		for _, c in ipairs(self.chunks) do
			self.GRAFX:draw(self.img, c.quad, c.x, c.y, 0, 1, 1)
		end
	end,

    keepImageInBounds = function(self)
        self.GRAFX:setX(math.min(0, math.max(self.GRAFX:getX(), (love.graphics:getWidth()  / self.GRAFX:getScale()) - self.img:getWidth())))
        self.GRAFX:setY(math.min(0, math.max(self.GRAFX:getY(), (love.graphics:getHeight() / self.GRAFX:getScale()) - self.img:getHeight())))
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
}):init(imgPath)

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

love.window.setTitle("Chunkalyzer")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, { display = 2 })

--------------------------------------------------------------
--                     LOVE2D Functions                     --
--------------------------------------------------------------

function love.draw()
    CHUNKALYZER_VIEW:draw()
end

-- ...
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
    :add("zooming",      { imageViewer = CHUNKALYZER_VIEW,            })
    :add("scrolling",    
    { 
    	imageViewer = CHUNKALYZER_VIEW,
    	scrollSpeed = 2400,          
    })
    :add("readout",      { printFnName = "printToReadout", })      

