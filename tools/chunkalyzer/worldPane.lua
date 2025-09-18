--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local INSET = 16
local GRAFX = require("tools/lib/graphics"):create()

local imgPath

if __WORLD_MAP_FILE ~= nil then
    imgPath = "tools/chunkalyzer/data/" .. __WORLD_MAP_FILE .. ".png"
end

local imgData = love.image.newImageData(imgPath)
local img     = love.graphics.newImage(imgData)

local OFFSET  = { x = 0, y = 0 }

local chunkAttributes = {
	leftMost   = nil,
	topMost    = nil,
	rightMost  = nil,
	bottomMost = nil,
}

local modes = {
	{	message = "Select the leftmost Chunk on the Map.",   fn = function(x, y) chunkAttributes.leftMost   = x end	},
	{	message = "Select the topMost Chunk on the Map.",    fn = function(x, y) chunkAttributes.topMost    = y end },
	{	message = "Select the rightmost Chunk on the Map.",  fn = function(x, y) chunkAttributes.rightMost  = x end	},
	{	message = "Select the bottomMost Chunk on the Map.", fn = function(x, y) chunkAttributes.bottomMost = y end },
	{   message = "Click anywhere to begin Chunkalyzing.",   fn = function(x, y) getReadout():setSustain(180)   end },
	{	message = nil,                                       fn = nil												},

	index = 1,

	get   = function(self) return self[self.index]                      end,
	next  = function(self) self.index = math.min(self.index + 1, #self) end,
	prev  = function(self) self.index = math.max(self.index - 1, 1)     end,
	reset = function(self) self.index = 1                               end,
}

local prevChunk = {}

local prevMouse = { x = 0, y = 0 }

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

img:setFilter("nearest", "nearest")

return {
	getGraphics = function(self) return GRAFX end,
	
	draw = function(self)
        self:drawWorldMap()
        self:drawCurrentChunk()
    end,

    update = function(self, dt)
        self:keepImageInBounds()
    end,

    handleKeypressed = function(self, key)
        if     key == "optionleft"  then OFFSET.x = math.max(0,   OFFSET.x - 1)
        elseif key == "optionright" then OFFSET.x = math.min(128, OFFSET.x + 1)
        elseif key == "optionup"    then OFFSET.y = math.max(0,   OFFSET.y - 1)
        elseif key == "optiondown"  then OFFSET.y = math.min(128, OFFSET.y + 1)
        elseif key == "backspace"   then self:prevMode()
     	elseif key == "escape"      then self:resetMode()
    	end
    end,

    handleMousepressed = function(self, mx, my)
        local cX, cY = self:getChunkXY(mx, my)
        local currentMode = modes:get()

        if currentMode.fn then currentMode.fn(cX, cY) end
        
        self:nextMode()
    end,

    drawWorldMap = function(self)
        GRAFX:setColor(1, 1, 1)
        GRAFX:draw(img, INSET, INSET)
    end,

    drawCurrentChunk = function(self)
        local cX, cY = self:getChunkXYFromMouse()
        local x,  y  = self:getWorldCoordinatesOfChunk(cX, cY)

        if love.mouse.isDown(1) then self:drawChunkSelection(x, y)
        else                         self:drawChunkOutline(  x, y) end
    end,

    getChunkXYFromMouse = function(self)
		local mx, my = love.mouse.getPosition()
		if mx ~= prevMouse.x or my ~= prevMouse.y or prevChunk.x == nil then
			prevMouse.x, prevMouse.y = mx, my
			prevChunk.x, prevChunk.y = self:getChunkXY(mx, my)
		end
		return prevChunk.x, prevChunk.y
	end,

	getChunkXY = function(self, x, y)
        local imgX, imgY = GRAFX:screenToImageCoordinates(x, y)
        return math.floor(imgX / 256), math.floor(imgY / 256)
    end,

    getWorldCoordinatesOfChunk = function(self, cX, cY)
        return (cX * 256) + INSET + OFFSET.x, (cY * 256) + INSET + OFFSET.y
    end,

    drawChunkSelection = function(self, x, y)
        GRAFX:setColor(1, 1, 0, 0.7)
        GRAFX:rectangle("fill", x, y, 256, 256)
    end,

    drawChunkOutline = function(self, x, y)
        GRAFX:setColor(1, 1, 1)
        GRAFX:setLineWidth(3)
        GRAFX:rectangle("line", x - 2, y - 2, 260, 260)
    end,

    keepImageInBounds = function(self)
        GRAFX.x = math.min(0, math.max(GRAFX.x, (love.graphics:getWidth()  / GRAFX.scale) - self:getPageWidth()))
        GRAFX.y = math.min(0, math.max(GRAFX.y, (love.graphics:getHeight() / GRAFX.scale) - self:getPageHeight()))
    end,

    getPageWidth  = function(self) return img:getWidth()  + (INSET * 2) end,
    getPageHeight = function(self) return img:getHeight() + (INSET * 2) end,

    nextMode       = function(self)
    	modes:next()
        self:refreshMode()
    end,

    prevMode = function(self)
    	modes:prev()
    	self:refreshMode()
    end,

    resetMode = function(self)
    	modes:reset()
    	getReadout():setSustain(1800)
    	self:refreshMode()
    end,

    refreshMode = function(self)
    	currentMode = modes:get()
    	if currentMode.message then printToReadout(currentMode.message) end
    end,
}

