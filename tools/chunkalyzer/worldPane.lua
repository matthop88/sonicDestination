--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local INSET = 16
local GRAFX = require("tools/lib/bufferedGraphics"):create(require("tools/lib/graphics"):create(), 1200, 800)

local OFFSET  = { x = 0, y = 0 }

local chunkAttributes = {
	leftMost   = nil,
	topMost    = nil,
	rightMost  = nil,
	bottomMost = nil,
}

local modes = {
	--[[
	{	message = "Select the leftmost Chunk on the Map.",   fn = function(x, y) chunkAttributes.leftMost   = x end	},
	{	message = "Select the topMost Chunk on the Map.",    fn = function(x, y) chunkAttributes.topMost    = y end },
	{	message = "Select the rightmost Chunk on the Map.",  fn = function(x, y) chunkAttributes.rightMost  = x end	},
	{	message = "Select the bottomMost Chunk on the Map.", fn = function(x, y) chunkAttributes.bottomMost = y end },
	--]]
	
	{   message = "Click anywhere to begin Chunkalyzing.",   fn = function(x, y) getReadout():setSustain(180)   end },
	
	index = 1,

	get   = function(self) return self[self.index]                      end,
	next  = function(self) self.index = math.min(self.index + 1, #self) end,
	prev  = function(self) self.index = math.max(self.index - 1, 1)     end,
	reset = function(self) self.index = 1                               end,
}

local prevGraphics = { x = GRAFX.x, y = GRAFX.y }

--------------------------------------------------------------
--              Static code - is executed first             --
--------------------------------------------------------------

return {
	isChunkVisible = true,

	yBlit = 0,

	image = nil,

	init = function(self, image)
		self.image = image
		return self
	end,

	draw = function(self)
        GRAFX:setColor(0, 0, 0)
        GRAFX:rectangle("fill", GRAFX:calculateViewport())

        self:drawWorldMap()
        
        if self.isChunkVisible and self.inFocus then self:drawCurrentChunk() end
    end,

    update = function(self, dt)
        self:updateChunkVisibility(dt)
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

    --------------------------------------------------------------
    --               Specialized Draw Functions                 --
    --------------------------------------------------------------

    drawWorldMap = function(self)
        GRAFX:setColor(1, 1, 1)
        GRAFX:draw(self.image, INSET, INSET)
    end,

    drawCurrentChunk = function(self)
        local cX, cY = self:getChunkXY(self:getMousePositionFn())
        local x,  y  = self:getWorldCoordinatesOfChunk(cX, cY)

        if love.mouse.isDown(1) then self:drawChunkSelection(x, y)
        else                         self:drawChunkOutline(  x, y) end
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

    blitToScreen = function(self, x, y)
		self.yBlit = y
        GRAFX:blitToScreen(x, y, { 1, 1, 1 }, 0, 1, 1)
    end,

    --------------------------------------------------------------
    --              Specialized Update Functions                --
    --------------------------------------------------------------

	gainFocus = function(self) self.inFocus = true  end,
	loseFocus = function(self) self.inFocus = false end,
	hasFocus  = function(self) return self.inFocus  end,
	
    updateChunkVisibility = function(self, dt)
        self.isChunkVisible = not self:isScreenInMotion()

        self:updateScreenMotionDetection(dt)
    end,

    isScreenInMotion = function(self)
        return GRAFX:getX() ~= prevGraphics.x or GRAFX:getY() ~= prevGraphics.y or GRAFX:getScale() ~= prevGraphics.scale
    end,

    updateScreenMotionDetection = function(self, dt)
        prevGraphics.x, prevGraphics.y, prevGraphics.scale = GRAFX:getX(), GRAFX:getY(), GRAFX:getScale()
    end,

    keepImageInBounds = function(self)
        GRAFX:setX(math.min(0, math.max(GRAFX:getX(), (love.graphics:getWidth()  / GRAFX:getScale()) - self:getPageWidth())))
        GRAFX:setY(math.max(math.min(-self.yBlit / GRAFX:getScale(), GRAFX:getY()), (love.graphics.getHeight() / GRAFX:getScale()) - self:getPageHeight()))
	end,

    getPageWidth  = function(self) return self.image:getWidth()  + (INSET * 2) end,
    getPageHeight = function(self) return self.image:getHeight() + (INSET * 2) end,

	moveImage = function(self, deltaX, deltaY)
		GRAFX:moveImage(deltaX, deltaY)
	end,

	screenToImageCoordinates = function(self, screenX, screenY)
        return GRAFX:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
        GRAFX:adjustScaleGeometrically(deltaScale)
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        GRAFX:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,

    --------------------------------------------------------------
    --          Specialized Event Response Functions            --
    --------------------------------------------------------------

    nextMode = function(self)
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

	getMousePositionFn = function(self)
		local mx, my = love.mouse.getPosition()
		return mx, my - self.yBlit
	end,
}
