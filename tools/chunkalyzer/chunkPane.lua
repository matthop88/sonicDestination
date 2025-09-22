--------------------------------------------------------------
--                     Local Variables                      --
--------------------------------------------------------------

local GRAFX = require("tools/lib/bufferedGraphics"):create(require("tools/lib/graphics"):create(), 1200, 800)

local prevGraphics = { x = GRAFX.x, y = GRAFX.y }

return {
    isChunkVisible = true,

    yBlit = 0,

	image = nil,

	curatedChunks = {
        {   x = 0,    y = 768, },
        {   x = 256,  y = 768, },
        {   x = 512,  y = 768, },
        {   x = 768,  y = 768, },
        {   x = 1024, y = 768, },
        {   x = 1280, y = 768, },
        {   x = 1536, y = 768, },
        {   x = 1792, y = 768, },
        {   x = 2048, y = 768, },
        {   x = 2304, y = 768, },
		{   x = 2460, y = 768, },
        {   x = 2816, y = 768, },
        {   x = 3072, y = 768, },
        {   x = 3328, y = 768, },
        {   x = 3584, y = 768, },
        {   x = 3840, y = 768, },
        {   x = 4096, y = 768, },
        {   x = 4352, y = 768, },
    },
	
	init = function(self, image)
		self.image = image
		self:initChunks()
		
		return self
	end,

	initChunks = function(self)
		for _, c in ipairs(self.curatedChunks) do
			c.quad = love.graphics.newQuad(c.x, c.y, 256, 256, self.image:getWidth(), self.image:getHeight())
		end
	end,

	draw = function(self)
        GRAFX:setColor(0.2, 0.2, 0.2)
        GRAFX:rectangle("fill", GRAFX:calculateViewport())

        GRAFX:setFontSize(32)
		for n, c in ipairs(self.curatedChunks) do
			GRAFX:setColor(1, 1, 1)
            local x, y = self:getChunkXYByNumber(n)
			GRAFX:draw(self.image, c.quad, x + 16, y + 16, 0, 1, 1)
			GRAFX:setColor(0, 0, 0, 0.4)
			local numberWidth = GRAFX:getFontWidth("" .. n) + 8
			GRAFX:rectangle("fill", x + 144 - (numberWidth / 2), y + 128, numberWidth, 32)
			GRAFX:setColor(1, 1, 1)
			GRAFX:printf("" .. n, x + 16, y + 126, 256, "center")
		end

        if self.isChunkVisible and self.inFocus then self:drawCurrentChunk() end
    end,

    update = function(self, dt)
        self:updateChunkVisibility(dt)
		self:keepImageInBounds()
    end,

    handleKeypressed = function(self, key)
        -- Do nothing
    end,

    handleMousepressed = function(self, mx, my)
        -- Do nothing
    end,

    --------------------------------------------------------------
    --               Specialized Draw Functions                 --
    --------------------------------------------------------------

    blitToScreen = function(self, x, y)
        GRAFX:blitToScreen(x, y, { 1, 1, 1 }, 0, 1, 1)
        self.yBlit = y
    end,

    drawCurrentChunk = function(self)
        local cX, cY = self:getChunkXY(self:getMousePositionFn())
		local chunkNum = self:getChunkN(cX, cY)
		if chunkNum > 0 and chunkNum <= #self.curatedChunks then
        	local x,  y  = self:getWorldCoordinatesOfChunk(cX, cY)

        	GRAFX:setColor(1, 1, 1)
        	GRAFX:setLineWidth(3)
        	GRAFX:rectangle("line", x - 2, y - 2, 260, 260)
		end
    end,

	getChunkXYByNumber = function(self, n)
		local x = ((n - 1) % 16) * 272
		local y = math.floor((n - 1) / 16) * 272
		return x, y
	end,
	
    getChunkXY = function(self, x, y)
        local imgX, imgY = GRAFX:screenToImageCoordinates(x, y)
        return math.floor(imgX / 272), math.floor(imgY / 272)
    end,

	getChunkN = function(self, cX, cY)
		if cX < 0 or cX > 15 then return - 1
		else                      return (cY * 16) + cX + 1   end
	end,

    getWorldCoordinatesOfChunk = function(self, cX, cY)
        return (cX * 272) + 16, (cY * 272) + 16
    end,

    --------------------------------------------------------------
    --              Specialized Update Functions                --
    --------------------------------------------------------------

	addChunk  = function(self, x, y)
        local newChunk = { x = x, y = y, quad = love.graphics.newQuad(x, y, 256, 256, self.image:getWidth(), self.image:getHeight()) }
        table.insert(self.curatedChunks, newChunk)
    end,

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
        local width  = 16 * 272
        local height = (math.floor((#self.curatedChunks - 1) / 16) + 1) * 272
        GRAFX:setX(math.min(0, math.max(GRAFX:getX(), ((love.graphics:getWidth()  - 16)              / GRAFX:getScale()) - width)))
        GRAFX:setY(math.min(0, math.max(GRAFX:getY(), ((love.graphics:getHeight() - self.yBlit - 16) / GRAFX:getScale()) - height)))
    end,

    moveImage = function(self, deltaX, deltaY)
        GRAFX:moveImage(deltaX / 3, deltaY / 3)
    end,

	screenToImageCoordinates = function(self, screenX, screenY)
        return GRAFX:screenToImageCoordinates(screenX, screenY)
    end,

    adjustScaleGeometrically = function(self, deltaScale)
		if (deltaScale < 0 and GRAFX:getScale() >= 0.25) or (deltaScale > 0 and GRAFX:getScale() <= 5.0) then
			GRAFX:adjustScaleGeometrically(deltaScale)
		end
    end,

    syncImageCoordinatesWithScreen = function(self, imageX, imageY, screenX, screenY)
        GRAFX:syncImageCoordinatesWithScreen(imageX, imageY, screenX, screenY)
    end,

	getMousePositionFn = function(self)
        local mx, my = love.mouse.getPosition()
        return mx, my - self.yBlit
    end,
}
